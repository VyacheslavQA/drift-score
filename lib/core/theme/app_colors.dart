import 'package:flutter/material.dart';

class AppColors {
  // Основные цвета
  static const Color background = Color(0xFF223A5E);
  static const Color primary = Color(0xFF48A09B);
  static const Color secondary = Color(0xFFDFAF6C);
  static const Color upcoming = Color(0xFFF27E4E);
  static const Color text = Color(0xFFFFFFFF);

  // Дополнительные оттенки
  static const Color primaryDark = Color(0xFF3A8A86);

  // Прозрачности
  static Color textSecondary = text.withOpacity(0.7);
  static Color textTertiary = text.withOpacity(0.4);
  static Color surfaceLight = Colors.white.withOpacity(0.05);
  static Color surfaceMedium = Colors.white.withOpacity(0.08);
  static Color borderLight = Colors.white.withOpacity(0.1);
  static Color borderMedium = Colors.white.withOpacity(0.15);
  static Color borderDark = Colors.white.withOpacity(0.2);

  // Тени
  static Color shadowPrimary = primary.withOpacity(0.3);
  static Color shadowUpcoming = upcoming.withOpacity(0.3);
  static Color shadowBlack = Colors.black.withOpacity(0.2);
}