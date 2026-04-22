// Components catalog page used by the docs app.
//
// Renders the grid/list of component tiles and links to each component's
// example wrapper page. This is part of the documentation scaffolding rather
// than a demo unit. Comments added only; behavior unchanged.
import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

const kComponentsMode = ComponentsMode.normal;

class WIPComponentCard extends StatelessWidget implements IComponentPage {
  @override
  final String title;

  const WIPComponentCard({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: ComponentCard(
        name: '-',
        title: title,
        center: true,
        example: const PrimaryBadge(child: Text('Work in Progress')),
      ),
    );
  }
}

abstract class IComponentPage extends Widget {
  const IComponentPage({super.key});

  String get title;
}

class ComponentCard extends StatefulWidget implements IComponentPage {
  final String name;
  @override
  final String title;
  final Widget example;
  final bool center;
  final bool fit;
  final bool reverse;
  final bool reverseVertical;
  final double horizontalOffset;
  final double verticalOffset;
  final double scale;
  const ComponentCard({
    super.key,
    required this.name,
    required this.title,
    required this.example,
    this.center = false,
    this.fit = false,
    this.reverse = false,
    this.reverseVertical = false,
    this.horizontalOffset = 30,
    this.verticalOffset = 20,
    this.scale = 0.8,
  });

  @override
  State<ComponentCard> createState() => _ComponentCardState();
}

enum ComponentsMode { normal, capture }

class _ComponentCardState extends State<ComponentCard> {
  bool _hovering = false;
  final GlobalKey repaintKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final componentsMode = Data.of<ComponentsMode>(context);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: componentsMode == ComponentsMode.normal
          ? null
          : () {
              final render =
                  repaintKey.currentContext!.findRenderObject()
                      as RenderRepaintBoundary;
              render.toImage().then((value) async {
                var byteData = (await value.toByteData(
                  format: ImageByteFormat.png,
                ))!;
                value.dispose();
                final list = byteData.buffer.asUint8List();
                // convert to base64 image
                final base64Image = base64.encode(list);
                final String baseImage = 'data:image/png;base64,$base64Image';
                launchUrlString(
                  baseImage,
                  mode: LaunchMode.externalApplication,
                );
              });
            },
      child: Clickable(
        enabled: componentsMode == ComponentsMode.normal,
        mouseCursor: const WidgetStatePropertyAll(SystemMouseCursors.click),
        onHover: (value) {
          setState(() {
            _hovering = value;
          });
        },
        onPressed: componentsMode == ComponentsMode.normal
            ? () {
                context.pushNamed(widget.name);
              }
            : null,
        child: WidgetStatesProvider.boundary(
          child: RepaintBoundary(
            key: repaintKey,
            child: ExcludeFocus(
              child: SizedBox(
                height: 200,
                width: 250,
                child: AnimatedValueBuilder(
                  value: _hovering ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  builder: (context, value, child) {
                    final borderColor = Color.lerp(
                      theme.colorScheme.border,
                      theme.colorScheme.ring,
                      value,
                    );
                    return OutlinedContainer(
                      clipBehavior: Clip.antiAlias,
                      borderColor: borderColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: IgnorePointer(
                              child: Container(
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.accent,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(
                                      theme.radiusMd + 3,
                                    ),
                                    topRight: Radius.circular(
                                      theme.radiusMd + 3,
                                    ),
                                  ),
                                ),
                                child: Transform.scale(
                                  scale: 1 + 0.3 * value,
                                  child: Transform.rotate(
                                    angle: pi / 180 * 10 * value,
                                    child: widget.fit
                                        ? Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: FittedBox(
                                              fit: BoxFit.contain,
                                              child: widget.example,
                                            ),
                                          )
                                        : widget.center
                                        ? Center(
                                            child: Transform.scale(
                                              scale: widget.scale,
                                              child: SingleChildScrollView(
                                                clipBehavior: Clip.none,
                                                child: widget.example,
                                              ),
                                            ),
                                          ).withPadding(all: 24)
                                        : Stack(
                                            children: [
                                              Positioned(
                                                top: !widget.reverseVertical
                                                    ? widget.verticalOffset
                                                    : null,
                                                right: widget.reverse
                                                    ? widget.horizontalOffset
                                                    : null,
                                                bottom: widget.reverseVertical
                                                    ? widget.verticalOffset
                                                    : null,
                                                left: !widget.reverse
                                                    ? widget.horizontalOffset
                                                    : null,
                                                child: Transform.scale(
                                                  scale: widget.scale,
                                                  alignment: widget.reverse
                                                      ? widget.reverseVertical
                                                            ? Alignment
                                                                  .bottomRight
                                                            : Alignment.topRight
                                                      : widget.reverseVertical
                                                      ? Alignment.bottomLeft
                                                      : Alignment.topLeft,
                                                  child: widget.example,
                                                ),
                                              ),
                                            ],
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const Divider(),
                          Text(
                            widget.title,
                          ).medium().withPadding(vertical: 12, horizontal: 16),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// paint a cursor
class CursorPainter extends CustomPainter {
  // <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24">
  // <path d="M4 0l16 12.279-6.951 1.17 4.325 8.817-3.596 1.734-4.35-8.879-5.428 4.702z"/></svg>
  const CursorPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final path = Path()
      ..moveTo(4, 0)
      ..lineTo(20, 12.279)
      ..lineTo(13.049, 13.449)
      ..lineTo(17.374, 22.266)
      ..lineTo(13.778, 24)
      ..lineTo(9.428, 15.121)
      ..lineTo(4, 19.823)
      ..close();
    canvas.drawPath(path, paint);
    paint
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
