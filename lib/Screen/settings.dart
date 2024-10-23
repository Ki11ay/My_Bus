import 'package:flutter/material.dart';
import 'package:my_bus/Screen/languagesc.dart';
import 'package:my_bus/Screen/helpcentersc.dart';
import 'package:my_bus/Screen/notificationsc.dart';
import 'package:my_bus/components/color.dart';
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
      backgroundColor: Colors.white,
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
            highlightColor: Colors.transparent,
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const Notificationscreen()));
            },
            child: Ink(
              decoration: BoxDecoration(
                color:  Colors.transparent,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: primaryColor, width: 3),
              ),
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(
                    Icons.notifications,
                    color: primaryColor,
                  ),
                  Text(
                    AppLocalizations.of(context)!.notifications,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: primaryColor),
                  ),
                  const Icon(Icons.arrow_forward_ios, color: primaryColor)
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          InkWell(
            highlightColor: Colors.transparent,
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const Languagesc()));
            },
            child: Ink(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color:  Colors.transparent,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: primaryColor, width: 3),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(
                    Icons.language,
                    color: primaryColor,
                  ),
                  Text(
                    AppLocalizations.of(context)!.languages,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: primaryColor),
                  ),
                  const Icon(Icons.arrow_forward_ios, color: primaryColor)
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          InkWell(
            highlightColor: Colors.transparent,
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const FeedbackScreen()));
            },
            child: Ink(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color:  Colors.transparent,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: primaryColor, width: 3),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(
                    Icons.live_help_sharp,
                    color: primaryColor,
                  ),
                  Text(
                    AppLocalizations.of(context)!.helpcenter,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: primaryColor),
                  ),
                  const Icon(Icons.arrow_forward_ios, color: primaryColor)
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          InkWell(
            highlightColor: Colors.transparent,
            //TODO: navigate to the about us page
            onTap: () {
              // Navigator.of(context).push(MaterialPageRoute(
              //   builder: (context) => const testscreen(),
              // ));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Coming Soon'),
                ),  
              ) ;
            },
            child: Ink(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color:  Colors.transparent,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: primaryColor, width: 3),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(
                    Icons.person,
                    color: primaryColor,
                  ),
                  Text(
                    AppLocalizations.of(context)!.abtus,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: primaryColor),
                  ),
                  const Icon(Icons.arrow_forward_ios, color: primaryColor)
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
