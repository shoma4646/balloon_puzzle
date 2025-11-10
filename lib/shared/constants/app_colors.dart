import 'package:flutter/material.dart';

/// アプリケーション全体で使用するカラーパレット
class AppColors {
  AppColors._();

  // 背景色
  static const Color backgroundSky = Color(0xFF87CEEB);
  static const Color backgroundSkyLight = Color(0xFFADD8E6);
  static const Color backgroundDark = Color(0xFF1A1A2E);

  // テキスト色
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color textBlack = Color(0xFF000000);
  static const Color textGray = Color(0xFF9E9E9E);

  // UI要素
  static const Color primary = Color(0xFF4CAF50);
  static const Color secondary = Color(0xFF2196F3);
  static const Color accent = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color success = Color(0xFF4CAF50);

  // 風船の色（8段階）
  static const Color balloonRed = Color(0xFFFF6B6B);
  static const Color balloonOrange = Color(0xFFFFB347);
  static const Color balloonYellow = Color(0xFFFFE66D);
  static const Color balloonYellowGreen = Color(0xFFB4F8C8);
  static const Color balloonGreen = Color(0xFF6BCF7F);
  static const Color balloonCyan = Color(0xFF7DD3FC);
  static const Color balloonBlue = Color(0xFF5B8DEF);
  static const Color balloonPurple = Color(0xFFB983FF);

  // その他
  static const Color branchBrown = Color(0xFF8B4513);
  static const Color shadowColor = Color(0x33000000);
  static const Color overlayDark = Color(0xAA000000);
}
