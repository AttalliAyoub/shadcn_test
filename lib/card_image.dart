import 'package:flutter/gestures.dart';
import 'package:phonecodes/phonecodes.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:country_flags/country_flags.dart';

class MyCardImage extends StatelessWidget {
  const MyCardImage({super.key});

  final country = Country.algeria;

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse},
      ),
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
                key: ValueKey('${Currency.dzd.code}/${Currency.dzd.symbol}'),
                initialValue: '${Currency.dzd.code}/${Currency.dzd.symbol}',
              ).sized(width: 90),
            ],
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
    );
  }
}
