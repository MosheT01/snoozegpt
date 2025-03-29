import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import '../../core/models/alarm_model.dart';
import 'alarm_event.dart';
import 'alarm_state.dart';

class AlarmBloc extends Bloc<AlarmEvent, AlarmState> {
  AlarmBloc() : super(const AlarmState(alarms: [])) {
    on<LoadAlarms>(_onLoadAlarms);
    on<AddAlarm>(_onAddAlarm);
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
  }
}
