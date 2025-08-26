import 'package:flutter/material.dart';
import 'package:akarat/widgets/dashboard_main_page.dart';
import 'l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'services/notification_service.dart'; // ADD THIS IMPORT

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize notification service
  final notificationService = NotificationService();
  final initialized = await notificationService.initialize();

  if (initialized) {
    // Show welcome notification
    await notificationService.showWelcomeNotification();

    // Schedule daily notifications
    notificationService.scheduleDailyNotifications();

    print('Notification system initialized successfully!');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar', ''),
        Locale('en', ''),
      ],
      locale: const Locale('ar', ''),
      debugShowCheckedModeBanner: false,
      home: DashboardMainPage(),
    );
  }
}