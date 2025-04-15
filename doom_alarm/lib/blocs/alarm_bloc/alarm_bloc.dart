import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import '../../core/models/alarm_model.dart';
import 'alarm_event.dart';
import 'alarm_state.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import '../../core/utils/alarm_callback.dart';

class AlarmBloc extends Bloc<AlarmEvent, AlarmState> {
  AlarmBloc() : super(const AlarmState(alarms: [])) {
    on<LoadAlarms>(_onLoadAlarms);
    on<AddAlarm>(_onAddAlarm);
    on<DeleteAlarm>(_onDeleteAlarm);
  }

  Future<void> _onDeleteAlarm(
    DeleteAlarm event,
    Emitter<AlarmState> emit,
  ) async {
    final box = Hive.box<AlarmModel>('alarms');
    final alarm = box.getAt(event.index);
    if (alarm != null) {
      await alarm.delete(); // removes from Hive
      final updated = box.values.toList();
      emit(state.copyWith(alarms: updated));
    }
  }

  Future<void> _onLoadAlarms(LoadAlarms event, Emitter<AlarmState> emit) async {
    final box = Hive.box<AlarmModel>('alarms');
    final alarms = box.values.toList();
    emit(state.copyWith(alarms: alarms));
  }

  Future<void> _onAddAlarm(AddAlarm event, Emitter<AlarmState> emit) async {
    final box = Hive.box<AlarmModel>('alarms');
    await box.add(event.alarm);

    final updated = box.values.toList();
    emit(state.copyWith(alarms: updated));

    final now = DateTime.now();
    final alarmTime = DateTime(
      now.year,
      now.month,
      now.day,
      event.alarm.hour,
      event.alarm.minute,
    );

    if (alarmTime.isBefore(now)) {
      // If the time is already passed today, set for tomorrow
      alarmTime.add(const Duration(days: 1));
    }

    // Schedule the alarm
    await AndroidAlarmManager.oneShotAt(
      alarmTime,
      alarmTime.hashCode, // unique ID
      alarmCallback,
      exact: true,
      wakeup: true,
      rescheduleOnReboot: true,
    );
  }
}
