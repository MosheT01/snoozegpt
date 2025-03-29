import 'package:equatable/equatable.dart';
import '../../core/models/alarm_model.dart';

abstract class AlarmEvent extends Equatable {
  const AlarmEvent();

  @override
  List<Object> get props => [];
}

class LoadAlarms extends AlarmEvent {}

class AddAlarm extends AlarmEvent {
  final AlarmModel alarm;

  const AddAlarm(this.alarm);

  @override
  List<Object> get props => [alarm];
}
