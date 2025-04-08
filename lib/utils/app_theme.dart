import 'package:flutter/material.dart';

class AppTheme {
  // Dark theme colors
  static const Color purpleDark = Color(0xFF2A1B70);
  static const Color purpleMedium = Color(0xFF6236FF);
  static const Color purpleAccent = Color(0xFF7941FF); 
  static const Color purpleLight = Color(0xFFB298FF); // Added lighter purple for contrast
  static const Color darkBackground = Color(0xFF121212);
  static const Color cardBackground = Color(0xFF1F1F1F);
  static const Color messageCardBackground = Color(0xFF2D2D2D); // Darker for message cards
  static const Color coral = Color(0xFFFF8370);
  static const Color searchBarBackground = Color(0xFF2D2D2D);
  
  // Typography colors
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFDDDDDD); // Changed from B0B0B0 to DDDDDD for better contrast
  static const Color textTertiary = Color(0xFFAAAAAA); // Added for subtle text with better contrast
  static const Color placeholderText = Color(0xFFB8B8B8); // For input placeholders
  
  // Button colors
  static const Color buttonPrimary = purpleAccent;
  static const Color buttonSecondary = coral;
  static const Color buttonText = Colors.white;
  static const Color joinedButtonText = Colors.white;
  static const Color joinButtonBackground = purpleAccent;
  
  // Group screen colors
  static const Color groupItemBackground = Color(0xFFF5F5F5);
  static const Color groupItemText = Color(0xFF333333);
  static const Color groupCountText = Color(0xFF666666);
  static const Color groupHeaderBackground = purpleDark;
  static const Color groupHeaderText = Colors.white;
  
  // Icon colors
  static const Color iconActive = purpleAccent;
  static const Color iconInactive = Color(0xFFAAAAAA); // Changed from 808080 to AAAAAA
  
  // Message screen colors
  static const Color messageBubbleOutgoing = purpleAccent;
  static const Color messageBubbleIncoming = Color(0xFF3D3D3D); 
  static const Color messageTextOutgoing = Colors.white;
  static const Color messageTextIncoming = Colors.white;
  static const Color messageInputBackground = Colors.white;
  static const Color messageInputText = Color(0xFF333333);
  static const Color messageInputBorder = purpleAccent;
  static const Color messageTimestamp = Color(0xFFB8B8B8);
  static const Color messageScreenGradientStart = purpleDark;
  static const Color messageScreenGradientEnd = Color(0xFFBF4098); // Pink-ish bottom gradient
  static const Color noMessagesYetText = Colors.white;
  static const Color messageScreenHeaderText = textPrimary;
  
  // Border radius
  static const double borderRadiusSmall = 8.0;
  static const double borderRadiusMedium = 12.0;
  static const double borderRadiusLarge = 20.0;
  static const double borderRadiusXLarge = 30.0;
  
  // Spacing
  static const double spacingXXSmall = 2.0;
  static const double spacingXSmall = 4.0;
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 16.0;
  static const double spacingLarge = 24.0;
  static const double spacingXLarge = 32.0;
  static const double spacingXXLarge = 48.0;
  
  // Dark theme
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: purpleAccent,
    scaffoldBackgroundColor: Colors.transparent,
    fontFamily: 'Inter',
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: textPrimary,
        fontSize: 30,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
      ),
      iconTheme: IconThemeData(
        color: textPrimary,
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: textPrimary,
        fontSize: 26,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: TextStyle(
        color: textPrimary,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
      displaySmall: TextStyle(
        color: textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: TextStyle(
        color: textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: TextStyle(
        color: textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: TextStyle(
        color: textPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(
        color: textPrimary,
        fontSize: 16,
      ),
      bodyMedium: TextStyle(
        color: textSecondary,
        fontSize: 14,
      ),
      labelLarge: TextStyle(
        color: textPrimary,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
      labelMedium: TextStyle(
        color: textSecondary,
        fontSize: 12,
      ),
    ),
    colorScheme: ColorScheme.dark(
      primary: purpleAccent,
      secondary: coral,
      surface: cardBackground,
      background: darkBackground,
      onBackground: textPrimary,
      onSurface: textPrimary,
    ),
    cardTheme: CardTheme(
      color: cardBackground,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadiusMedium),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: darkBackground,
      selectedItemColor: purpleAccent,
      unselectedItemColor: iconInactive,
      showSelectedLabels: false,
      showUnselectedLabels: false,
    ),
    // Button themes
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: purpleAccent,
        foregroundColor: textPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusLarge),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: spacingLarge,
          vertical: spacingMedium,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: purpleAccent,
        side: const BorderSide(color: purpleAccent),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusLarge),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: spacingLarge,
          vertical: spacingMedium,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: purpleAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusLarge),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: spacingMedium,
          vertical: spacingSmall,
        ),
      ),
    ),
    // Input decoration
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: searchBarBackground,
      hintStyle: const TextStyle(color: placeholderText),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadiusMedium),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadiusMedium),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadiusMedium),
        borderSide: const BorderSide(color: purpleAccent),
      ),
    ),
  );
  
  // Method to create a gradient background for various screens
  static BoxDecoration get purpleGradientBackground => BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        purpleDark,
        purpleMedium.withOpacity(0.8),
        messageScreenGradientEnd.withOpacity(0.9),
      ],
    ),
  );
  
  // Method to create the message gradient background
  static BoxDecoration get messageGradientBackground => BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        messageScreenGradientStart,
        messageScreenGradientEnd,
      ],
    ),
  );
}