import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const HymnMatchApp());
}

class HymnMatchApp extends StatelessWidget {
  const HymnMatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HymnMatch',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3F51B5)),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
