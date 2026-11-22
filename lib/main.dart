import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/services/local_storage_service.dart';
import 'providers/language_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/ai_chat_provider.dart';
import 'providers/prescription_provider.dart';
import 'providers/hospital_provider.dart';
import 'providers/appointment_provider.dart';
import 'providers/health_records_provider.dart';
import 'providers/reminder_provider.dart';
import 'providers/rural_health_provider.dart';
import 'providers/network_provider.dart';
import 'screens/splash_onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorageService.init();

  runApp(const CareSphereRootApp());
}

class CareSphereRootApp extends StatelessWidget {
  const CareSphereRootApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => AiChatProvider()),
        ChangeNotifierProvider(create: (_) => PrescriptionProvider()),
        ChangeNotifierProvider(create: (_) => HospitalProvider()),
        ChangeNotifierProvider(create: (_) => AppointmentProvider()),
        ChangeNotifierProvider(create: (_) => HealthRecordsProvider()),
        ChangeNotifierProvider(create: (_) => ReminderProvider()),
        ChangeNotifierProvider(create: (_) => RuralHealthProvider()),
        ChangeNotifierProvider(create: (_) => NetworkProvider()),
      ],
      child: const CareSphereApp(),
    );
  }
}

class CareSphereApp extends StatelessWidget {
  const CareSphereApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      title: 'CareSphere AI',
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: AppTheme.lightTheme(
        textScale: themeProvider.textScale,
        simpleMode: themeProvider.isSimpleMode,
      ),
      darkTheme: AppTheme.darkTheme(
        textScale: themeProvider.textScale,
        simpleMode: themeProvider.isSimpleMode,
      ),
      home: const SplashOnboardingScreen(),
    );
  }
}
