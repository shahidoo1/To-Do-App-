// import 'package:flutter_application_2/modals/Todo.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:timezone/timezone.dart' as tz;

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// Future<void> requestNotificationPermission() async {
//   final status = await Permission.notification.status;

//   if (status.isDenied) {
//     final result = await Permission.notification.request();
//     if (result.isDenied) {
//       openAppSettings();
//     }
//   } else if (status.isPermanentlyDenied) {
//     openAppSettings();
//   }
// }

// Future<void> initializeNotifications() async {
//   const AndroidInitializationSettings initializationSettingsAndroid =
//       AndroidInitializationSettings('@mipmap/ic_launcher');

//   final InitializationSettings initializationSettings =
//       InitializationSettings(android: initializationSettingsAndroid);

//   await flutterLocalNotificationsPlugin.initialize(initializationSettings);
// }

// Future<void> scheduleTaskNotification(Task task) async {
//   try {
//     print('Scheduling notification for task: ${task.title}');

//     if (task.dueDate == null || task.id == null) {
//       throw Exception('Task must have a valid dueDate and id.');
//     }

//     final now = tz.TZDateTime.now(tz.local);
//     final scheduledDate = tz.TZDateTime.from(task.dueDate, tz.local);

//     if (scheduledDate.isBefore(now)) {
//       throw Exception('Scheduled date must be in the future.');
//     }

//     // Generate a unique ID for each notification
//    // int notificationId = DateTime.now().millisecondsSinceEpoch;
//      int notificationId =  DateTime.now().millisecondsSinceEpoch % 2147483647; // 2^31 - 1

//     await flutterLocalNotificationsPlugin.zonedSchedule(
//       notificationId, // Unique ID
//       task.title,
//       'Due: ${task.dueDate}',
//       scheduledDate,
//       const NotificationDetails(
//         android: AndroidNotificationDetails(
//           'task_channel',
//           'Task Notifications',
//           channelDescription: 'Channel for task notifications',
//           importance: Importance.max,
//           priority: Priority.high,
//         ),
//       ),
//       androidAllowWhileIdle: true,
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime,
//     );

//     print('Notification scheduled for task: ${task.title} at $scheduledDate');
//   } catch (e, stackTrace) {
//     print('Error scheduling notification: $e');
//     print('Stack trace: $stackTrace');
//   }
// }

// Future<void> checkExactAlarmPermission() async {
//   var status = await Permission.scheduleExactAlarm.status;

//   if (status.isDenied) {
//     await Permission.scheduleExactAlarm.request();
//     if (await Permission.scheduleExactAlarm.isGranted) {
//       print("Exact Alarm permission granted");
//     } else {
//       print("Exact Alarm permission denied");
//       openAppSettings();
//     }
//   } else if (status.isGranted) {
//     print("Exact Alarm permission already granted");
//   }
// }

// Future<void> cancelTaskNotification(int taskId) async {
//   try {
//     await flutterLocalNotificationsPlugin.cancel(taskId);
//     print('Notification canceled for task ID: $taskId');
//   } catch (e) {
//     print('Error canceling notification: $e');
//     throw Exception('Error canceling notification: $e');
//   }
// }

import 'package:flutter_application_2/modals/Todo.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'dart:io';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> requestNotificationPermission() async {
  if (Platform.isAndroid) {
    final status = await Permission.notification.status;

    if (status.isDenied) {
      final result = await Permission.notification.request();
      if (result.isDenied) {
        openAppSettings();
      }
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  } else if (Platform.isIOS) {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }
}

Future<void> initializeNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
    onDidReceiveLocalNotification:
        (int id, String? title, String? body, String? payload) async {
      // Handle notification when the app is in the foreground
    },
  );

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      // Handle notification tap
    },
  );
}

Future<void> scheduleTaskNotification(Task task) async {
  try {
    print('Scheduling notification for task: ${task.title}');

    if (task.dueDate == null || task.id == null) {
      throw Exception('Task must have a valid dueDate and id.');
    }

    final now = tz.TZDateTime.now(tz.local);
    final scheduledDate = tz.TZDateTime.from(task.dueDate, tz.local);

    if (scheduledDate.isBefore(now)) {
      throw Exception('Scheduled date must be in the future.');
    }

    int notificationId =
        DateTime.now().millisecondsSinceEpoch % 2147483647; // 2^31 - 1

    await flutterLocalNotificationsPlugin.zonedSchedule(
      notificationId,
      task.title,
      'Due: ${task.dueDate}',
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'task_channel',
          'Task Notifications',
          channelDescription: 'Channel for task notifications',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(
          sound: 'default',
          presentAlert: true,
          presentBadge: true,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );

    print('Notification scheduled for task: ${task.title} at $scheduledDate');
  } catch (e, stackTrace) {
    print('Error scheduling notification: $e');
    print('Stack trace: $stackTrace');
  }
}

Future<void> checkExactAlarmPermission() async {
  if (Platform.isAndroid) {
    var status = await Permission.scheduleExactAlarm.status;

    if (status.isDenied) {
      await Permission.scheduleExactAlarm.request();
      if (await Permission.scheduleExactAlarm.isGranted) {
        print("Exact Alarm permission granted");
      } else {
        print("Exact Alarm permission denied");
        openAppSettings();
      }
    } else if (status.isGranted) {
      print("Exact Alarm permission already granted");
    }
  } else {
    print("Exact Alarm permission is not applicable on this platform.");
  }
}

Future<void> cancelTaskNotification(int taskId) async {
  try {
    await flutterLocalNotificationsPlugin.cancel(taskId);
    print('Notification canceled for task ID: $taskId');
  } catch (e) {
    print('Error canceling notification: $e');
    throw Exception('Error canceling notification: $e');
  }
}
