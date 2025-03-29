import 'package:equatable/equatable.dart';

abstract class AlarmEvent extends Equatable {
  const AlarmEvent();

  @override
  List<Object> get props => [];
}

// Event: Load alarms from memory
class LoadAlarms extends AlarmEvent {}

// Event: Add a new alarm (time only for now)
class AddAlarm extends AlarmEvent {
  final DateTime time;

  const AddAlarm(this.time);

  @override
  List<Object> get props => [time];
}
