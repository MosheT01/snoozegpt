import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
void alarmCallback() async {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'alarm_notif',
    'Alarm Notification',
    channelDescription: 'Channel for Alarm notification',
    importance: Importance.max,
    priority: Priority.high,
    sound: RawResourceAndroidNotificationSound(
      'alarm_sound',
    ), // Add sound to android/app/src/main/res/raw/
    playSound: true,
    fullScreenIntent: true,
  );

  const NotificationDetails platformDetails = NotificationDetails(
    android: androidDetails,
  );

  await flutterLocalNotificationsPlugin.show(
    0,
    'Doom Alarm',
    'Time to wake up!',
    platformDetails,
  );
}
