import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = "S'TACOS";
  static const String appTitle = "S'TACOS — Borne de Commande";

  // === COULEURS — STYLE KFC (Dark & Bold) ===
  static const Color primaryRed    = Color(0xFFE4002B); // Rouge KFC vif
  static const Color darkRed       = Color(0xFFC4001E); // Rouge foncé hover
  static const Color bgDark        = Color(0xFF1A1A1A); // Fond principal (quasi noir)
  static const Color bgCard        = Color(0xFF252525); // Fond des cartes
  static const Color bgSidebar     = Color(0xFF111111); // Fond sidebar ultra dark
  static const Color surface       = Color(0xFF2E2E2E); // Surface élément
  static const Color accentGold    = Color(0xFFFFCC00); // Or — accent prix
  static const Color accentCream   = Color(0xFFF5ECD7); // Crème pour titres
  static const Color textWhite     = Color(0xFFFFFFFF); // Blanc pur
  static const Color textCream     = Color(0xFFF0E6D3); // Blanc cassé
  static const Color textGrey      = Color(0xFF9E9E9E); // Gris secondaire
  static const Color textMuted     = Color(0xFF555555); // Gris atténué
  static const Color successGreen  = Color(0xFF2E7D32); // Vert confirmation
  static const Color waveBlue      = Color(0xFF1565C0); // Bleu Wave
  static const Color errorRed      = Color(0xFFD32F2F); // Rouge erreur

  // Alias de compatibilité avec les anciens widgets
  static const Color primaryOrange  = primaryRed;
  static const Color darkOrange     = darkRed;
  static const Color lightOrange    = Color(0xFF2A1010);
  static const Color backgroundWhite= bgDark;
  static const Color surfaceWhite   = bgCard;
  static const Color textDark       = textCream;
  static const Color textLight      = textMuted;

  // === TYPOGRAPHIE ===
  static const String fontFamily = 'Nunito';

  // === TAILLES UI ===
  static const double categorySidebarWidth = 160.0;
  static const double cardBorderRadius     = 14.0;
  static const double defaultPadding       = 16.0;
  static const double smallPadding         = 8.0;
  static const double largePadding         = 24.0;

  // === GRILLE ===
  static const int    gridCrossAxisCount   = 3;
  static const double gridChildAspectRatio = 0.82;
  static const double gridSpacing          = 14.0;

  // === INACTIVITÉ ===
  static const int inactivityTimeoutSeconds = 90;

  // === MONNAIE ===
  static const String currency = 'FCFA';

  // === THÈME MATERIAL 3 — STYLE KFC DARK ===
  static ThemeData get appTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryRed,
      brightness: Brightness.dark,
    ).copyWith(
      primary:    primaryRed,
      secondary:  accentGold,
      surface:    bgCard,
      error:      errorRed,
      onPrimary:  textWhite,
      onSurface:  textCream,
    ),
    scaffoldBackgroundColor: bgDark,
    appBarTheme: const AppBarTheme(
      backgroundColor: bgSidebar,
      foregroundColor: textCream,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: textCream,
        fontSize: 20,
        fontWeight: FontWeight.w900,
        letterSpacing: 1,
      ),
    ),
    cardTheme: CardThemeData(
      color: bgCard,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(cardBorderRadius),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryRed,
        foregroundColor: textWhite,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      hintStyle: const TextStyle(color: textMuted),
    ),
    textTheme: const TextTheme(
      displayLarge:  TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: textCream),
      displayMedium: TextStyle(fontSize: 36, fontWeight: FontWeight.w800, color: textCream),
      headlineLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: textCream),
      headlineMedium:TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: textCream),
      titleLarge:    TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: textCream),
      titleMedium:   TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: textCream),
      bodyLarge:     TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: textCream),
      bodyMedium:    TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: textGrey),
      labelLarge:    TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: textCream),
    ),
    dividerTheme: const DividerThemeData(color: surface, thickness: 1),
  );
}