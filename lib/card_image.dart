import 'package:flutter/gestures.dart';
import 'package:phonecodes/phonecodes.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:country_flags/country_flags.dart';
import 'package:test/expandable_sidebar_example_1.dart';

class MyCardImage extends StatelessWidget {
  const MyCardImage({super.key});

  final country = Country.algeria;

  // Open a drawer and optionally open another from within it.
  void open(BuildContext context) {
    final parent = context
        .findAncestorStateOfType<ExpandableSidebarExample1State>();
    if (parent == null) return;
    openDrawer(
      context: context,
      expands: true,
      showDragHandle: false,
      builder: (context) {
        return parent.drawer(true);
      },
      position: .end,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      headers: [
        AppBar(
          leading: [
            IconButton.ghost(
              icon: const Icon(LucideIcons.menu),
              onPressed: () {
                open(context);
              },
            ),
            IconButton.ghost(
              icon: const Icon(LucideIcons.expand),
              onPressed: () {
                final parent = context
                    .findAncestorStateOfType<ExpandableSidebarExample1State>();
                if (parent == null) return;
                parent.toggerExpanded();
              },
            ),
          ],
          title: Text('Test page'),
        ),
      ],
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse},
        ),
        child: Container(
          color: Colors.pink,
          child: ListView(
            padding: .all(20),
            children: [
              ButtonGroup(
                children: [
                  TextField(
                    readOnly: true,
                    features: [
                      InputFeature.leading(
                        AspectRatio(
                          aspectRatio: 1.5,
                          child:
                              CountryFlag.fromCountryCode(
                                country.code,
                                theme: ImageTheme(width: 10),
                              ).clipRRect(
                                borderRadius: .circular(
                                  Theme.of(context).radius * 3,
                                ),
                              ),
                        ),
                      ),
                    ],
                  ).sized(width: 57),
                  TextField(
                    placeholder: Text('Phone ${Theme.of(context).radius}'),
                  ).expanded(),
                  TextField(
                    readOnly: true,
                    textAlign: .center,
                    key: ValueKey(
                      '${Currency.dzd.code}/${Currency.dzd.symbol}',
                    ),
                    initialValue: '${Currency.dzd.code}/${Currency.dzd.symbol}',
                  ).sized(width: 90),
                ],
              ),
              const Gap(20),
              Basic(
                title: const Text('Skeleton Example 1'),
                content: const Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
                ),
                leading: Avatar(initials: Avatar.getInitials('Ayoub Attalli')),
                trailing: const Icon(Icons.arrow_forward),
              ),
              const Gap(24),
              Button(
                style: ButtonVariance.primary.copyWith(
                  decoration: (context, states, value) {
                    final theme = Theme.of(context);
                    return value.copyWithIfBoxDecoration(
                      color: theme.colorScheme.card,
                    );
                  },
                ),
                onPressed: () {},
                child:
                    Basic(
                          title: const Text('Skeleton Example 1'),
                          content: const Text(
                            'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
                          ),
                          leading: Avatar(
                            initials: Avatar.getInitials('Ayoub Attali'),
                          ),
                          // Note: Avatar and other Image related widget needs its own skeleton
                          trailing: const Icon(Icons.arrow_forward),
                        )
                        // Wrap the whole row in a skeleton to show a loading placeholder for text and icons.
                        .asSkeleton(),
              ),
            ],
            // itemCount: 10,
            // separatorBuilder: (context, index) => Gap(10),
            // itemBuilder: (context, i) {
            //   return CardImage(
            //     direction: .horizontal,
            //     // Simple interaction: open a dialog on tap.
            //     onPressed: () {
            //       showDialog(
            //         context: context,
            //         builder: (context) {
            //           return AlertDialog(
            //             title: const Text('Card Image'),
            //             content: const Text('You clicked on a card image.'),
            //             actions: [
            //               PrimaryButton(
            //                 onPressed: () {
            //                   Navigator.of(context).pop();
            //                 },
            //                 child: const Text('Close'),
            //               ),
            //             ],
            //           );
            //         },
            //       );
            //     },
            //     // Network image; replace with your own provider as needed.
            //     image: Image.network(
            //       'https://picsum.photos/300/300?random=$i',
            //       width: 65,
            //     ),
            //     // leading: const Icon(Icons.abc),
            //     // leading: Text('Card Number ${i + 1}'),
            //     // trailing: Text('+214'),
            //     // content: Image.network('https://picsum.photos/300/300?random=$i', width: 65),
            //     // Title and subtitle appear over the image.
            //     title: Text('Card Number ${i + 1}'),
            //     subtitle: const Text('Lorem ipsum dolor sit amet'),

            //     // padding: EdgeInsets.zero,
            //     // leading: CountryPickerUtils.getDefaultFlagImage(country),
            //     // title: Text(countryName),
            //     // // subtitle: Text(country.),
            //     // trailing: Text('+${country.phoneCode}'),
            //   ).sized(height: 65);
            // },
          ),
        ),
      ),
    );
  }
}
