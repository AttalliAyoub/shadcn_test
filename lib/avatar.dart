import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import '/utils/animated_boarder.dart';

class MyAvatar extends StatelessWidget {
  final String initials;
  final String? url;
  final XFile? file;
  final VoidCallback? onPressed;
  final AvatarWidget? badge;
  final double? size;
  final bool loading;
  final ProgressBorder? progressStyle;
  final TextDirection? textDirection;
  final Duration duration;

  const MyAvatar({
    super.key,
    this.onPressed,
    this.url,
    this.file,
    this.badge,
    this.size,
    this.textDirection,
    this.duration = const Duration(seconds: 1),
    this.loading = false,
    this.progressStyle,
    required this.initials,
  });

  Widget _basic(
    BuildContext context, {
    ImageProvider<Object>? provider,
    double? progress,
  }) {
    final borderShape =
        progressStyle ??
        ProgressBorder.fromContext(context, textDirection: textDirection);
    return Button(
      style: ButtonStyle.fixed(shape: .circle, density: .compact),
      onPressed: onPressed,
      child: Avatar(
        initials: initials,
        provider: provider,
        badge: badge,
        size: size,
      ),
    ).asSkeleton(enabled: loading).animatedBorder(
			context,
      duration: duration,
      textDirection: textDirection,
      shape: borderShape.copyWith(
        borderRadius: .circular(size ?? 100),
        progress: progress,
        textDirection: textDirection,
        dashLength: loading ? .2 : null,
      ),
			builder: (context, shape, child) {
				return child.withPadding(all: shape.side.width);
			}
		);
  }

  @override
  Widget build(BuildContext context) {
    //   return _build(context);
    // }
    // Widget _build(BuildContext context) {
    if (file != null) {
      return _basic(context, provider: FileImage(File(file!.path)));
    }
    if (url == null) return _basic(context);
    return CachedNetworkImage(
      imageUrl: url!,
      imageBuilder: (context, provider) {
        print(provider);
        return _basic(context, provider: provider);
      },
      progressIndicatorBuilder: (context, url, progress) {
        return _basic(context, progress: progress.progress).asSkeleton();
      },
      errorWidget: (context, url, error) {
        return _basic(context);
      },
    );
  }
}
