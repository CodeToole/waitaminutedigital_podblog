import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Dark-mode cyberpunk and sleek editorial design tokens for Waitaminute Digital.
class AppTheme {
  // Brand Colors matching waitaminutedigital.com
  static const Color background = Color(0xFF0A0A0C);
  static const Color surface = Color(0xFF121216);
  static const Color surfaceElevated = Color(0xFF1A1A22);
  static const Color border = Color(0xFF26262B);
  static const Color navBorder = Color(0xFF1F1E24);

  // Neon & Brand Accents
  static const Color neonCyan = Color(0xFF00F0FF);
  static const Color neonViolet = Color(0xFF9D4EDD);
  static const Color neonMagenta = Color(0xFFFF007F);
  static const Color neonGreen = Color(0xFF00FF87);
  static const Color neonAmber = Color(0xFFFFB703);

  // Text Colors
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFFE2E8F0);
  static const Color textMuted = Color(0xFF71717A);

  // Gradient Accents
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [neonViolet, neonCyan],
  );

  static const LinearGradient buttonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [neonViolet, Color(0xFF00E1FF)],
  );

  // Typography Tokens (Google Fonts)
  static TextStyle headline({
    double fontSize = 24,
    FontWeight fontWeight = FontWeight.w700,
    Color color = Colors.white,
    double? height,
    double? letterSpacing,
  }) {
    return GoogleFonts.spaceGrotesk(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle eyebrow({
    double fontSize = 12,
    FontWeight fontWeight = FontWeight.w600,
    Color color = neonCyan,
    double letterSpacing = 1.2,
  }) {
    return GoogleFonts.spaceMono(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle body({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w400,
    Color color = const Color(0xFFE2E8F0),
    double? height,
  }) {
    return GoogleFonts.inter(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
    );
  }

  static ThemeData get darkTheme {
    final baseTextTheme = Typography.material2021(platform: TargetPlatform.windows).white;

    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      primaryColor: neonCyan,
      canvasColor: surface,
      colorScheme: const ColorScheme.dark(
        primary: neonCyan,
        secondary: neonViolet,
        surface: surface,
        error: neonMagenta,
        onPrimary: Colors.black,
        onSecondary: Colors.white,
        onSurface: textPrimary,
      ),
      textTheme: GoogleFonts.interTextTheme(baseTextTheme).copyWith(
        displayLarge: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w700, color: Colors.white),
        displayMedium: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w700, color: Colors.white),
        displaySmall: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w700, color: Colors.white),
        headlineLarge: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w700, color: Colors.white),
        headlineMedium: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w700, color: Colors.white),
        headlineSmall: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w700, color: Colors.white),
        titleLarge: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w700, color: Colors.white),
        titleMedium: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w600, color: Colors.white),
        titleSmall: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w600, color: Colors.white),
        bodyLarge: GoogleFonts.inter(color: const Color(0xFFE2E8F0)),
        bodyMedium: GoogleFonts.inter(color: const Color(0xFFE2E8F0)),
        bodySmall: GoogleFonts.inter(color: textMuted),
        labelLarge: GoogleFonts.spaceMono(fontSize: 12, letterSpacing: 1.2, fontWeight: FontWeight.w600),
        labelMedium: GoogleFonts.spaceMono(fontSize: 11, letterSpacing: 1.0, fontWeight: FontWeight.w600),
        labelSmall: GoogleFonts.spaceMono(fontSize: 10, letterSpacing: 0.8, fontWeight: FontWeight.w600),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        toolbarHeight: 64,
        centerTitle: false,
        titleTextStyle: GoogleFonts.spaceGrotesk(
          color: textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: border, width: 1),
        ),
      ),
    );
  }

  /// Returns tailored accent colors for category badges
  static Color badgeColor(String badge) {
    switch (badge.toUpperCase()) {
      case 'ARCHITECTURE':
        return neonCyan;
      case 'POST-MORTEM':
        return neonMagenta;
      case 'SHIPPED':
        return neonGreen;
      case 'DEVLOG':
        return neonAmber;
      default:
        return neonViolet;
    }
  }
}
