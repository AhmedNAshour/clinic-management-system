import 'package:clinic/components/forms/rounded_button..dart';
import 'package:clinic/models/user.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:clinic/services/database.dart';
import 'package:flutter/material.dart';

class NotificationSettingsDoctor extends StatefulWidget {
  static final id = 'NotificationSettingsDoctor';
  UserModel userData;
  NotificationSettingsDoctor({UserModel userData}) {
    this.userData = userData;
  }
  @override
  _NotificationSettingsDoctorState createState() =>
      _NotificationSettingsDoctorState();
}

class _NotificationSettingsDoctorState
    extends State<NotificationSettingsDoctor> {
  String currentPassword = '';
  String newPassword = '';
  String newPasswordConfirm = '';
  bool loading = false;
  bool bookingNotifs;
  bool cancellingNotifs;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bookingNotifs = widget.userData.bookingNotifs;
    cancellingNotifs = widget.userData.cancellingNotifs;

    return Padding(
      padding: EdgeInsets.only(
        right: size.width * 0.04,
        left: size.width * 0.04,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: Icon(
                Icons.close,
                color: kPrimaryTextColor,
                size: size.width * 0.085,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          SizedBox(
            height: size.height * 0.02,
          ),
          Container(
            width: size.width * 0.9,
            margin: EdgeInsets.only(bottom: size.height * 0.02),
            padding: EdgeInsets.all(size.width * 0.01),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color(0xFFF0F0F0),
            ),
            child: SwitchListTile(
              tileColor: Color(0xFFF0F0F0),
              activeColor: kPrimaryColor,
              value: bookingNotifs,
              title: Text(
                'Booking',
                style: TextStyle(
                    color: kPrimaryTextColor, fontSize: size.width * 0.06),
              ),
              onChanged: (value) async {
                this.setState(() {
                  bookingNotifs = value;
                });
                await DatabaseService(uid: widget.userData.uid)
                    .updateNotificationsSettings('bookingNotifs', value);
              },
            ),
          ),
          Container(
            width: size.width * 0.9,
            margin: EdgeInsets.only(bottom: size.height * 0.02),
            padding: EdgeInsets.all(size.width * 0.01),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color(0xFFF0F0F0),
            ),
            child: SwitchListTile(
              tileColor: Color(0xFFF0F0F0),
              activeColor: kPrimaryColor,
              value: cancellingNotifs,
              title: Text(
                'Cancelling',
                style: TextStyle(
                    color: kPrimaryTextColor, fontSize: size.width * 0.06),
              ),
              onChanged: (value) async {
                cancellingNotifs = value;

                await DatabaseService(uid: widget.userData.uid)
                    .updateNotificationsSettings('cancellingNotifs', value);
              },
            ),
          ),
          SizedBox(
            height: size.height * 0.02,
          ),
          RoundedButton(
            press: () async {
              // await DatabaseService(uid: widget.userData.uid)
              //     .updateNotificationsSettings('cancellingNotifs', value);
              Navigator.pop(context);
            },
            text: 'CONFIRM',
          ),
          SizedBox(
            height: size.height * 0.02,
          ),
        ],
      ),
    );
  }
}
