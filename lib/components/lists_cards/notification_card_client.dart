import 'dart:io';
import 'package:clinic/models/notification.dart';
import 'package:clinic/models/user.dart';
import 'package:intl/intl.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:clinic/services/database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NotificationCardClient extends StatefulWidget {
  NotificationCardClient({
    Key key,
    this.notification,
    this.userData,
  }) : super(key: key);

  final NotificationModel notification;
  final UserModel userData;

  @override
  _NotificationCardClientState createState() => _NotificationCardClientState();
}

class _NotificationCardClientState extends State<NotificationCardClient> {
  File newProfilePic;
  String note = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double screenHeight = size.height;
    double screenWidth = size.width;
    return GestureDetector(
      onTap: () {
        //TODO: Show Appointment or Client info according to role
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Container(
          // height: screenHeight * 0.18,
          width: screenWidth * 0.9,
          // margin: EdgeInsets.only(bottom: 15),
          padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.02, vertical: screenHeight * 0.02),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: screenWidth * 0.11,
                backgroundImage: widget.notification.doctorPicURL != ''
                    ? widget.userData.role == 'client'
                        ? NetworkImage(widget.notification.doctorPicURL)
                        : NetworkImage(widget.notification.clientPicURL)
                    : AssetImage('assets/images/userPlaceholder.png'),
              ),
              SizedBox(
                width: screenWidth * 0.02,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: kPrimaryTextColor,
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.bold,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text:
                                '${widget.notification.clientFName} ${widget.notification.clientLName}',
                          ),
                          // TextSpan(
                          //   text: '${widget.appointment.doctor}',
                          //   style: TextStyle(
                          //     color: kPrimaryLightColor,
                          //     fontSize: screenHeight * 0.02,
                          //     fontWeight: FontWeight.bold,
                          //   ),
                          // )
                        ],
                      ),
                    ),
                    Text(
                      widget.notification.type == 1
                          ? widget.userData.role == 'secretary'
                              ? '${widget.notification.clientFName} booked an appointment with Dr.${widget.notification.doctorFName} on ${DateFormat("MMM").format(widget.notification.startTime)} ${DateFormat("d").format(widget.notification.startTime)} at ${DateFormat("jm").format(widget.notification.startTime)} - ${widget.notification.branch}'
                              : '${widget.notification.clientFName} booked an appointment on ${DateFormat("MMM").format(widget.notification.startTime)} ${DateFormat("d").format(widget.notification.startTime)} at ${DateFormat("jm").format(widget.notification.startTime)} - ${widget.notification.branch}'
                          : widget.userData.role == 'secretary'
                              ? '${widget.notification.clientFName} cancelled his appointment with Dr.${widget.notification.doctorFName} which was on ${DateFormat("MMM").format(widget.notification.startTime)} ${DateFormat("d").format(widget.notification.startTime)} at ${DateFormat("jm").format(widget.notification.startTime)} - ${widget.notification.branch}'
                              : '${widget.notification.clientFName} cancelled his appointment which was on ${DateFormat("MMM").format(widget.notification.startTime)} ${DateFormat("d").format(widget.notification.startTime)} at ${DateFormat("jm").format(widget.notification.startTime)} - ${widget.notification.branch}',
                      style: TextStyle(
                        color: kPrimaryLightColor,
                        fontSize: screenWidth * 0.035,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                width: size.width * 0.01,
              ),
              GestureDetector(
                onTap: () async {
                  await DatabaseService(uid: widget.userData.uid)
                      .updateNotificationStatus(
                          status: 0, docID: widget.notification.docID);
                },
                child: Icon(
                  FontAwesomeIcons.checkCircle,
                  color: kPrimaryColor,
                  size: size.width * 0.08,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
