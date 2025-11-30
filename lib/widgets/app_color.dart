import 'package:flutter/material.dart';

class AppColors {
  // 🌿 الألوان الأساسية للتطبيق
  static const Color brightGreen = Color(0xFF00C853); // أخضر أساسي
  static const Color endGradient = Color(0xFF009688); // أخضر مزرق
  static const Color background = Color(0xFFF5F5F5); // خلفية عامة فاتحة

  // 🧩 ألوان إضافية للثيم العام
  static const Color cardBackground = Colors.white; // لخلفيات الكروت والصناديق
  static const Color textPrimary = Color(0xFF1F2937); // للنصوص الأساسية (غامق)
  static const Color textSecondary = Color(0xFF6B7280); // للنصوص الثانوية (رمادي)
  static const Color error = Colors.redAccent; // للأخطاء أو التحذيرات

  // 🌑 ثيم الوضع الليلي (Dark Mode)
  static const Color darkBackground = Color(0xFF0D1117);
  static const Color darkCard = Color(0xFF161B22);
  static const Color darkTextPrimary = Colors.white;
  static const Color darkTextSecondary = Color(0xFF9CA3AF);

  // 🌈 تدريجات لزخارف بسيطة أو الأزرار
  static LinearGradient get mainGradient => const LinearGradient(
    colors: [brightGreen, endGradient],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ☀️ ثيم فاتح
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: background,
    primaryColor: brightGreen,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: textPrimary),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: textPrimary),
      bodyMedium: TextStyle(color: textSecondary),
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: brightGreen,
      brightness: Brightness.light,
    ),
  );

  // 🌙 ثيم غامق
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: darkBackground,
    primaryColor: brightGreen,
    appBarTheme: const AppBarTheme(
      backgroundColor: darkCard,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: darkTextPrimary,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: darkTextPrimary),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: darkTextPrimary),
      bodyMedium: TextStyle(color: darkTextSecondary),
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: brightGreen,
      brightness: Brightness.dark,
    ),
  );
}
