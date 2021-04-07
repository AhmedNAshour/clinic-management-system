import 'package:clinic/components/forms/rounded_button..dart';
import 'package:clinic/components/info_card.dart';

import 'package:clinic/models/user.dart';
import 'package:clinic/screens/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:provider/provider.dart';
import '../../models/doctor.dart';
import 'booking_step2_client.dart';

class DoctorProfileClientBooking extends StatefulWidget {
  static const id = 'DoctorProfileClientBooking';
  Doctor doctor;
  DoctorProfileClientBooking(Doctor doctor) {
    this.doctor = doctor;
  }

  @override
  _DoctorProfileClientBookingState createState() =>
      _DoctorProfileClientBookingState();
}

class _DoctorProfileClientBookingState
    extends State<DoctorProfileClientBooking> {
  // text field state

  bool loading = false;
  Map doctorData = {};
  int curSessions;
  int newSessions;
  String error = '';

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser>(context);
    Size size = MediaQuery.of(context).size;
    doctorData = ModalRoute.of(context).settings.arguments;

    return loading
        ? Loading()
        : Padding(
            padding: EdgeInsets.only(
              right: size.width * 0.04,
              left: size.width * 0.04,
            ),
            child: Column(
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: size.width * 0.12,
                      backgroundImage: widget.doctor.picURL != ''
                          ? NetworkImage(
                              widget.doctor.picURL,
                            )
                          : AssetImage('assets/images/drPlaceholder.png'),
                    ),
                  ],
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                Expanded(
                  child: Container(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          InfoCard(
                            title: 'Doctor name',
                            body:
                                '${widget.doctor.fName} ${widget.doctor.lName}',
                          ),
                          InfoCard(
                            title: 'Phone number',
                            body: '${widget.doctor.phoneNumber}',
                          ),
                          InfoCard(
                            title: 'Specialty',
                            body: '${widget.doctor.proffesion}',
                          ),
                          InfoCard(
                            title: 'Branch',
                            body: '${widget.doctor.branch}',
                          ),
                          Container(
                            width: size.width * 0.9,
                            height: size.height * 0.2,
                            margin: EdgeInsets.only(top: size.height * 0.015),
                            padding: EdgeInsets.all(size.width * 0.04),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: kPrimaryLightColor,
                              ),
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Bio',
                                    style: TextStyle(
                                      color: kPrimaryTextColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: size.width * 0.05,
                                    ),
                                  ),
                                  Text(
                                    widget.doctor.about,
                                    style: TextStyle(
                                      color: kPrimaryTextColor,
                                      fontSize: size.width * 0.05,
                                      fontWeight: FontWeight.w100,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.04,
                          ),
                          RoundedButton(
                            text: 'Confirm Doctor',
                            press: () {
                              Navigator.pushNamed(
                                  context, BookingStep2Client.id,
                                  arguments: {
                                    'doctor': widget.doctor,
                                  });
                            },
                          ),
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
