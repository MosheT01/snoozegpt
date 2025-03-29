import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/alarm_bloc/alarm_bloc.dart';
import '../../../blocs/alarm_bloc/alarm_event.dart';
import '../../../blocs/alarm_bloc/alarm_state.dart';

class AlarmListScreen extends StatelessWidget {
  const AlarmListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Alarms')),
      body: BlocBuilder<AlarmBloc, AlarmState>(
        builder: (context, state) {
          if (state.alarms.isEmpty) {
            return const Center(child: Text('No alarms yet.'));
          }
          return ListView.builder(
            itemCount: state.alarms.length,
            itemBuilder: (context, index) {
              final alarmTime = state.alarms[index];
              return ListTile(
                leading: const Icon(Icons.alarm),
                title: Text(
                  '${alarmTime.hour.toString().padLeft(2, '0')}:${alarmTime.minute.toString().padLeft(2, '0')}',
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final TimeOfDay? pickedTime = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
          );

          if (pickedTime != null) {
            final now = DateTime.now();
            final selectedTime = DateTime(
              now.year,
              now.month,
              now.day,
              pickedTime.hour,
              pickedTime.minute,
            );

            context.read<AlarmBloc>().add(AddAlarm(selectedTime));
          }
        },

        child: const Icon(Icons.add),
      ),
    );
  }
}
