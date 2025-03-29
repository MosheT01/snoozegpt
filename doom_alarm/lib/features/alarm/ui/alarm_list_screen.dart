import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/alarm_bloc/alarm_bloc.dart';
import '../../../blocs/alarm_bloc/alarm_state.dart';
import '../../../core/models/alarm_model.dart';
import 'add_alarm_screen.dart';
import '../../../blocs/alarm_bloc/alarm_event.dart';

class AlarmListScreen extends StatelessWidget {
  const AlarmListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Doom Alarm',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<AlarmBloc, AlarmState>(
        builder: (context, state) {
          if (state.alarms.isEmpty) {
            return const Center(
              child: Text(
                'No alarms set yet.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: state.alarms.length,
            itemBuilder: (context, index) {
              final alarm = state.alarms[index];
              final timeText =
                  '${alarm.hour.toString().padLeft(2, '0')}:${alarm.minute.toString().padLeft(2, '0')}';

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.alarm,
                              size: 28,
                              color: Colors.deepPurple,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              timeText,
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          alarm.label,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          children: [
                            ...alarm.repeatDays.map(
                              (day) => Chip(
                                label: Text(day),
                                backgroundColor: Colors.deepPurple.shade50,
                              ),
                            ),
                            Chip(
                              label: Text(alarm.alarmType),
                              backgroundColor: Colors.orange.shade100,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final alarm = await Navigator.push<AlarmModel>(
            context,
            MaterialPageRoute(builder: (_) => const AddAlarmScreen()),
          );

          if (alarm != null) {
            context.read<AlarmBloc>().add(AddAlarm(alarm));
          }
        },
        icon: const Icon(Icons.add),
        label: const Text("Add Alarm"),
      ),
    );
  }
}
