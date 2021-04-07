import 'package:clinic/models/appointment.dart';
import 'package:clinic/models/notification.dart';
import 'package:clinic/models/user.dart';
import 'package:clinic/screens/shared/search_results/noResults.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'notification_card.dart';

class NotificationsList extends StatefulWidget {
  @override
  _NotificationsListState createState() => _NotificationsListState();
  List<Appointment> searchList = <Appointment>[];
}

class _NotificationsListState extends State<NotificationsList> {
  @override
  Widget build(BuildContext context) {
    final notifications = Provider.of<List<MyNotification>>(context) ?? [];
    final user = Provider.of<UserData>(context);

    if (notifications.isNotEmpty) {
      return ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return NotificationCard(
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
