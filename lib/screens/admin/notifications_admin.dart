import 'package:clinic/screens/shared/constants.dart';
import 'package:flutter/material.dart';

class NotificationsAdmin extends StatefulWidget {
  static final id = 'NotificationsAdmin';
  @override
  _NotificationsAdminState createState() => _NotificationsAdminState();
}

class _NotificationsAdminState extends State<NotificationsAdmin> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          // padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
          height: size.height * 0.1,
          width: double.infinity,
          color: kPrimaryColor,
          child: Center(
            child: Text(
              'Notifications',
              style: TextStyle(
                fontSize: size.width * 0.06,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
