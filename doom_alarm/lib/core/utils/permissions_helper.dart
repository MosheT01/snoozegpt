import 'package:permission_handler/permission_handler.dart';

class PermissionsHelper {
  /// Checks whether **all required permissions** are granted.
  static Future<bool> hasAllPermissions() async {
    final notification = await Permission.notification.isGranted;
    final exactAlarm = await Permission.scheduleExactAlarm.isGranted;
    final batteryOptimizationStatus =
        await Permission.ignoreBatteryOptimizations.status;
    final batteryOptimization = batteryOptimizationStatus.isGranted;

    return notification && exactAlarm && batteryOptimization;
  }

  /// Optionally, separate checks for each permission
  static Future<bool> hasNotificationPermission() =>
      Permission.notification.isGranted;

  static Future<bool> hasExactAlarmPermission() =>
      Permission.scheduleExactAlarm.isGranted;

  static Future<bool> hasBatteryOptimizationPermission() async {
    final status = await Permission.ignoreBatteryOptimizations.status;
    return status.isGranted;
  }
}
