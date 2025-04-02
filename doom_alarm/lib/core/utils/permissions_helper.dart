import 'package:permission_handler/permission_handler.dart';

class PermissionsHelper {
  static Future<bool> hasAllPermissions() async {
    final notif = await Permission.notification.isGranted;
    final exactAlarm = await Permission.scheduleExactAlarm.isGranted;

    // You can add battery optimization checks here too if needed
    return notif && exactAlarm;
  }
}
