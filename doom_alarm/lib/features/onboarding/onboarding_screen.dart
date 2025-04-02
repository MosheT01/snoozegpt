import 'package:doom_alarm/core/utils/permissions_helper.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../alarm/ui/alarm_list_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  Future<void> _handlePermissions(BuildContext context) async {
    if (!await Permission.notification.isGranted) {
      await Permission.notification.request();
    }

    if (!await Permission.scheduleExactAlarm.isGranted) {
      await Permission.scheduleExactAlarm.request();
    }

    // After requesting, re-check and move on if all are granted
    final hasAll = await PermissionsHelper.hasAllPermissions();
    if (hasAll) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AlarmListScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please grant all permissions to continue"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              const Text(
                "Welcome to Doom Alarm",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                "To make sure your alarms work perfectly, we'll ask for some permissions.",
                style: TextStyle(fontSize: 16),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _handlePermissions(context),
                  child: const Text("Continue"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
