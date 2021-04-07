import 'package:clinic/models/customBottomSheets.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../models/doctor.dart';
import '../../screens/client/doctor_info_client_booking.dart';

class DoctorCardClientBooking extends StatelessWidget {
  const DoctorCardClientBooking({
    Key key,
    @required this.doctor,
  }) : super(key: key);

  final Doctor doctor;

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
            CustomBottomSheets().showCustomBottomSheet(
                size, DoctorProfileClientBooking(doctor), context);
          },
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Container(
              width: screenWidth * 0.4,
              height: screenWidth * 0.35,
              // margin: EdgeInsets.only(bottom: size.height * 0.02),
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.02,
                  vertical: screenHeight * 0.02),
              // decoration: BoxDecoration(
              //   color: Colors.white,
              //   borderRadius: BorderRadius.circular(10),
              //   // boxShadow: [
              //   //   BoxShadow(
              //   //     color: kPrimaryLightColor,
              //   //     blurRadius: 10.0,
              //   //     spreadRadius: 0.5,
              //   //     offset: Offset(0, 0), // shadow direction: bottom right
              //   //   )
              //   // ],
              // ),
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
                  SizedBox(
                    height: screenHeight * 0.01,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        FontAwesomeIcons.mapMarked,
                        color: kPrimaryTextColor,
                        size: screenWidth * 0.045,
                      ),
                      SizedBox(
                        width: screenWidth * 0.02,
                      ),
                      // Text(
                      //   '${doctor.branch}',
                      //   style: TextStyle(
                      //     color: kPrimaryTextColor,
                      //     fontSize: screenWidth * 0.045,
                      //   ),
                      // ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: -screenWidth * 0.12,
          left: screenWidth * 0.09,
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
