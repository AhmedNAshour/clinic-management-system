import 'package:clinic/models/appointment.dart';
import 'package:clinic/models/notification.dart';
import 'package:clinic/models/user.dart';
import 'package:clinic/screens/shared/search_results/noResults.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'notification_card_client.dart';

class NotificationsListClient extends StatefulWidget {
  @override
  _NotificationsListClientState createState() =>
      _NotificationsListClientState();
  List<Appointment> searchList = <Appointment>[];
}

class _NotificationsListClientState extends State<NotificationsListClient> {
  @override
  Widget build(BuildContext context) {
    final notifications = Provider.of<List<NotificationModel>>(context) ?? [];
    final user = Provider.of<UserModel>(context);

    if (notifications.isNotEmpty) {
      return ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return NotificationCardClient(
            notification: notifications[index],
            userData: user,
          );
        },
      );
    } else {
      return NoResults(
        text: 'No notifications',
      );
    }
  }
}
