import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:water_reminder/screens/settings/settings_subscreens/reminder_schedule.dart';

class NotificationService extends ChangeNotifier {
  // final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // void showNotificationWeekly(
  //     int id, String title, String body, ReminderSchedule reminder) async {
  //   // Initialize Timezone
  //   tz.initializeTimeZones();
  //   final String currentTimeZone =
  //       await FlutterNativeTimezone.getLocalTimezone();
  //   debugPrint("timezone = $currentTimeZone");
  //   tz.setLocalLocation(tz.getLocation(currentTimeZone));
  //   // Initialize Timezone done
  //   int _notificationId = 0;
  //   List<int> _notificationIdList =
  //       []; // I want to set the IDs in the shared Pref, Thats what this list is for
  //   /// [weekValues] is an array of 7 bools,  0 to 6 representing each day of week
  //   /// is this loop, I set all the notification for the days of week that user has selected
  //   /// in our example we have selected all the days of week, so [weekValues] is array of 7 true booleans.
  //
  //   /// /// ///
  //   const android = AndroidNotificationDetails(
  //     "id",
  //     "channel",
  //     channelDescription: "description",
  //     importance: Importance.max,
  //   );
  //   const ios = IOSNotificationDetails();
  //
  //   const platform = NotificationDetails(android: android, iOS: ios);
  //
  //   /// /// ///
  //   for (var i = 0; i < reminder.weekValues.length; i++) {
  //     tz.TZDateTime _weekDateTime =
  //         _getNextDateTime(i + 1, reminder.timeValues);
  //     tz.TZDateTime _timeEnd = tz.TZDateTime(
  //       tz.local,
  //       _weekDateTime.year,
  //       _weekDateTime.month,
  //       _weekDateTime.day,
  //       reminder.timeValues[1][0],
  //       reminder.timeValues[1][1],
  //     );
  //
  //     /// since [weekValues] is all true, the else of this if statement is useless here
  //     if (reminder.weekValues[i]) {
  //       /// [timeValues[2][0]] is my repeating hour, this part is complicated but in this example
  //       /// [timeValues[2][0]] is 2 so the if is true
  //       if (reminder.timeValues[2][0] > 0) {
  //         while (_weekDateTime.isBefore(_timeEnd)) {
  //           /// The output of this print is important and will be provided after this code
  //           debugPrint(
  //               'if Notification with Id= $_notificationId Succesfully Scheduled at $_weekDateTime');
  //           await _flutterLocalNotificationsPlugin.zonedSchedule(
  //               _notificationId,
  //               title,
  //               body,
  //               // _temp,
  //               _weekDateTime.add(const Duration(seconds: 1)),
  //               platform,
  //               androidAllowWhileIdle: true,
  //               uiLocalNotificationDateInterpretation:
  //                   UILocalNotificationDateInterpretation.absoluteTime,
  //               matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime);
  //
  //           /// some incrementall stuff
  //           _notificationIdList.add(_notificationId);
  //           _notificationId++;
  //
  //           /// Adding to the times base of the repeating time
  //           /// in this example and if the first loop we add 2 hours to 8:30, so the result is 10:30
  //           _weekDateTime = _weekDateTime.add(
  //             Duration(
  //               hours: reminder.timeValues[2][0],
  //             ),
  //           );
  //         }
  //       } else {
  //         // This else can be ignored since we selected all the week days
  //         tz.TZDateTime _temp = tz.TZDateTime(
  //           tz.local,
  //           _weekDateTime.year,
  //           _weekDateTime.month,
  //           _weekDateTime.day,
  //           _weekDateTime.hour,
  //           _weekDateTime.minute,
  //           _weekDateTime.second,
  //           _weekDateTime.millisecond,
  //           _weekDateTime.microsecond,
  //         );
  //         debugPrint(
  //             'else Notification with Id= $_notificationId Scheduled at $_temp');
  //         _notificationIdList.add(_notificationId);
  //         await _flutterLocalNotificationsPlugin.zonedSchedule(
  //             _notificationId, title, body, _temp, platform,
  //             androidAllowWhileIdle: true,
  //             uiLocalNotificationDateInterpretation:
  //                 UILocalNotificationDateInterpretation.absoluteTime,
  //             matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime);
  //       }
  //       _notificationId++;
  //     }
  //   }
  //   await setNotificationIds(_notificationIdList);
  // }

  /// /// /// ///
  final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /// Initialize notification
  Future initialize() async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const androidInitializationSettings =
        AndroidInitializationSettings("ic_launcher");

    const iosInitializationSettings = IOSInitializationSettings();

    const initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    tz.initializeTimeZones();

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  /// Scheduled Notification
  Future scheduledNotification() async {
    const interval = RepeatInterval.everyMinute;

    const android = AndroidNotificationDetails(
      "id",
      "channel",
      channelDescription: "description",
      importance: Importance.max,
    );
    const ios = IOSNotificationDetails();

    const platform = NotificationDetails(android: android, iOS: ios);

    await _flutterLocalNotificationsPlugin.periodicallyShow(
      0,
      "Your body needs water !",
      "Tap to allow drunk amount",
      interval,
      platform,
    );

    /// ////

    final time = DateTime.now();
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      "Notification Title",
      "This is the Notification Body!",
      tz.TZDateTime.utc(time.year, time.month, time.day, 2, 0),
      platform,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  /// Cancel notification

  Future cancelNotification() async =>
      await _flutterLocalNotificationsPlugin.cancelAll();
}
