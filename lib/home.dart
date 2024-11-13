// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:my_bus/Screen/map.dart';
import 'package:my_bus/Screen/serachscreen.dart';
import 'package:my_bus/Screen/settings.dart';
import 'package:my_bus/components/color.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class Started extends StatefulWidget {
  const Started({super.key});

  @override
  State<Started> createState() => _StartedState();
}

class _StartedState extends State<Started> {
  int currentPageIndex = 0;
  bool notification = true;
  String? _url;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;
  String? scheduleUrl = '';
  @override
  void initState() {
    super.initState();
    _fetchUrl();
    _fetchScheduleUrl();
  }

  Future<void> _fetchScheduleUrl() async {
    try {
      final ref = storage.ref().child('images/schedule2.png');
      final url = await ref.getDownloadURL();
      setState(() {
        scheduleUrl = url;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          // print('Error fetching schedule url: $e');
        });
      }
    }
  }
  Future<void> _fetchUrl() async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('assets')
          .doc('oFIACntJW2i86wrk6T4H')
          .get();

      if (mounted) {
        setState(() {
          _url = documentSnapshot.get('url');
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          // print('Error fetching url: $e');
        });
      }
    }
  }

  void _launchURL(BuildContext context) async {
    if (_url != null && await canLaunch(_url!)) {
      await launchUrl(Uri.parse(_url!), mode: LaunchMode.externalApplication);
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $_url')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: [home(),  const SearchScreen(), const MapScreen(), const Setting()][currentPageIndex],
      bottomNavigationBar: NavigationBar(
        // shadowColor: Colors.black,
        backgroundColor: Colors.transparent,
        destinations: [
          NavigationDestination(icon: const Icon(Icons.home,size: 30,color: primaryColor, ),label: AppLocalizations.of(context)!.home),
          NavigationDestination(icon: const Icon(Icons.search,size: 30,color: primaryColor,), label: AppLocalizations.of(context)!.search),
          NavigationDestination(icon: const Icon(Icons.map,size: 30,color: primaryColor,), label: AppLocalizations.of(context)!.map),
          NavigationDestination(icon: const Icon(Icons.settings,size: 30,color: primaryColor,), label: AppLocalizations.of(context)!.settings),
        ],
        selectedIndex: currentPageIndex,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.white,
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

    // double sh = MediaQuery.of(context).size.height;
    return Padding(
      
      padding: const EdgeInsets.only(top: 50),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            // height: sh / 5,
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification ? AppLocalizations.of(context)!.findyour : AppLocalizations.of(context)!.never,
                  style:
                      const TextStyle(fontWeight: FontWeight.w500, fontSize: 40),
                ),
                Text(
                  notification ? AppLocalizations.of(context)!.way : AppLocalizations.of(context)!.miss,
                  style:
                      const TextStyle(fontWeight: FontWeight.w700, fontSize: 40),
                ),
                Text(
                  notification ? AppLocalizations.of(context)!.effectively : AppLocalizations.of(context)!.urride,
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
          SingleChildScrollView(
            // padding: const EdgeInsets.all(30),
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 25,),
                TextButton(
                    style: const ButtonStyle(
                        elevation: WidgetStatePropertyAll(30),
                        visualDensity: VisualDensity.comfortable),
                    onPressed: () {
                      toggleNotification();
                    },
                    child: Text(
                      AppLocalizations.of(context)!.announcements,
                      style: TextStyle(
                          color: notification ? primaryColor : Colors.grey,
                          fontSize: 25,
                          fontWeight: FontWeight.w800),
                    )),
                TextButton(
                    onPressed: () {
                      toggleSchedule();
                    },
                    style:
                        const ButtonStyle(visualDensity: VisualDensity.comfortable),
                    child: Text(
                      AppLocalizations.of(context)!.busschedule,
                      style: TextStyle(
                          color: notification ? Colors.grey : primaryColor,
                          fontSize: 25,
                          fontWeight: FontWeight.w800),
                    )),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          notification
              ? Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
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
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                // color: Colors.white,
                                // border: Border.all(color: primaryColor, width: 2),
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(16),
                                // boxShadow: [
                                //   BoxShadow(
                                //     color: Colors.grey.withOpacity(0.5),
                                //     spreadRadius: 3,
                                //     blurRadius: 4,
                                //     offset: const Offset(0, 3),
                                //   ),
                                // ],
                              ),
                              child: Row(
                                children: [
                                  const SizedBox(width: 10),
                                  const Icon(Icons.announcement ,size: 30,color: primaryColor,),
                                  const SizedBox(width: 10),
                                  Flexible(
                                    fit: FlexFit.loose,
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: '${data['title'] ?? 'No title'}\n',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: primaryColor,
                                              fontSize: 20,
                                            ),
                                          ),
                                          TextSpan(
                                            text: data['info'] ?? 'No info available',
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                )
              : SingleChildScrollView(
                  // height: sh * 0.48,
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      scheduleUrl != ''
                      ?Image(image: NetworkImage(scheduleUrl!))
                      : const CircularProgressIndicator(),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.transparent,
                            border: Border.all(color: primaryColor, width: 3)),
                        child: TextButton(
                          
                          onPressed: () {
                            _launchURL(context);
                          },
                          child: Text(
                            AppLocalizations.of(context)!.downloadthepdf,
                            style: const TextStyle(
                                color: primaryColor,
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
}