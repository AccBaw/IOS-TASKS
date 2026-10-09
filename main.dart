
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFFF9F2),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFFC067),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
