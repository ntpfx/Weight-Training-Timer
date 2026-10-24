import 'package:flutter/material.dart';

class AppColors {
  // Deep Dark Gym Theme (OLED Friendly)
  static const Color background = Color(0xFF0C0D11);
  static const Color surface = Color(0xFF151821);
  static const Color surfaceCard = Color(0xFF1B202D);
  static const Color surfaceLight = Color(0xFF262C3E);
  static const Color border = Color(0xFF2C3347);

  // Vibrant Gym Neon Accents
  static const Color electricCyan = Color(0xFF00E5FF);
  static const Color neonGreen = Color(0xFF00E676);
  static const Color neonOrange = Color(0xFFFF9100);
  static const Color urgentRed = Color(0xFFFF1744);

  // Text
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF94A0B8);
  static const Color textMuted = Color(0xFF5F6980);

  // Gradients
  static const LinearGradient restGradient = LinearGradient(
    colors: [Color(0xFF00E5FF), Color(0xFF00B0FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient warningGradient = LinearGradient(
    colors: [Color(0xFFFF9100), Color(0xFFFF5722)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient urgentGradient = LinearGradient(
    colors: [Color(0xFFFF1744), Color(0xFFD50000)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF00E676), Color(0xFF00C853)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
