import 'dart:io';
import 'package:clinic/components/forms/rounded_button..dart';
import 'package:clinic/components/forms/rounded_input_field.dart';
import 'package:clinic/models/appointment.dart';
import 'package:clinic/models/customBottomSheets.dart';
import '../../screens/doctor/client_info_doctor.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:clinic/services/database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AppointmentCardDoctor extends StatefulWidget {
  AppointmentCardDoctor({
    Key key,
    this.appointment,
  }) : super(key: key);

  final Appointment appointment;

  @override
  _AppointmentCardDoctorState createState() => _AppointmentCardDoctorState();
}

class _AppointmentCardDoctorState extends State<AppointmentCardDoctor> {
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
      onTap: () {
        CustomBottomSheets().showCustomBottomSheet(
            size, ClientProfileDoctor(widget.appointment.clientID), context);
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
                  mainAxisAlignment: MainAxisAlignment.center,
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
                                '${widget.appointment.clientFName} ${widget.appointment.clientLName}',
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
                  ],
                ),
              ),
              widget.appointment.status != 'canceled'
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                                context: context,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20.0),
                                      topRight: Radius.circular(20.0)),
                                ),
                                builder: (context) {
                                  return StatefulBuilder(builder:
                                      (BuildContext context,
                                          StateSetter insideState) {
                                    return Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: size.height * 0.02),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                            padding: EdgeInsets.only(
                                                left: size.width * 0.02,
                                                right: size.width * 0.02,
                                                bottom: size.height * 0.01),
                                            decoration: BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                  width: size.height * 0.001,
                                                  color: kPrimaryLightColor,
                                                ),
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  'Add Note',
                                                  style: TextStyle(
                                                      fontSize:
                                                          size.width * 0.05,
                                                      color: kPrimaryTextColor),
                                                ),
                                                SizedBox(
                                                    width: size.width * 0.25),
                                                IconButton(
                                                  icon: Icon(
                                                    Icons.close,
                                                    color: kPrimaryTextColor,
                                                    size: size.width * 0.085,
                                                  ),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: size.height * 0.02,
                                          ),
                                          Form(
                                            key: _formKey,
                                            child: Column(
                                              children: [
                                                RoundedInputField(
                                                  labelText: 'Note',
                                                  icon: FontAwesomeIcons
                                                      .notesMedical,
                                                  obsecureText: false,
                                                  hintText: 'Note',
                                                  onChanged: (val) {
                                                    setState(() => note = val);
                                                  },
                                                  validator: (val) =>
                                                      val.isEmpty
                                                          ? 'Insert a note'
                                                          : null,
                                                ),
                                                Text(
                                                  error,
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 14),
                                                ),
                                                RoundedButton(
                                                  text: 'ADD',
                                                  press: () async {
                                                    if (_formKey.currentState
                                                        .validate()) {
                                                      await DatabaseService()
                                                          .addNote(
                                                        clientID: widget
                                                            .appointment
                                                            .clientID,
                                                        doctorID: widget
                                                            .appointment
                                                            .doctorID,
                                                        body: note,
                                                        // clientFName: widget
                                                        //     .appointment
                                                        //     .clientFName,
                                                        //   clientLName: widget
                                                        // .appointment
                                                        // .clientLName,
                                                        doctorFName: widget
                                                            .appointment
                                                            .doctorFName,
                                                        doctorLName: widget
                                                            .appointment
                                                            .doctorLName,
                                                      );
                                                    }
                                                    await DatabaseService
                                                        .updateAppointmentNote(
                                                            note: note);
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  });
                                });
                          },
                          child: Icon(
                            FontAwesomeIcons.notesMedical,
                            color: kPrimaryColor,
                            size: size.width * 0.08,
                          ),
                        ),
                      ],
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
