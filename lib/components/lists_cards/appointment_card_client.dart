import 'dart:io';
import 'package:clinic/models/appointment.dart';
import 'package:clinic/models/customBottomSheets.dart';
import 'package:clinic/screens/admin/client_cancel_appointment.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:clinic/services/database.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AppointmentCardClient extends StatefulWidget {
  AppointmentCardClient({
    Key key,
    this.appointment,
  }) : super(key: key);

  final Appointment appointment;

  @override
  _AppointmentCardClientState createState() => _AppointmentCardClientState();
}

class _AppointmentCardClientState extends State<AppointmentCardClient> {
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
    HttpsCallable notifyManagersAboutCancellation =
        FirebaseFunctions.instance.httpsCallable(
      'secretaryCancellingTrigger',
    );
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: screenWidth * 0.11,
                backgroundImage: widget.appointment.doctorPicURL != ''
                    ? NetworkImage(widget.appointment.doctorPicURL)
                    : AssetImage('assets/images/drPlaceholder.png'),
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
                            text: 'Dr. ${widget.appointment.doctorFName}',
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
                    SizedBox(
                      height: screenHeight * 0.01,
                    ),
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/images/time.svg',
                          color: kPrimaryTextColor,
                        ),
                        SizedBox(
                          width: screenWidth * 0.02,
                        ),
                        Text(
                          '${DateFormat("MMM").format(widget.appointment.startTime)} ${DateFormat("d").format(widget.appointment.startTime)} - ${DateFormat("jm").format(widget.appointment.startTime)}',
                          style: TextStyle(
                            color: kPrimaryTextColor,
                            fontSize: screenWidth * 0.045,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: screenHeight * 0.01,
                    ),
                    Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.mapMarked,
                          color: kPrimaryTextColor,
                          size: screenWidth * 0.045,
                        ),
                        SizedBox(
                          width: screenWidth * 0.02,
                        ),
                        Text(
                          '${widget.appointment.branch}',
                          style: TextStyle(
                            color: kPrimaryTextColor,
                            fontSize: screenWidth * 0.045,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              widget.appointment.startTime.isAfter(DateTime.now()) &&
                      widget.appointment.status != 'canceled'
                  ? GestureDetector(
                      onTap: () {
                        CustomBottomSheets().showDynamicCustomBottomSheet(
                            size,
                            CancelAppointmentClient(
                              widget.appointment,
                            ),
                            context);
                      },
                      child: Icon(
                        Icons.cancel,
                        color: Color(0xFFB5020B),
                        size: size.width * 0.07,
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
