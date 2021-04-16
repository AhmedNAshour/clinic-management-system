import 'package:clinic/screens/shared/constants.dart';
import 'package:flutter/material.dart';

class NotificationSettingsManager extends StatefulWidget {
  static final id = 'NotificationSettingsManager';
  @override
  _NotificationSettingsManagerState createState() =>
      _NotificationSettingsManagerState();
}

class _NotificationSettingsManagerState
    extends State<NotificationSettingsManager> {
  String currentPassword = '';
  String newPassword = '';
  String newPasswordConfirm = '';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              height: size.height * 0.1,
              width: double.infinity,
              color: kPrimaryColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  BackButton(
                    color: Colors.white,
                  ),
                  SizedBox(width: size.width * 0.13),
                  Text(
                    'Notification Settings',
                    style: TextStyle(
                      fontSize: size.width * 0.06,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: size.height * 0.03,
            ),
          ],
        ),
      ),
    );
  }
}