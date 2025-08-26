import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  // Initialize notifications
  Future<bool> initialize() async {
    // Request notification permission
    await Permission.notification.request();
    final status = await Permission.notification.status;

    if (!status.isGranted) {
      print('Notification permission not granted');
      return false;
    }

    // Create notification channel
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'akarat_channel_id',
      'Akarat Notifications',
      importance: Importance.max,
      description: 'Channel for Akarat app notifications',
    );

    await notificationsPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);

    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initSettings =
    InitializationSettings(android: androidSettings);

    await notificationsPlugin.initialize(initSettings);

    return true;
  }

  // Show immediate notification
  Future<void> showWelcomeNotification() async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'akarat_channel_id',
      'Akarat Notifications',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidDetails);

    await notificationsPlugin.show(
      123,
      'تطبيق يعمل!',
      'تم تشغيل التطبيق بنجاح ✅',
      notificationDetails,
    );
  }

  // Schedule daily notifications
  void scheduleDailyNotifications() {
    Timer.periodic(Duration(minutes: 1), (timer) {
      final now = DateTime.now();
      final currentTime = TimeOfDay.fromDateTime(now);

      // 11:00 AM
      if (currentTime.hour == 11 && currentTime.minute == 0) {
        _checkAndShowNotification('11:00 صباحاً');
      }

      // 21:13 (9:13 PM)
      if (currentTime.hour == 21 && currentTime.minute == 28) {
        _checkAndShowNotification('9:28 مسا25');
      }
    });

    print('Daily notifications scheduled for 11:00 AM and 9:13 PM');
  }

  // Check API and show notification if properties exist
  Future<void> _checkAndShowNotification(String time) async {
    try {
      print('Checking API for properties at: ${DateTime.now()}');

      final response = await http.get(
        Uri.parse('https://akarat-ps-be.onrender.com/api/real-estates'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data != null && data is List && data.isNotEmpty) {
          print('Properties found: ${data.length}');
          _showPropertyNotification(time, data.length);
        } else {
          print('No properties found in API response');
        }
      } else {
        print('API error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error checking API: $e');
    }
  }

  // Show notification with property count
  void _showPropertyNotification(String time, int propertyCount) {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'akarat_channel_id',
      'Akarat Notifications',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidDetails);

    notificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      'عقارات جديدة 🏠',
      'يوجد $propertyCount عقار متاح الآن الساعة $time',
      notificationDetails,
    );

    print('Property notification shown with $propertyCount properties');
  }

  // Show custom notification (can be used from anywhere)
  Future<void> showCustomNotification(String title, String body) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'akarat_channel_id',
      'Akarat Notifications',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidDetails);

    await notificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title,
      body,
      notificationDetails,
    );
  }
}