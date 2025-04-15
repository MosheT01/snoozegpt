import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:path_provider/path_provider.dart' as pp;
import '../models/alarm_model.dart';
import '../utils/alarm_scheduler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
Future<void> bootReschedule() async {
  debugPrint('[BootRescheduler] 🚀 Triggered at boot!', wrapWidth: 1024);
  String? path;

  try {
    final prefs = await SharedPreferences.getInstance();
    path = prefs.getString('hive_dir');
    debugPrint(
      '[BootRescheduler] 📂 Got path from SharedPreferences: $path',
      wrapWidth: 1024,
    );
  } catch (e) {
    debugPrint(
      '[BootRescheduler] ⚠️ SharedPreferences error: $e',
      wrapWidth: 1024,
    );
  }

  if (path == null) {
    try {
      final dir = await pp.getApplicationDocumentsDirectory();
      path = dir.path;
      debugPrint('[BootRescheduler] 📂 Fallback path: $path', wrapWidth: 1024);
    } catch (e) {
      debugPrint(
        '[BootRescheduler] ❌ ERROR getting fallback path: $e',
        wrapWidth: 1024,
      );
      return;
    }
  }

  try {
    Hive.init(path!);
    Hive.registerAdapter(AlarmModelAdapter());

    final box = await Hive.openBox<AlarmModel>('alarms');
    debugPrint(
      '[BootRescheduler] 🔍 Alarms found: ${box.length}',
      wrapWidth: 1024,
    );

    if (box.isEmpty) {
      debugPrint(
        '[BootRescheduler] ⚠️ No alarms to reschedule. Exiting.',
        wrapWidth: 1024,
      );
    }

    await AndroidAlarmManager.initialize();
    for (var alarm in box.values) {
      debugPrint(
        '[BootRescheduler] 🗓 Scheduling: ${alarm.label}',
        wrapWidth: 1024,
      );
      await AlarmScheduler.schedule(alarm);
    }

    debugPrint('[BootRescheduler] ✅ All alarms rescheduled', wrapWidth: 1024);
    await _sendBootNotification();
  } catch (e) {
    debugPrint(
      '[BootRescheduler] ❌ ERROR during alarm reschedule: $e',
      wrapWidth: 1024,
    );
  }
}

Future<void> _sendBootNotification() async {
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  const android = AndroidInitializationSettings('@mipmap/ic_launcher');
  const initSettings = InitializationSettings(android: android);
  await flutterLocalNotificationsPlugin.initialize(initSettings);

  const androidDetails = AndroidNotificationDetails(
    'reschedule_notif',
    'Boot Reschedule',
    importance: Importance.high,
    priority: Priority.high,
    playSound: false,
  );
  const notifDetails = NotificationDetails(android: androidDetails);
  debugPrint(
    '[BootRescheduler] 🛎 Attempting to show notification...',
    wrapWidth: 1024,
  );
  await Future.delayed(Duration(seconds: 2));

  await flutterLocalNotificationsPlugin.show(
    1001,
    'Doom Alarm',
    '✅ Alarms rescheduled after reboot',
    notifDetails,
  );
}
