import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const SpillApp());
}

class SpillApp extends StatelessWidget {
  const SpillApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Set status bar color to match the app design
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SPILL',
      theme: ThemeData(
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Color(0xFFF8E4E8), // Light pink background
        fontFamily: 'Inter',
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        colorScheme: ColorScheme.light(
          primary: Colors.black,
          secondary: Color(0xFF7941FF), // Purple accent color for buttons
        ),
      ),
      home: const HomeScreen(),
    );
  }
}