import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:doom_alarm/blocs/alarm_bloc/alarm_bloc.dart';
import 'package:doom_alarm/blocs/alarm_bloc/alarm_event.dart';
import 'package:doom_alarm/core/models/alarm_model.dart';
import 'package:doom_alarm/features/alarm/ui/alarm_list_screen.dart';
import 'package:doom_alarm/features/onboarding/onboarding_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'core/utils/permissions_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(AlarmModelAdapter());
  await Hive.openBox<AlarmModel>('alarms');
  await AndroidAlarmManager.initialize();

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
            showOnboarding ? const OnboardingScreen() : const AlarmListScreen(),
      ),
    );
  }
}
