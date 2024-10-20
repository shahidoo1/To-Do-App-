import 'package:flutter_application_2/modals/Todo.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> requestNotificationPermission() async {
  final status = await Permission.notification.status;

  if (status.isDenied) {
    final result = await Permission.notification.request();
    if (result.isDenied) {
      openAppSettings();
    }
  } else if (status.isPermanentlyDenied) {
    openAppSettings();
  }
}

Future<void> initializeNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
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

    // Generate a unique ID for each notification
   // int notificationId = DateTime.now().millisecondsSinceEpoch;
     int notificationId =  DateTime.now().millisecondsSinceEpoch % 2147483647; // 2^31 - 1


    await flutterLocalNotificationsPlugin.zonedSchedule(
      notificationId, // Unique ID
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
