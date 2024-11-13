// lib/notification_service.dart
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  NotificationService(this.flutterLocalNotificationsPlugin);

  void checking(String? selectedBusStop, bool notificationsEnabled, String next, String es) {
    if (selectedBusStop != null && notificationsEnabled && selectedBusStop == next) {
      _showNotification(
        'Arriving at $selectedBusStop!',
        'The bus will arrive in $es minutes.',
      );
    }
  }

  Future<void> _showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your_channel_id', 'Next Bus Stop Alerts', importance: Importance.max, priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(0, title, body, platformChannelSpecifics);
  }
}