import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'alarm_event.dart';
import 'alarm_state.dart';

class AlarmBloc extends Bloc<AlarmEvent, AlarmState> {
  AlarmBloc() : super(const AlarmState(alarms: [])) {
    on<LoadAlarms>(_onLoadAlarms);
    on<AddAlarm>(_onAddAlarm);
  }

  Future<void> _onLoadAlarms(LoadAlarms event, Emitter<AlarmState> emit) async {
    final box = Hive.box('alarms');
    final storedList = box.get('alarmList', defaultValue: <String>[]);
    final alarms =
        List<String>.from(storedList).map((e) => DateTime.parse(e)).toList();

    emit(state.copyWith(alarms: alarms));
  }

  Future<void> _onAddAlarm(AddAlarm event, Emitter<AlarmState> emit) async {
    final updatedAlarms = List<DateTime>.from(state.alarms)..add(event.time);

    final box = Hive.box('alarms');
    final stringList = updatedAlarms.map((e) => e.toIso8601String()).toList();
    await box.put('alarmList', stringList);

    emit(state.copyWith(alarms: updatedAlarms));
  }
}
