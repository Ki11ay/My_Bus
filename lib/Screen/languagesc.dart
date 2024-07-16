import 'package:flutter/material.dart';
import 'package:my_bus/components/color.dart';
import 'package:my_bus/main.dart';

class Languagesc extends StatelessWidget {
  const Languagesc({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/images/LOGO1.png'),
                  const Text('Please select your language')
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * .9,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: primaryColor),
                    child: TextButton(
                      onPressed: () {
                        Locale newLocale = const Locale('tr');
                        MyApp.setLocale(context, newLocale);
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Turkish",
                        style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 20, 0, 50),
                    width: MediaQuery.of(context).size.width * .9,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: primaryColor),
                    child: TextButton(
                      onPressed: () {
                        Locale newLocale = const Locale('en');
                        MyApp.setLocale(context, newLocale);
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "English",
                        style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
