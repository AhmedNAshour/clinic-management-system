import 'package:clinic/langs/locale_keys.g.dart';
import 'package:clinic/models/notification.dart';
import 'package:clinic/models/user.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:clinic/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/lists_cards/notifications_list.dart';
import 'package:easy_localization/easy_localization.dart';

class NotificationsDoctor extends StatefulWidget {
  static final id = 'NotificationsDoctor';
  @override
  _NotificationsDoctorState createState() => _NotificationsDoctorState();
}

class _NotificationsDoctorState extends State<NotificationsDoctor> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final user = Provider.of<AuthUser>(context);

    return Column(
      children: [
        Container(
          // padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
          height: size.height * 0.1,
          width: double.infinity,
          color: kPrimaryColor,
          child: Center(
            child: Text(
              LocaleKeys.notifications.tr(),
              style: TextStyle(
                fontSize: size.width * 0.06,
                color: Colors.white,
              ),
            ),
          ),
        ),
        SizedBox(
          height: size.height * 0.02,
        ),
        Expanded(
          child: Container(
            width: size.width * 0.9,
            child: StreamProvider<List<NotificationModel>>.value(
              value: DatabaseService(uid: user.uid).getNotifications(
                status: 1,
              ),
              child: NotificationsList(),
            ),
          ),
        ),
      ],
    );
  }
}
