import 'package:flutter/material.dart';

/// アプリケーション全体で使用するカラーパレット
class AppColors {
  AppColors._();

  // Background Gradients (Dreamy Sky / Magic Hour)
  static const Color backgroundStart = Color(0xFF2E1A47); // Deep Purple
  static const Color backgroundEnd = Color(0xFFF18C8E); // Soft Pink

  // Glassmorphism
  static const Color glassWhite = Color(0x1AFFFFFF); // White with 10% opacity
  static const Color glassBorder = Color(0x33FFFFFF); // White with 20% opacity

  // Text Colors
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color textBlack = Color(0xFF2D2D2D); // Softer black
  static const Color textGray = Color(0xFFE0E0E0); // Light gray for dark bg

  // UI Elements
  static const Color primary = Color(0xFF6C63FF); // Modern Purple
  static const Color secondary = Color(0xFFFF6584); // Soft Red/Pink
  static const Color accent = Color(0xFF00E5FF); // Cyan Neon
  static const Color error = Color(0xFFFF4B4B);
  static const Color success = Color(0xFF00E676);

  // Balloon Colors (Vibrant & Pastel mix)
  static const Color balloonRed = Color(0xFFFF5252);
  static const Color balloonOrange = Color(0xFFFFAB40);
  static const Color balloonYellow = Color(0xFFFFD740);
  static const Color balloonYellowGreen = Color(0xFFAEEA00);
  static const Color balloonGreen = Color(0xFF00E676);
  static const Color balloonCyan = Color(0xFF18FFFF);
  static const Color balloonBlue = Color(0xFF448AFF);
  static const Color balloonPurple = Color(0xFFE040FB);

  // Shadows
  static const Color shadowColor = Color(0x66000000);
  static const Color glowColor = Color(0x88FFFFFF);
}
