import 'package:equatable/equatable.dart';

class AlarmState extends Equatable {
  final List<DateTime> alarms;

  const AlarmState({required this.alarms});

  AlarmState copyWith({List<DateTime>? alarms}) {
    return AlarmState(alarms: alarms ?? this.alarms);
  }

  @override
  List<Object> get props => [alarms];
}
