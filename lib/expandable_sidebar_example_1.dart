import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:test/card_image.dart';

class ExpandableSidebarExample1 extends StatefulWidget {
  const ExpandableSidebarExample1({super.key});

  @override
  State<ExpandableSidebarExample1> createState() =>
      ExpandableSidebarExample1State();
}

class ExpandableSidebarExample1State extends State<ExpandableSidebarExample1> {
  // When true, the rail expands to show labels; when false, it collapses to
  // an icon-only sidebar.
  bool expanded = false;

  String selected = 'Home';

  void toggerExpanded() {
    setState(() {
      expanded = !expanded;
    });
  }

  NavigationItem buildButton(String text, IconData icon) {
    // Convenience factory for a selectable navigation item with left alignment
    // and a primary icon style when selected.
    return NavigationItem(
      label: Text(text),
      // alignment: Alignment.centerLeft,
      selectedStyle: const ButtonStyle.primaryIcon(),
      selected: selected == text,
      onChanged: (selected) {
        if (selected) {
          setState(() {
            this.selected = text;
          });
        }
      },
      child: Icon(icon),
    );
  }

  NavigationGroup buildLabel(String label, List<Widget> children) {
    // Section header used to group related navigation items.
    return NavigationGroup(
      labelAlignment: Alignment.centerLeft,
      label: Text(label).semiBold.muted.xSmall,
      children: children,
    );
  }


  Widget drawer([bool overrideExpaneded = true]) {
    final theme = Theme.of(context);
    return NavigationRail(
      backgroundColor: theme.colorScheme.accent.withValues(alpha: 0.4),
      // Expand/collapse behavior is handled by the `expanded` boolean.
      // With labelType.expanded, labels are hidden when collapsed.
      labelType: NavigationLabelType.expanded,
      labelPosition: NavigationLabelPosition.end,
      alignment: NavigationRailAlignment.start,
      expandedSize: 250,
      expanded: overrideExpaneded || expanded,
      header: [
        Builder(
          builder: (context) {
            return SafeArea(
              child: NavigationSlot(
                leading: IconContainer(
                  backgroundColor: Colors.blue,
                  icon: const Icon(LucideIcons.galleryVerticalEnd).iconMedium,
                ),
                title: Text(''),
                trailing: Text(
                  'نداء',
                  style: theme.typography.medium.copyWith(
                    // color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ).medium.small,
                onPressed: toggerExpanded,
              ),
            );
          },
        ),
      ],
      footer: [
        SafeArea(
          child: Builder(
            builder: (context) {
              return NavigationSlot(
                leading: Avatar(
                  size: 32,
                  initials: 'SU',
                  backgroundColor: Colors.green.shade800,
                ),
                title: const Text('sunarya-thito').medium.small,
                subtitle: const Text('m@gmail.com').xSmall.normal,
                trailing: const Icon(LucideIcons.chevronsUpDown).iconSmall,
                onPressed: () {
                  showDropdown(
                    context: context,
                    anchorAlignment: AlignmentDirectional.centerEnd,
                    alignment: AlignmentDirectional.centerStart,
                    offset: const Offset(16, 0),
                    builder: (context) {
                      return DropdownMenu(
                        children: [
                          MenuButton(
                            leading: const Icon(Icons.person),
                            child: const Text('Profile'),
                            onPressed: (ctx) {},
                          ),
                          MenuButton(
                            leading: const Icon(Icons.settings),
                            child: const Text('Settings'),
                            onPressed: (ctx) {},
                          ),
                          const MenuDivider(),
                          MenuButton(
                            leading: const Icon(Icons.logout),
                            child: const Text('Logout'),
                            onPressed: (ctx) {},
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            }
          ),
        ),
      ],
      children: [
        buildLabel('You', [
          buildButton('Home', Icons.home_filled),
          buildButton('Trending', Icons.trending_up),
          buildButton('Subscription', Icons.subscriptions),
        ]),
        const NavigationDivider(),
        NavigationCollapsible(
          leading: const Icon(Icons.history),
          label: const Text('History'),
          children: [
            buildButton('History', Icons.history),
            buildButton('Watch Later', Icons.access_time_rounded),
          ],
        ),
        const NavigationDivider(),
        buildLabel('Movie', [
          buildButton('Action', Icons.movie_creation_outlined),
          buildButton('Horror', Icons.movie_creation_outlined),
          buildButton('Thriller', Icons.movie_creation_outlined),
        ]),
        const NavigationDivider(),
        NavigationCollapsible(
          leading: const Icon(Icons.movie_filter_outlined),
          label: const Text('Short Films'),
          children: [
            buildButton('Action', Icons.movie_creation_outlined),
            buildButton('Horror', Icons.movie_creation_outlined),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          drawer(false),
          const VerticalDivider(),
          // Placeholder for the main content area.
          Flexible(
            child: MyCardImage(),
          ),
        ],
      ),
    );
  }
}
