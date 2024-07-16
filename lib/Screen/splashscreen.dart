import 'package:flutter/material.dart';
import 'package:my_bus/Screen/onbording.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  void _navigateToHome() async {
    // Optional: Use a state management solution for complex navigation logic

    // Optional: Add a loading indicator here (consider ProgressIndicator or custom widget)

    await Future.delayed(const Duration(milliseconds: 1500));

    // Use Navigator.pushReplacementNamed for named route navigation
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => const OnboardingPage()),
    );
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
            alignment: Alignment.topCenter,
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //SizedBox(height: 400,width: 400,child: )
              Positioned(child: Image.asset('assets/images/splash.png')),
              const SizedBox(
                height: 2,
              ),
              Positioned(
                  top: 400, child: Text(AppLocalizations.of(context)!.splash))
            ]),
      ),
    );
  }
}
