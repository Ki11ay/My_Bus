// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:my_bus/components/color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

class Notificationscreen extends StatefulWidget {
  const Notificationscreen({super.key});

  @override
  State<Notificationscreen> createState() => _NotificationscreenState();
}

class _NotificationscreenState extends State<Notificationscreen> {
  String? _selectedBusStop;
  bool _notificationsEnabled = false;
  List<String> _busStops = [];
  late DatabaseReference _busStopRef;
  late DatabaseReference nextStopRef;
  late String next = '';
  late String es;
  late FirebaseRemoteConfig remoteConfig;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
void initState() {
  super.initState();
  _initializeFirebaseMessaging();
  _initializeNotifications();
  _initializeRemoteConfig(); // Add this
  _fetchBusStops();
  _loadPreferences();
  nextStopRef = FirebaseDatabase.instance.ref().child('gps_locations');
  nextStopRef.onValue.listen((event) {
    final data = Map<String, dynamic>.from(event.snapshot.value as Map);
    setState(() {
      next = data['next_stop'];
      es = data['estimated'];
    });
    checking(); // Call the checking() function here
  });
}

  // Initialize Firebase Messaging for notifications
  void _initializeFirebaseMessaging() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Request permission to display notifications
    await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Listen to messages while app is in foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        _showNotification(
          message.notification!.title ?? 'Notification',
          message.notification!.body ?? 'You have a new message!',
        );
      }
    });
    // Optional: Fetch FCM token (if required for sending push notifications)
    // try {
    //   String? token = await messaging.getToken();
    //   // print("FCM Token: $token");
    // } catch (e) {
    //   print("Error fetching FCM token: $e");
    // }
  }

  // Initialize the local notification settings
  void _initializeNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Show notification with custom title and body
  Future<void> _showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'Next Bus Stop Alerts',
      channelDescription: 'Alerts for next bus stop and time remaining',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'Next Bus Stop',
      styleInformation: BigTextStyleInformation(''),
    );

    const DarwinNotificationDetails iosPlatformChannelSpecifics =
        DarwinNotificationDetails();

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iosPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
    );
  }

  // Fetch bus stops from Firestore
  void _fetchBusStops() async {
    try {
      CollectionReference busStops =
          FirebaseFirestore.instance.collection('Bus-stations');
      QuerySnapshot querySnapshot = await busStops.get();
      List<QueryDocumentSnapshot> documents = querySnapshot.docs;
      setState(() {
        _busStops = documents.map((doc) => doc['name'].toString()).toList();
      });
    } catch (e) {
      // print("Error fetching bus stops: $e");
    }
  }

  // Load saved bus stop and notification status from SharedPreferences
  void _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedBusStop = prefs.getString('selectedBusStop');
      _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? false;
    });
  }

  // Save selected bus stop to SharedPreferences
  void _saveSelectedBusStop(String busStop) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedBusStop', busStop);
  }

  // Save notification switch state to SharedPreferences
  void _saveNotificationStatus(bool status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificationsEnabled', status);
  }

  Future<void> _initializeRemoteConfig() async {
    remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(hours: 1),
    ));

    await remoteConfig.setDefaults({
      'message_title': 'Bus Alert',
      'message_body': 'Your bus is arriving soon!',
    });

    try {
      await remoteConfig.fetchAndActivate();
    } catch (e) {
      // Handle any errors
      debugPrint('Error fetching remote config: $e');
    }
  }

  void checking() {
    if (_selectedBusStop != null &&
        _notificationsEnabled &&
        _selectedBusStop == next) {
      _showNotificationWithRemoteConfig();
    }
  }

  // Modified notification method to use Remote Config values
  Future<void> _showNotificationWithRemoteConfig() async {
    try {
      // Fetch the latest config values
      await remoteConfig.fetchAndActivate();
      
      // Get the message title and body from Remote Config
      String messageTitle = remoteConfig.getString('message_title');
      String messageBody = remoteConfig.getString('message_body');
      
      // Replace placeholders in the messages if they exist
      messageTitle = messageTitle.replaceAll('{bus_stop}', _selectedBusStop ?? '');
      messageBody = messageBody.replaceAll('{estimated_time}', es);
      
      // Show the notification with Remote Config values
      await _showNotification(
        messageTitle.isEmpty ? 'Arriving at $_selectedBusStop!' : messageTitle,
        messageBody.isEmpty ? 'The bus will arrive in $es minutes.' : messageBody,
      );
    } catch (e) {
      // Fallback to default notification if Remote Config fails
      await _showNotification(
        'Arriving at $_selectedBusStop!',
        'The bus will arrive in $es minutes.',
      );
      debugPrint('Error showing notification with remote config: $e');
    }
  }
  // Show bus stop selection
  void _showBusStopSelector() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView.builder(
          itemCount: _busStops.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(_busStops[index]),
              onTap: () {
                setState(() {
                  _selectedBusStop = _busStops[index];
                });
                _saveSelectedBusStop(_busStops[index]);
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }

  // Toggle notifications on/off
  void _toggleNotifications(bool status) {
    setState(() {
      _notificationsEnabled = !_notificationsEnabled;
      _saveNotificationStatus(status);
    });
    _saveNotificationStatus(status);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: Text(
            AppLocalizations.of(context)!.notifications,
              style: const TextStyle(color: Colors.white)),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Column(
          children: [
            SizedBox(height:MediaQuery.of(context).size.height/15,),
            SwitchListTile(
              title: Text(AppLocalizations.of(context)!.enablenotifications),
              value: _notificationsEnabled,
              activeColor: primaryColor,
              onChanged: _toggleNotifications,
            ),
            SizedBox(height:MediaQuery.of(context).size.height/30,),
            ListTile(
              title: Text(AppLocalizations.of(context)!.selectbus),
              subtitle: Text(_selectedBusStop ?? 'No bus stop selected'),
              onTap: _showBusStopSelector,
            ),
            
            // Text(status),
            // Text(es),
          ],
        ),
      ),
    );
  }
}
