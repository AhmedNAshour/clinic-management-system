import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:clinic/models/appointment.dart';
import 'package:clinic/models/customBottomSheets.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:clinic/screens/shared/stringManipulation.dart';
import 'package:clinic/services/database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../screens/admin/cancel_appointment.dart';

class AppointmentCard extends StatefulWidget {
  AppointmentCard({
    Key key,
    this.appointment,
  }) : super(key: key);

  final Appointment appointment;

  @override
  _AppointmentCardState createState() => _AppointmentCardState();
}

class _AppointmentCardState extends State<AppointmentCard> {
  File newProfilePic;

  Future getImage() async {
    var tempImage = await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      newProfilePic = File(tempImage.path);
    });
  }

  uploadImage() async {
    final Reference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('profilePics/${widget.appointment.doctorID}.jpg');
    UploadTask task = firebaseStorageRef.putFile(newProfilePic);
    TaskSnapshot taskSnapshot = await task;
    taskSnapshot.ref.getDownloadURL().then(
          (value) => DatabaseService(uid: widget.appointment.docID)
              .updateUserProfilePicture(value.toString()),
        );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double screenHeight = size.height;
    double screenWidth = size.width;
    return GestureDetector(
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Container(
          width: screenWidth * 0.9,
          padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.02, vertical: screenHeight * 0.02),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(left: screenWidth * 0.02),
                child: CircleAvatar(
                  radius: screenWidth * 0.11,
                  backgroundImage: widget.appointment.doctorPicURL != ''
                      ? NetworkImage(widget.appointment.doctorPicURL)
                      : AssetImage('assets/images/drPlaceholder.png'),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        bottom: -screenWidth * 0.02,
                        left: -screenWidth * 0.02,
                        child: CircleAvatar(
                          radius: screenWidth * 0.05,
                          backgroundImage: widget.appointment.clientPicURL != ''
                              ? NetworkImage(widget.appointment.clientPicURL)
                              : AssetImage('assets/images/userPlaceholder.png'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: screenWidth * 0.02,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Dr. ${widget.appointment.doctorFName}',
                      style: TextStyle(
                        color: kPrimaryTextColor,
                        fontSize: screenWidth * 0.05,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: size.height * 0.01),
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/images/patient-icon.svg',
                          color: kPrimaryTextColor,
                        ),
                        SizedBox(
                          width: screenWidth * 0.01,
                        ),
                        Text(
                          StringManipulation.limitLength(
                              '${widget.appointment.clientFName} ${widget.appointment.clientLName}',
                              25),
                          style: TextStyle(
                            color: kPrimaryTextColor,
                            fontSize: screenWidth * 0.04,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: size.height * 0.01),
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/images/time.svg',
                          color: kPrimaryTextColor,
                        ),
                        SizedBox(
                          width: screenWidth * 0.01,
                        ),
                        Text(
                          '${DateFormat("MMM").format(widget.appointment.startTime)} ${DateFormat("d").format(widget.appointment.startTime)} - ${DateFormat("jm").format(widget.appointment.startTime)}',
                          style: TextStyle(
                            color: kPrimaryTextColor,
                            fontSize: screenWidth * 0.04,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  widget.appointment.status != 'canceled'
                      ? GestureDetector(
                          onTap: () {
                            CustomBottomSheets().showDynamicCustomBottomSheet(
                                size,
                                CancelAppointment(
                                  widget.appointment,
                                ),
                                context);
                          },
                          child: Icon(
                            Icons.cancel,
                            color: Color(0xFFB5020B),
                          ),
                        )
                      : Container(),
                  widget.appointment.status != 'canceled'
                      ? SizedBox(
                          height: screenHeight * 0.02,
                        )
                      : Container(),
                  GestureDetector(
                    onTap: () {
                      launch("tel://${widget.appointment.clientPhoneNumber}");
                    },
                    child: Icon(
                      Icons.phone_android_rounded,
                      color: kPrimaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
