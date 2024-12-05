import 'package:flutter/material.dart';
import 'package:my_bus/components/color.dart';
import 'package:my_bus/main.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Languagesc extends StatelessWidget {
  const Languagesc({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(
          AppLocalizations.of(context)!.languages,
            style: TextStyle(color: Colors.white, fontSize: MediaQuery.of(context).size.height * 0.025)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
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
                  Image.asset('assets/images/LOGO1.png', height: MediaQuery.of(context).size.height * 0.25,),
                  Text('Please select your language',
                      style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.height * 0.025)),
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
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.transparent,
                        border: Border.all(color: primaryColor, width: 3),
                        ),
                    child: TextButton(
                      onPressed: () {
                        Locale newLocale = const Locale('tr');
                        MyApp.setLocale(context, newLocale);
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Turkish",
                        style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context).size.height * 0.025,)
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 20, 0, 50),
                    width: MediaQuery.of(context).size.width * .9,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.transparent,
                        border: Border.all(color: primaryColor, width: 3),
                        ),
                    child: TextButton(
                      onPressed: () {
                        Locale newLocale = const Locale('en');
                        MyApp.setLocale(context, newLocale);
                        Navigator.pop(context);
                      },
                      child: Text(
                        "English",
                        style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context).size.height * 0.025,),
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
