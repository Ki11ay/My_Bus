import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_bus/home.dart'; 
import 'package:my_bus/Screen/onbording.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool isFirstTime = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await Firebase.initializeApp();
    await Future.delayed(const Duration(seconds: 1));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isFirstTime = prefs.getBool('isFirstTime') ?? true;

    if (isFirstTime) {
      prefs.setBool('isFirstTime', false);
    }

    _navigateToNextScreen();
  }

  void _navigateToNextScreen() {
    Widget nextScreen = isFirstTime ? const OnboardingPage() : const Started();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => nextScreen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Positioned(child: Image.asset('assets/images/splash.png')),
            const SizedBox(height: 2),
            Positioned(
              top: 400,
              child: Text(AppLocalizations.of(context)!.splash),
            ),
          ],
        ),
      ),
    );
  }
}