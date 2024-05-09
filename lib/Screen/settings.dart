import 'package:flutter/material.dart';
import 'package:my_bus/Languagesc.dart';
import 'package:my_bus/home.dart';
import 'package:my_bus/Screen/onbording.dart';
import 'package:my_bus/Screen/splashscreen.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    int currentPageIndex = 3;
    return Scaffold(
      body: settings(),
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(
              icon: Icon(
                Icons.home,
              ),
              label: 'Home'),
          NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
          NavigationDestination(icon: Icon(Icons.map), label: 'Map'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
        selectedIndex: currentPageIndex,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
    );
  }
 Widget settings (){
  return Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              //TODO: navigate to the notifications page
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const Splash()));
              },
              child: Ink(
                padding: const EdgeInsets.all(20),
                color: const Color.fromARGB(255, 248, 247, 247),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      Icons.notifications,
                      color: Colors.amber,
                    ),
                    Text(
                      'Notifications',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Icon(Icons.arrow_forward_ios, color: Colors.amber)
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const Languagesc()));
              },
              child: Ink(
                padding: const EdgeInsets.all(20),
                color: const Color.fromARGB(255, 248, 247, 247),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      Icons.language,
                      color: Colors.amber,
                    ),
                    Text(
                      'Languages',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Icon(Icons.arrow_forward_ios, color: Colors.amber)
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            InkWell(
              //TODO: navigate to the help page
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const OnboardingPage()));
              },
              child: Ink(
                padding: const EdgeInsets.all(20),
                color: const Color.fromARGB(255, 248, 247, 247),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      Icons.live_help_sharp,
                      color: Colors.amber,
                    ),
                    Text(
                      'Help Center',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Icon(Icons.arrow_forward_ios, color: Colors.amber)
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            InkWell(
              //TODO: navigate to the about us page
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const Started()));
              },
              child: Ink(
                padding: const EdgeInsets.all(20),
                color: const Color.fromARGB(255, 248, 247, 247),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      Icons.person,
                      color: Colors.amber,
                    ),
                    Text(
                      'About us',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Icon(Icons.arrow_forward_ios, color: Colors.amber)
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
