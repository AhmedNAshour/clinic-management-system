import 'package:clinic/models/client.dart';
import 'package:clinic/screens/manager/booking_step3.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:flutter/material.dart';
import '../../models/doctor.dart';

class DoctorCardSecBooking extends StatelessWidget {
  const DoctorCardSecBooking({
    Key key,
    @required this.doctor,
    this.client,
  }) : super(key: key);

  final Doctor doctor;
  final Client client;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double screenHeight = size.height;
    double screenWidth = size.width;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, BookingStep3.id, arguments: {
              'client': client,
              'doctor': doctor,
            });
          },
          child: Container(
            width: screenWidth * 0.4,
            height: screenWidth * 0.3,
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.02, vertical: screenHeight * 0.02),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: kPrimaryLightColor,
                  blurRadius: 10.0,
                  spreadRadius: 0.5,
                  offset: Offset(0, 0), // shadow direction: bottom right
                )
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Dr. ${doctor.fName}',
                  style: TextStyle(
                    color: kPrimaryTextColor,
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.01,
                ),
                Text(
                  doctor.proffesion,
                  style: TextStyle(
                    color: kPrimaryLightColor,
                    fontSize: screenWidth * 0.04,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: -screenWidth * 0.12,
          left: screenWidth * 0.07,
          child: CircleAvatar(
            radius: screenWidth * 0.12,
            backgroundImage: doctor.picURL != ''
                ? NetworkImage(doctor.picURL)
                : AssetImage('assets/images/drPlaceholder.png'),
          ),
        ),
      ],
    );
  }
}
