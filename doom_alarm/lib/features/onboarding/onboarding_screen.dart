import 'package:doom_alarm/features/alarm/ui/alarm_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:android_intent_plus/android_intent.dart';

class PermissionStep {
  final String title;
  final String description;
  final IconData icon;
  final Future<bool> Function() checkGranted;
  final Future<void> Function(BuildContext context) requestPermission;

  PermissionStep({
    required this.title,
    required this.description,
    required this.icon,
    required this.checkGranted,
    required this.requestPermission,
  });
}

class OnboardingPermissionScreen extends StatefulWidget {
  const OnboardingPermissionScreen({super.key});

  @override
  State<OnboardingPermissionScreen> createState() =>
      _OnboardingPermissionScreenState();
}

class _OnboardingPermissionScreenState extends State<OnboardingPermissionScreen>
    with WidgetsBindingObserver {
  final PageController _controller = PageController();
  int _currentIndex = 0;
  bool _isGranted = false;

  late final List<PermissionStep> _steps;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initSteps();
    _checkCurrentPermission();
  }

  void _initSteps() {
    _steps = [
      PermissionStep(
        title: "Notification Permission",
        description: "We need permission to show alarm notifications.",
        icon: Icons.notifications_active,
        checkGranted: () => Permission.notification.isGranted,
        requestPermission: (_) async {
          await Permission.notification.request();
        },
      ),
      PermissionStep(
        title: "Exact Alarm Permission",
        description: "Allow us to trigger alarms at the right time.",
        icon: Icons.alarm,
        checkGranted: () => Permission.scheduleExactAlarm.isGranted,
        requestPermission: (_) async {
          await Permission.scheduleExactAlarm.request();
        },
      ),
      PermissionStep(
        title: "Ignore Battery Optimization",
        description:
            "Let us run in the background so your alarms aren’t delayed.",
        icon: Icons.battery_alert,
        checkGranted: () async {
          // Check directly if app is ignoring battery optimizations
          final isIgnoring =
              await Permission.ignoreBatteryOptimizations.isGranted;
          print(Permission.ignoreBatteryOptimizations.isGranted);
          return isIgnoring;
        },
        requestPermission: (_) async {
          final intent = AndroidIntent(
            action: 'android.settings.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS',
            data: 'package:com.example.doom_alarm',
          );
          await intent.launch();
        },
      ),
    ];
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      Future.delayed(const Duration(milliseconds: 300), () {
        _checkCurrentPermission();
      });
    }
  }

  Future<void> _checkCurrentPermission() async {
    final granted = await _steps[_currentIndex].checkGranted();
    setState(() {
      _isGranted = granted;
    });
  }

  void _nextStep() async {
    if (_currentIndex < _steps.length - 1) {
      setState(() {
        _currentIndex += 1;
        _isGranted = false;
      });
      _controller.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _checkCurrentPermission();
    } else {
      // Done - Navigate to your main screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AlarmListScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _controller,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _steps.length,
        itemBuilder: (_, index) {
          final step = _steps[index];
          return Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(step.icon, size: 80),
                const SizedBox(height: 24),
                Text(
                  step.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  step.description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 30),
                ElevatedButton.icon(
                  onPressed: () async {
                    await step.requestPermission(context);
                    _checkCurrentPermission();
                  },
                  icon: const Icon(Icons.settings),
                  label: const Text("Grant Permission"),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _isGranted ? _nextStep : null,
                  child: Text(
                    _currentIndex == _steps.length - 1 ? "Finish" : "Next",
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
