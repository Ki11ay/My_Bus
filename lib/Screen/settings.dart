import 'package:flutter/material.dart';
import 'package:my_bus/Screen/Languagesc.dart';
import 'package:my_bus/Screen/helpcentersc.dart';
import 'package:my_bus/components/color.dart';
import 'package:my_bus/home.dart';
import 'package:my_bus/Screen/splashscreen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: settings(),
    );
  }
 Widget settings (){
  return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50,horizontal: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            highlightColor: primaryColor,
            //TODO: navigate to the notifications page
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const Splash()));
            },
            child: Ink(
              padding: const EdgeInsets.all(20),
              color: const Color.fromARGB(255, 248, 247, 247),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(
                    Icons.notifications,
                    color: Colors.amber,
                  ),
                  Text(
                    AppLocalizations.of(context)!.notifications,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Icon(Icons.arrow_forward_ios, color: Colors.amber)
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          InkWell(
            highlightColor: primaryColor,
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const Languagesc()));
            },
            child: Ink(
              padding: const EdgeInsets.all(20),
              color: const Color.fromARGB(255, 248, 247, 247),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(
                    Icons.language,
                    color: Colors.amber,
                  ),
                  Text(
                    AppLocalizations.of(context)!.languages,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Icon(Icons.arrow_forward_ios, color: Colors.amber)
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          InkWell(
            highlightColor: primaryColor,
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const FeedbackScreen()));
            },
            child: Ink(
              padding: const EdgeInsets.all(20),
              color: const Color.fromARGB(255, 248, 247, 247),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(
                    Icons.live_help_sharp,
                    color: Colors.amber,
                  ),
                  Text(
                    AppLocalizations.of(context)!.helpcenter,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Icon(Icons.arrow_forward_ios, color: Colors.amber)
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          InkWell(
            highlightColor: primaryColor,
            //TODO: navigate to the about us page
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const Started()));
            },
            child: Ink(
              padding: const EdgeInsets.all(20),
              color: const Color.fromARGB(255, 248, 247, 247),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(
                    Icons.person,
                    color: Colors.amber,
                  ),
                  Text(
                    AppLocalizations.of(context)!.abtus,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Icon(Icons.arrow_forward_ios, color: Colors.amber)
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 90,
          ),
          const Text(
            'MYBUS 0.1',
            style: TextStyle(fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
 }
  
}
