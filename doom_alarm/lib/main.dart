import 'package:doom_alarm/blocs/alarm_bloc/alarm_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/alarm/ui/alarm_list_screen.dart';
import 'blocs/alarm_bloc/alarm_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/models/alarm_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(AlarmModelAdapter());
  final box = await Hive.openBox<AlarmModel>('alarms');

  //await box.clear(); // ⚠️ Clears incompatible old data once

  runApp(const DoomAlarmApp());
}

class DoomAlarmApp extends StatelessWidget {
  const DoomAlarmApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AlarmBloc>(create: (_) => AlarmBloc()..add(LoadAlarms())),
      ],
      child: MaterialApp(
        title: 'Doom Alarm',
        theme: ThemeData(primarySwatch: Colors.deepPurple),
        home: const AlarmListScreen(),
      ),
    );
  }
}
