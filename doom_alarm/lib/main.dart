import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:doom_alarm/blocs/alarm_bloc/alarm_bloc.dart';
import 'package:doom_alarm/blocs/alarm_bloc/alarm_event.dart';
import 'package:doom_alarm/core/models/alarm_model.dart';
import 'package:doom_alarm/features/alarm/ui/alarm_list_screen.dart';
import 'package:doom_alarm/features/onboarding/onboarding_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:doom_alarm/core/utils/permissions_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

// ✅ Needed to prevent tree shaking
import 'package:doom_alarm/core/boot/boot_rescheduler.dart';

Future<void> initializeNotifications() async {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dir = await getApplicationDocumentsDirectory();
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('hive_dir', dir.path);

  await Hive.initFlutter();
  Hive.registerAdapter(AlarmModelAdapter());
  await Hive.openBox<AlarmModel>('alarms');

  await AndroidAlarmManager.initialize();
  await initializeNotifications();

  // ✅ Schedule bootReschedule once with persistence
  await AndroidAlarmManager.oneShot(
    const Duration(seconds: 5),
    0,
    bootReschedule,
    wakeup: true,
    rescheduleOnReboot: true,
  );

  final hasPermissions = await PermissionsHelper.hasAllPermissions();

  runApp(DoomAlarmApp(showOnboarding: !hasPermissions));
}

class DoomAlarmApp extends StatelessWidget {
  final bool showOnboarding;

  const DoomAlarmApp({super.key, required this.showOnboarding});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AlarmBloc>(create: (_) => AlarmBloc()..add(LoadAlarms())),
      ],
      child: MaterialApp(
        title: 'Doom Alarm',
        theme: ThemeData(primarySwatch: Colors.deepPurple),
        home:
            showOnboarding
                ? const OnboardingPermissionScreen()
                : const AlarmListScreen(),
      ),
    );
  }
}
