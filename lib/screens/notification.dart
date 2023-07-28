import 'package:flutter/material.dart';
import 'package:mobilicis/models/pushnotification.dart';

class NotificationScreen extends StatelessWidget {
  PushNotification notifications;

  NotificationScreen({super.key, required this.notifications});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: ListView.builder(
        itemCount: 1,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(notifications.title.toString()),
              subtitle: Text(notifications.body.toString()),
            ),
          );
        },
      ),
    );
  }
}
