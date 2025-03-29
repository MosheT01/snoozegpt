import 'package:equatable/equatable.dart';
import '../../core/models/alarm_model.dart';

class AlarmState extends Equatable {
  final List<AlarmModel> alarms;

  const AlarmState({required this.alarms});

  AlarmState copyWith({List<AlarmModel>? alarms}) {
    return AlarmState(alarms: alarms ?? this.alarms);
  }

  @override
  List<Object> get props => [alarms];
}
