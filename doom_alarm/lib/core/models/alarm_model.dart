import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';

part 'alarm_model.g.dart';

@HiveType(typeId: 0)
class AlarmModel extends HiveObject with EquatableMixin {
  @HiveField(0)
  final int hour;

  @HiveField(1)
  final int minute;

  @HiveField(2)
  final List<String> repeatDays;

  @HiveField(3)
  final String label;

  @HiveField(4)
  final String alarmType;

  @HiveField(5)
  final String sound;

  AlarmModel({
    required this.hour,
    required this.minute,
    required this.repeatDays,
    required this.label,
    required this.alarmType,
    required this.sound,
  });

  @override
  List<Object?> get props => [
    hour,
    minute,
    repeatDays,
    label,
    alarmType,
    sound,
  ];

  TimeOfDay get time => TimeOfDay(hour: hour, minute: minute);
}
