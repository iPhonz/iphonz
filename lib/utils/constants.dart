import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Colors.black;
  static const Color background = Colors.white;
  static const Color divider = Color(0xFFEEEEEE);
  static const Color textPrimary = Colors.black;
  static const Color textSecondary = Colors.grey;
  static const Color iconActive = Colors.black;
  static const Color iconInactive = Colors.grey;
}

class AppTextStyles {
  static const TextStyle appBarTitle = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 30,
    fontWeight: FontWeight.bold,
  );
  
  static const TextStyle username = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );
  
  static const TextStyle postContent = TextStyle(
    fontSize: 18,
  );
  
  static const TextStyle engagementCount = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 14,
  );
  
  static const TextStyle userBio = TextStyle(
    color: Color(0xFF666666),
    fontSize: 14,
  );
}