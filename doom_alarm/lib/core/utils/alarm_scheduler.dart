import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:doom_alarm/core/utils/alarm_callback.dart';
import '../models/alarm_model.dart';

class AlarmScheduler {
  static Future<void> schedule(AlarmModel alarm) async {
    print('[AlarmScheduler] Scheduling alarm: ${alarm.label}');
    final now = DateTime.now();
    var time = DateTime(now.year, now.month, now.day, alarm.hour, alarm.minute);

    if (time.isBefore(now)) {
      time = time.add(const Duration(days: 1));
    }

    await AndroidAlarmManager.oneShotAt(
      time,
      time.hashCode,
      alarmCallback,
      exact: true,
      wakeup: true,
      rescheduleOnReboot: true,
    );
  }
}
