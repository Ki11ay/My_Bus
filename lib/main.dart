import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_bus/Screen/splashscreen.dart';
import 'package:my_bus/firebase_options.dart';
import 'package:my_bus/localization_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // final messaging = FirebaseMessaging.instance;
  // // Request permission to display notifications
  // final settings = await messaging.requestPermission(
  //   alert: true,
  //   announcement: false,
  //   badge: true,
  //   carPlay: false,
  //   criticalAlert: false,
  //   provisional: false,
  //   sound: true,
  // );
  // if (kDebugMode) {
  //   print('Permission granted: ${settings.authorizationStatus}');
  // }
  // String? token = await messaging.getToken();
  // if (kDebugMode) {
  //   print('Registration Token=$token');
  // }
  if (await Permission.location.isDenied) {
    await Permission.location.request();
  }
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }
  runApp(
    ChangeNotifierProvider(
      create: (context) => LocalizationProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>()!;
    state.setLocale(newLocale);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en');
  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }
  // This widget is the root of your application.ajak
  @override
  Widget build(BuildContext context) {
      return MaterialApp(
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        debugShowCheckedModeBanner: false,
        // theme: ThemeData(
        //   useMaterial3: true,
        // ),
        locale: _locale, // Default locale
        home: const Splash(),
      );
    
  }
}
