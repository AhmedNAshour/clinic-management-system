import 'package:clinic/screens/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/doctor.dart';
import '../../screens/client/doctor_info.dart';
import '../../models/customBottomSheets.dart';

class DoctorCardSec extends StatelessWidget {
  const DoctorCardSec({
    Key key,
    @required this.doctor,
  }) : super(key: key);

  final Doctor doctor;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double screenHeight = size.height;
    double screenWidth = size.width;
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            CustomBottomSheets()
                .showCustomBottomSheet(size, DoctorProfileSec(doctor), context);
          },
          child: Container(
            width: screenWidth * 0.9,
            margin: EdgeInsets.only(bottom: size.height * 0.02),
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
                    radius: screenWidth * 0.11,
                    backgroundImage: doctor.picURL != ''
                        ? NetworkImage(doctor.picURL)
                        : AssetImage('assets/images/drPlaceholder.png'),
                  ),
                ),
                SizedBox(
                  width: screenWidth * 0.02,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Dr. ${doctor.fName} ${doctor.lName}',
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
                        height: screenHeight * 0.02,
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              launch("tel://${doctor.phoneNumber}");
                            },
                            child: CircleAvatar(
                              radius: screenWidth * 0.04,
                              backgroundImage:
                                  AssetImage('assets/images/call.png'),
                            ),
                          ),
                          SizedBox(
                            width: screenWidth * 0.01,
                          ),
                          Text(
                            'Call',
                            style: TextStyle(
                              color: kPrimaryColor,
                              fontSize: screenWidth * 0.05,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.02,
                            ),
                            width: screenWidth * 0.005,
                            height: screenHeight * 0.02,
                            color: kPrimaryTextColor,
                          ),
                          SvgPicture.asset(
                            'assets/images/chat.svg',
                            height: screenHeight * 0.04,
                            width: screenWidth * 0.04,
                          ),
                          SizedBox(
                            width: screenWidth * 0.01,
                          ),
                          Text(
                            'Message',
                            style: TextStyle(
                              color: kPrimaryColor,
                              fontSize: screenWidth * 0.05,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/doctorScheduleScreen',
                        arguments: {
                          'docId': doctor.uid,
                          'fName': doctor.fName,
                          'lName': doctor.lName,
                          'profession': doctor.proffesion,
                        });
                  },
                  child: SvgPicture.asset(
                    'assets/images/edit.svg',
                    color: kPrimaryColor,
                    height: screenHeight * 0.04,
                    width: screenWidth * 0.04,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
