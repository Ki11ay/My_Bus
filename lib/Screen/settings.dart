import 'package:flutter/material.dart';
import 'package:my_bus/Screen/aboutus.dart';
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
  double width = MediaQuery.of(context).size.width;
  double height = MediaQuery.of(context).size.height;
  return Padding(
      padding: EdgeInsets.symmetric(vertical: height/20,horizontal: width * 0.04),
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
              padding: EdgeInsets.all(height * 0.02),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.notifications,
                    color: primaryColor,
                    size: height * 0.03,
                  ),
                  Text(
                    AppLocalizations.of(context)!.notifications,
                    style: TextStyle(fontSize: height * 0.025, fontWeight: FontWeight.bold,color: primaryColor),
                  ),
                  Icon(Icons.arrow_forward_ios, color: primaryColor, size: height * 0.03,)
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
                  Icon(
                    Icons.language,
                    color: primaryColor,
                    size: height * 0.03,
                  ),
                  Text(
                    AppLocalizations.of(context)!.languages,
                    style: TextStyle(fontSize: height * 0.025, fontWeight: FontWeight.bold,color: primaryColor),
                  ),
                  Icon(Icons.arrow_forward_ios, color: primaryColor, size: height * 0.03,)
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
                  Icon(
                    Icons.live_help_sharp,
                    color: primaryColor,
                    size: height * 0.03,
                  ),
                  Text(
                    AppLocalizations.of(context)!.helpcenter,
                    style: TextStyle(fontSize: height * 0.025, fontWeight: FontWeight.bold,color: primaryColor),
                  ),
                  Icon(Icons.arrow_forward_ios, color: primaryColor, size: height * 0.03,)
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
                builder: (context) => const Aboutus(),
              ));
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
                   Icon(
                    Icons.person,
                    color: primaryColor,
                    size: height * 0.03,
                  ),
                  Text(
                    AppLocalizations.of(context)!.abtus,
                    style: TextStyle(fontSize: height * 0.025, fontWeight: FontWeight.bold,color: primaryColor),
                  ),
                  Icon(Icons.arrow_forward_ios, color: primaryColor, size: height * 0.03,)
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
