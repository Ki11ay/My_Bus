import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_bus/Screen/Languagesc.dart';
import 'package:my_bus/Screen/map.dart';
import 'package:my_bus/components/color.dart';
import 'package:my_bus/Screen/onbording.dart';
import 'package:my_bus/Screen/splashscreen.dart';

class Started extends StatefulWidget {
  const Started({super.key});

  @override
  State<Started> createState() => _StartedState();
}

class _StartedState extends State<Started> {
  int currentPageIndex = 0;
  bool notification = true;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: [home(), searchs(), const MapScreen(), settings()][currentPageIndex],
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(
              icon: Icon(
                Icons.home,
                size: 30,
              ),
              label: 'Home'),
          NavigationDestination(icon: Icon(Icons.search,size: 30,), label: 'Search'),
          NavigationDestination(icon: Icon(Icons.map,size: 30,), label: 'Map'),
          NavigationDestination(icon: Icon(Icons.settings,size: 30,), label: 'Settings'),
        ],
        selectedIndex: currentPageIndex,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      ),
    );
  }

  Widget home() {
    void toggleNotification() {
      setState(() {
        notification = true;
      });
    }

    void toggleSchedule() {
      setState(() {
        notification = false;
      });
    }

    double sh = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: sh/4,
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification ? 'Find your' : 'NEVER',
                  style:
                      const TextStyle(fontWeight: FontWeight.w500, fontSize: 40),
                ),
                Text(
                  notification ? 'way' : 'MISS',
                  style:
                      const TextStyle(fontWeight: FontWeight.w700, fontSize: 40),
                ),
                Text(
                  notification ? 'Effectively' : 'YOUR RIDE',
                  style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFFFC107),
                      fontSize: 40),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          // the border between the buttons and the container
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                  style: const ButtonStyle(
                      elevation: WidgetStatePropertyAll(30),
                      visualDensity: VisualDensity.comfortable),
                  onPressed: () {
                    toggleNotification();
                  },
                  child: Text(
                    'Notifications',
                    style: TextStyle(
                        color: notification ? primaryColor : Colors.grey,
                        fontSize: 20,
                        fontWeight: FontWeight.w800),
                  )),
              TextButton(
                  onPressed: () {
                    toggleSchedule();
                  },
                  style:
                      const ButtonStyle(visualDensity: VisualDensity.comfortable),
                  child: Text(
                    'Bus schedule',
                    style: TextStyle(
                        color: notification ? Colors.grey : primaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w800),
                  )),
            ],
          ),
      
          const SizedBox(
            height: 20,
          ),
          // the border between the buttons and the container
          notification
              ? Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _db
                        .collection('notifications')
                        .orderBy('time', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(child: Text('No notifications found.'));
                      }
                      var notifications = snapshot.data!.docs;
                      return ListView.builder(
                        itemCount: notifications.length,
                        itemBuilder: (context, index) {
                          var data = notifications[index].data() as Map<String, dynamic>;
                          return Container(
                            height:70,
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(182, 209, 212, 220),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                const SizedBox(width: 10),
                                const Icon(Icons.announcement),
                                const SizedBox(width: 10),
                                Flexible(
                                  fit: FlexFit.loose,
                                  child: Text(
                                    data['info'] ?? 'No info available',
                                    style: const TextStyle(color: primaryColor),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                )
              : Container(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/Schedule.png',
                        height: 300,
                        width: MediaQuery.of(context).size.width,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: primaryColor),
                        child: TextButton(
                          onPressed: () {},
                          child: const Text(
                            "Download the PDF",
                            style: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
        ],
      ),
    );
  }

  Widget settings() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50,horizontal: 15),
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
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const Languagesc()));
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
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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

  Widget searchs() {
    return  Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 100),
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),color: const Color.fromARGB(99, 221, 170, 170)),
          padding: const EdgeInsets.all(8),
          child: const TextField(
            onTap: null,
            showCursor: true,
            decoration: InputDecoration(
              icon: Icon(Icons.search,size: 30,),
              ),
          )
          ),
      ),
    );
  }

}
