import 'dart:io';
import 'package:clinic/models/customBottomSheets.dart';
import 'package:clinic/models/notification.dart';
import 'package:clinic/models/user.dart';
import 'package:intl/intl.dart';
import '../../screens/doctor/client_info_doctor.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:clinic/services/database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

class NotificationCard extends StatefulWidget {
  NotificationCard({
    Key key,
    this.notification,
    this.userData,
  }) : super(key: key);

  final MyNotification notification;
  final UserData userData;

  @override
  _NotificationCardState createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  File newProfilePic;
  String note = '';
  String error = '';
  final _formKey = GlobalKey<FormState>();

  Future getImage() async {
    var tempImage = await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      newProfilePic = File(tempImage.path);
    });
  }

  uploadImage() async {
    final Reference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('profilePics/${widget.notification.doctorID}.jpg');
    UploadTask task = firebaseStorageRef.putFile(newProfilePic);
    TaskSnapshot taskSnapshot = await task;
    taskSnapshot.ref.getDownloadURL().then(
          (value) => DatabaseService(uid: widget.notification.docID)
              .updateUserProfilePicture(value.toString(), 'secretary'),
        );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double screenHeight = size.height;
    double screenWidth = size.width;
    return GestureDetector(
      onTap: () {
        CustomBottomSheets().showCustomBottomSheet(
            size, ClientProfileDoctor(widget.notification.clientID), context);
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
