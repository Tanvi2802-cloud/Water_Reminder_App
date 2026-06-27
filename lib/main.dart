import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';
import 'notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔔 Init notifications (IMPORTANT)
  await NotificationService.init();

  runApp(const AquaNovaApp());
}

class AquaNovaApp extends StatelessWidget {
  const AquaNovaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AquaNova',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}