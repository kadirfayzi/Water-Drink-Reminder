import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:water_reminder/constants.dart';
import 'package:water_reminder/provider/data_provider.dart';
import 'package:water_reminder/widgets/build_appbar.dart';

class ReminderSound extends StatefulWidget {
  const ReminderSound({Key? key}) : super(key: key);

  @override
  _ReminderSoundState createState() => _ReminderSoundState();
}

class _ReminderSoundState extends State<ReminderSound> with TickerProviderStateMixin {
  final _player = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Consumer<DataProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          appBar: const BuildAppBar(title: Text('Reminder sound')),
          body: Scrollbar(
              child: SingleChildScrollView(
            child: SizedBox(
              height: size.height,
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: ListView(
                  children: List.generate(
                    kSounds.length,
                    (index) => Container(
                      height: size.height * 0.1,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey.shade300,
                            width: 0.5,
                          ),
                        ),
                      ),
                      child: InkWell(
                        onTap: () async {
                          await _player.setAsset('assets/sounds/$index.mp3');
                          _player.play();
                          provider.setSoundValue = index;
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                kSounds[index],
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              Icon(
                                provider.getSoundValue == index ? Icons.check_circle_rounded : null,
                                color: kPrimaryColor,
                                size: 30,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )),
        );
      },
    );
  }
}

/// before settings with hive
// import 'package:flutter/material.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:provider/provider.dart';
// import 'package:water_reminder/constants.dart';
// import 'package:water_reminder/models/settings.dart';
// import 'package:water_reminder/provider/data_provider.dart';
// import 'package:water_reminder/widgets/build_appbar.dart';
//
// class ReminderSound extends StatefulWidget {
//   const ReminderSound({Key? key}) : super(key: key);
//
//   @override
//   _ReminderSoundState createState() => _ReminderSoundState();
// }
//
// class _ReminderSoundState extends State<ReminderSound> with TickerProviderStateMixin {
//   final _player = AudioPlayer();
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     return Consumer<DataProvider>(
//       builder: (context, provider, _) {
//         return Scaffold(
//           appBar: const BuildAppBar(title: Text('Reminder sound')),
//           body: Scrollbar(
//               child: SingleChildScrollView(
//             child: SizedBox(
//               height: size.height,
//               child: Padding(
//                 padding: const EdgeInsets.only(top: 10),
//                 child: ListView(
//                   children: List.generate(
//                     kSounds.length,
//                     (index) => Container(
//                       height: size.height * 0.1,
//                       decoration: BoxDecoration(
//                         border: Border(
//                           bottom: BorderSide(
//                             color: Colors.grey.shade300,
//                             width: 0.5,
//                           ),
//                         ),
//                       ),
//                       child: InkWell(
//                         onTap: () async {
//                           await _player.setAsset('assets/sounds/$index.mp3');
//                           _player.play();
//                           provider.setSoundValue = index;
//                         },
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 15),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 kSounds[index],
//                                 style: const TextStyle(
//                                   fontSize: 16,
//                                   color: Colors.black,
//                                 ),
//                               ),
//                               Icon(
//                                 provider.getSoundValue == index ? Icons.check_circle_rounded : null,
//                                 color: kPrimaryColor,
//                                 size: 30,
//                               )
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           )),
//         );
//       },
//     );
//   }
// }
