import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_bus/Screen/splashscreen.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.ajak
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const Splash(),
    );
  }
}