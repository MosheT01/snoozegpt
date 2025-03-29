import 'package:flutter/material.dart';
import '../../../core/models/alarm_model.dart';

class AddAlarmScreen extends StatefulWidget {
  const AddAlarmScreen({super.key});

  @override
  State<AddAlarmScreen> createState() => _AddAlarmScreenState();
}

class _AddAlarmScreenState extends State<AddAlarmScreen> {
  TimeOfDay selectedTime = TimeOfDay.now();
  String label = "Alarm";
  String alarmType = "Default";
  String sound = "Default";
  List<String> selectedDays = [];

  final List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  Future<void> _editLabel() async {
    final controller = TextEditingController(text: label);
    final result = await showDialog<String>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Alarm Label'),
            content: TextField(
              controller: controller,
              autofocus: true,
              decoration: const InputDecoration(hintText: 'Enter label'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, controller.text.trim()),
                child: const Text('Save'),
              ),
            ],
          ),
    );
    if (result != null && result.isNotEmpty) {
      setState(() {
        label = result;
      });
    }
  }

  Future<void> _selectAlarmType() async {
    final types = ['Default', 'Math', 'Voice', 'Photo'];
    final result = await showModalBottomSheet<String>(
      context: context,
      builder:
          (_) => ListView(
            shrinkWrap: true,
            children:
                types
                    .map(
                      (type) => ListTile(
                        title: Text(type),
                        onTap: () => Navigator.pop(context, type),
                      ),
                    )
                    .toList(),
          ),
    );
    if (result != null) {
      setState(() => alarmType = result);
    }
  }

  Future<void> _selectSound() async {
    final sounds = ['Default', 'Morning Breeze', 'Radar', 'Loud Siren'];
    final result = await showModalBottomSheet<String>(
      context: context,
      builder:
          (_) => ListView(
            shrinkWrap: true,
            children:
                sounds
                    .map(
                      (s) => ListTile(
                        title: Text(s),
                        onTap: () => Navigator.pop(context, s),
                      ),
                    )
                    .toList(),
          ),
    );
    if (result != null) {
      setState(() => sound = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final timeFormatted =
        "${selectedTime.hourOfPeriod.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')} ${selectedTime.period == DayPeriod.am ? 'AM' : 'PM'}";

    return Scaffold(
      appBar: AppBar(title: const Text("Add Alarm")),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: _pickTime,
                child: Center(
                  child: Text(
                    timeFormatted,
                    style: const TextStyle(
                      fontSize: 52,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                "Repeat Days",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Wrap(
                spacing: 8,
                children:
                    days.map((day) {
                      final isSelected = selectedDays.contains(day);
                      return ChoiceChip(
                        label: Text(day),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            isSelected
                                ? selectedDays.remove(day)
                                : selectedDays.add(day);
                          });
                        },
                      );
                    }).toList(),
              ),
              const SizedBox(height: 24),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text("Label"),
                subtitle: Text(label),
                trailing: const Icon(Icons.edit),
                onTap: _editLabel,
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text("Alarm Type"),
                subtitle: Text(alarmType),
                trailing: const Icon(Icons.chevron_right),
                onTap: _selectAlarmType,
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text("Sound"),
                subtitle: Text(sound),
                trailing: const Icon(Icons.music_note),
                onTap: _selectSound,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    final alarm = AlarmModel(
                      hour: selectedTime.hour,
                      minute: selectedTime.minute,
                      repeatDays: selectedDays,
                      label: label,
                      alarmType: alarmType,
                      sound: sound,
                    );
                    Navigator.pop(context, alarm);
                  },
                  icon: const Icon(Icons.save),
                  label: const Text("Save Alarm"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
