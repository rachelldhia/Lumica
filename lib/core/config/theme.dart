import 'package:flutter/material.dart';
import 'package:lumica_app/core/config/text_theme.dart';

class AppColors {
  //------primary color-------
  static const Color vividOrange = Color(0xFFFE8235);
  static const Color paleSalmon = Color(0xFFFFD2C2);
  static const Color forestGreen = Color(0xFF53A06E);
  static const Color stoneGray = Color(0xFFD6CCC6);
  static const Color skyBlue = Color(0xFFD9E8FC);
  static const Color amethyst = Color(0xFFAEAFF7);
  static const Color mossGreen = Color(0xFF9BB068);
  //------warna mood icon-----
  static const Color lightSkyBlue = Color(0xFFB6F3FF);
  static const Color darkBlue = Color(0xFF3B5284);
  static const Color darkGray = Color(0xFF6C757D);
  static const Color lavenderBlue = Color(0xFFA1C1FD);
  static const Color brightRed = Color(0xFFD00000);
  static const Color brightPink = Color(0xFFFF007F);
  static const Color brightYellow = Color(0xFFFFD93D);
  static const Color deepPurple = Color(0xFF371B34);
  //------warna text-----
  static const Color darkBrown = Color(0xFF4B3425);
  static const Color darkSlateGray = Color(0xFF707070);
  //-----warna basic------
  static const Color whiteColor = Color(0xFFFFFFFF);
  static const Color blackColor = Color(0xFF000000);
  static const Color orange = Color(0xFFFE8235);
  static const Color orangeAccent = Color(0xFFFFD2C2);
  static const Color greyText = Color(0xFF9E9E9E);
  static const Color circlePurple = Color(0xffFCDDEC);

  //------dark mode colors------
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkCard = Color(0xFF2C2C2C);
  static const Color darkBorder = Color(0xFF3C3C3C);

  // Adjusted based on user feedback: "orange terang" (bright orange)
  static const Color brightOrange = Color(0xFFFF985E);

  // Adjusted based on user feedback: "abu jadi putih" (gray to white)
  static const Color darkTextPrimary = Color(0xFFFFFFFF); // Pure white
  static const Color darkTextSecondary = Color(0xFFEEEEEE); // Very light gray

  static const Color darkAmethyst = Color(
    0xFFC5C6FF,
  ); // Lighter purple for dark mode
  static const Color darkGreen = Color(
    0xFF6DBF85,
  ); // Lighter green for dark mode
}

class AppTheme {
  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.whiteColor,
      primaryColor: AppColors.vividOrange,
      colorScheme: const ColorScheme.light(
        primary: AppColors.vividOrange,
        secondary: AppColors.amethyst,
        surface: AppColors.whiteColor,
        error: AppColors.brightRed,
        onPrimary: AppColors.whiteColor,
        onSecondary: AppColors.whiteColor,
        onSurface: AppColors.darkBrown,
        onError: AppColors.whiteColor,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.darkBrown),
        titleTextStyle: TextStyle(
          color: AppColors.darkBrown,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.whiteColor,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      textTheme: AppTextTheme.textTheme.apply(
        displayColor: AppColors.darkBrown,
        bodyColor: AppColors.darkBrown,
      ),
    );
  }
}
