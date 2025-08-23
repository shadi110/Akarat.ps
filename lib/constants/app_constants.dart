// lib/constants/app_constants.dart
import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF0A73FF);  // main theme color
  static const Color secondary = Color(0xFFFFA500); // accent color
  static const Color background = Color(0xFFF5F5F5);
  static const Color textPrimary = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF777777);
  static const Color error = Color(0xFFFF0000);
  static const Color addAdv = Color(0xFFFBC57C);
  static const  Color pastelBlue = Color(0xFFCFECEC);
  static const Color pastelYellow = Color(0xFFFFF8DC);
}

class AppPadding {
  static const double small = 8.0;
  static const double medium = 16.0;
  static const double large = 24.0;
}

class AppMargin {
  static const double small = 8.0;
  static const double medium = 16.0;
  static const double large = 24.0;
}

class AppTextStyle {
  static const TextStyle heading1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle body = TextStyle(
    fontSize: 16,
    color: AppColors.textPrimary,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    color: AppColors.textSecondary,
  );
}

class AppSizes {
  static const double borderRadius = 12.0;
  static const double iconSizeSmall = 16.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 32.0;
}
