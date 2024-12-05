
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
  late double screenWidth = MediaQuery.of(context).size.width;

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
    // ignore: deprecated_member_use
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: [home(),  const SearchScreen(), const MapScreen(), const Setting()][currentPageIndex],
        bottomNavigationBar: NavigationBar(
          // shadowColor: Colors.black,
          backgroundColor: Colors.transparent,
          destinations: [
            NavigationDestination(icon:  Icon(Icons.home,size: screenWidth * 0.08,color: primaryColor, ),label: AppLocalizations.of(context)!.home),
            NavigationDestination(icon: Icon(Icons.search,size: screenWidth * 0.08,color: primaryColor,), label: AppLocalizations.of(context)!.search),
            NavigationDestination(icon: Icon(Icons.map,size: screenWidth * 0.08,color: primaryColor,), label: AppLocalizations.of(context)!.map),
            NavigationDestination(icon: Icon(Icons.settings,size: screenWidth * 0.08,color: primaryColor,), label: AppLocalizations.of(context)!.settings),
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
      padding: EdgeInsets.only(top: sh * 0.045, bottom: sh * 0.02),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification ? AppLocalizations.of(context)!.findyour : AppLocalizations.of(context)!.never,
                  style:
                      TextStyle(fontWeight: FontWeight.w500, fontSize: screenWidth * 0.09),
                ),
                Text(
                  notification ? AppLocalizations.of(context)!.way : AppLocalizations.of(context)!.miss,
                  style:
                       TextStyle(fontWeight: FontWeight.w700, fontSize: screenWidth * 0.09),
                ),
                Text(
                  notification ? AppLocalizations.of(context)!.effectively : AppLocalizations.of(context)!.urride,
                  style:  TextStyle(
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFFFFC107),
                      fontSize: screenWidth * 0.09),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                      style: ButtonStyle(
                          elevation: WidgetStatePropertyAll(screenWidth * 0.02),
                          visualDensity: VisualDensity.comfortable),
                      onPressed: () {
                        toggleNotification();
                      },
                      child: Text(
                        AppLocalizations.of(context)!.announcements,
                        style: TextStyle(
                            color: notification ? primaryColor : Colors.grey,
                            fontSize: screenWidth * 0.055,
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
                            fontSize: screenWidth * 0.055,
                            fontWeight: FontWeight.w800),
                      )),
                ],
              ),
            ),
          ),
          SizedBox(
            height: sh * 0.02,
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
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                children: [
                                  const SizedBox(width: 10),
                                  Icon(Icons.announcement ,size: screenWidth * 0.07 ,color: primaryColor,),
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
              : Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      scheduleUrl != ''
                      ?Image(image: NetworkImage(scheduleUrl!), width: screenWidth * 0.95,)
                      : const CircularProgressIndicator(),
                      SizedBox(
                        height: screenWidth * 0.035,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                        margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
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
                            style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: screenWidth * 0.05),
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