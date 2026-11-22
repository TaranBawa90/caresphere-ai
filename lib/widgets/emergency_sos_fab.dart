import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../core/constants/app_colors.dart';
import '../screens/emergency/emergency_sos_screen.dart';

class EmergencySosFab extends StatelessWidget {
  const EmergencySosFab({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();

    return FloatingActionButton.extended(
      heroTag: 'emergency_sos_fab',
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const EmergencySosScreen()),
        );
      },
      backgroundColor: AppColors.emergency,
      foregroundColor: Colors.white,
      elevation: 6,
      icon: const Icon(Icons.emergency_rounded, size: 24),
      label: Text(
        lang.tr('navEmergency'),
        style: const TextStyle(
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
