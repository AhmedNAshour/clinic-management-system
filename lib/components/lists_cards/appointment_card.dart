import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:clinic/models/appointment.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:clinic/services/database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

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
              .updateUserProfilePicture(value.toString(), 'secretary'),
        );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double screenHeight = size.height;
    double screenWidth = size.width;
    return GestureDetector(
      child: Container(
        height: screenHeight * 0.18,
        width: screenWidth * 0.9,
        margin: EdgeInsets.only(bottom: 15),
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.02, vertical: screenHeight * 0.02),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: screenWidth * 0.02),
              child: CircleAvatar(
                radius: screenWidth * 0.12,
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
                        radius: screenWidth * 0.06,
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
                        '${widget.appointment.clientFName} ${widget.appointment.clientLName}',
                        style: TextStyle(
                          color: kPrimaryTextColor,
                          fontSize: screenWidth * 0.05,
                        ),
                      ),
                    ],
                  ),
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
                          fontSize: screenWidth * 0.05,
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
                GestureDetector(
                  onTap: () {
                    AwesomeDialog(
                      context: context,
                      headerAnimationLoop: false,
                      dialogType: DialogType.WARNING,
                      animType: AnimType.BOTTOMSLIDE,
                      title: "Cancel Appointment",
                      desc:
                          'Are you sure you want to cancel this appointment ?',
                      btnCancelOnPress: () {},
                      btnOkOnPress: () async {
                        print('Client id: ${widget.appointment.clientID}');
                        dynamic result;
                        int old = await DatabaseService()
                            .getSpecificClientRemainingSessions(
                                widget.appointment.clientID);
                        print('Old : $old');
                        await DatabaseService().updateClientRemainingSessions(
                            numAppointments: old + 1,
                            documentID: widget.appointment.clientID);
                        result = await DatabaseService()
                            .updateAppointmentStatus(
                                id: widget.appointment.docID,
                                status: 'canceled');

                        if (result == null) {
                          AwesomeDialog(
                              context: context,
                              headerAnimationLoop: false,
                              dialogType: DialogType.ERROR,
                              animType: AnimType.BOTTOMSLIDE,
                              body: Align(
                                alignment: Alignment.center,
                                child: Center(
                                  child: Text(
                                    'COULD NOT CANCEL APPOINTMENT..',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              onDissmissCallback: () {},
                              btnOkOnPress: () {})
                            ..show();
                        } else {
                          //Navigator.pop(context);
                          AwesomeDialog(
                              context: context,
                              headerAnimationLoop: false,
                              dialogType: DialogType.SUCCES,
                              animType: AnimType.BOTTOMSLIDE,
                              body: Center(
                                child: Text(
                                  'Appointment Cancelled Successfully',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              onDissmissCallback: () {},
                              btnOkOnPress: () {})
                            ..show();
                        }
                      },
                    )..show();
                  },
                  child: SvgPicture.asset(
                    'assets/images/cancel.svg',
                    color: Color(0xFFB5020B),
                    height: screenHeight * 0.04,
                    width: screenWidth * 0.04,
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.02,
                ),
                GestureDetector(
                  onTap: () {
                    launch("tel://${widget.appointment.clientPhoneNumber}");
                  },
                  child: CircleAvatar(
                    radius: screenWidth * 0.04,
                    backgroundImage: AssetImage('assets/images/call.png'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
