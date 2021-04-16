import 'package:clinic/models/user.dart';
import 'package:clinic/screens/admin/disable_user.dart';
import 'package:clinic/screens/shared/chat_room.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:clinic/screens/shared/stringManipulation.dart';
import 'package:clinic/services/database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/doctor.dart';
import '../../screens/manager/doctor_info.dart';
import '../../models/customBottomSheets.dart';
import '../../screens/admin/editDoctorAdmin.dart';

class DoctorCardAdmin extends StatelessWidget {
  const DoctorCardAdmin({
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
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Container(
              width: screenWidth * 0.9,
              // margin: EdgeInsets.only(bottom: size.height * 0.02),
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.02,
                  vertical: screenHeight * 0.02),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: screenWidth * 0.11,
                    backgroundImage: doctor.picURL != ''
                        ? NetworkImage(doctor.picURL)
                        : AssetImage('assets/images/drPlaceholder.png'),
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
                          StringManipulation.limitLength(
                              'Dr. ${doctor.fName} ${doctor.lName}', 25),
                          style: TextStyle(
                            color: kPrimaryTextColor,
                            fontSize: screenWidth * 0.045,
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
                                launch(
                                    "tel://${doctor.countryDialCode}${doctor.phoneNumber}");
                              },
                              child: Icon(
                                Icons.phone_android_rounded,
                                color: kPrimaryColor,
                              ),
                            ),
                            SizedBox(
                              width: screenWidth * 0.01,
                            ),
                            Text(
                              'Call',
                              style: TextStyle(
                                color: kPrimaryColor,
                                fontSize: screenWidth * 0.045,
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
                            IconButton(
                              icon: Icon(
                                Icons.chat_bubble_outline_rounded,
                              ),
                              color: kPrimaryColor,
                              onPressed: () {
                                Navigator.pushNamed(context, ChatRoom.id,
                                    arguments: {
                                      'otherUser': UserModel(
                                        fName: doctor.fName,
                                        lName: doctor.lName,
                                        uid: doctor.uid,
                                        picURL: doctor.picURL,
                                        role: 'doctor',
                                      ),
                                    });
                              },
                            ),
                            SizedBox(
                              width: screenWidth * 0.01,
                            ),
                            Text(
                              'Message',
                              style: TextStyle(
                                color: kPrimaryColor,
                                fontSize: screenWidth * 0.045,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          CustomBottomSheets().showCustomBottomSheet(
                            size,
                            EditDoctorAdmin(
                              doctor: doctor,
                            ),
                            context,
                          );
                        },
                        child: Icon(
                          FontAwesomeIcons.userEdit,
                          color: kPrimaryColor,
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      doctor.status == 1
                          ? GestureDetector(
                              onTap: () async {
                                CustomBottomSheets()
                                    .showDynamicCustomBottomSheet(
                                        size,
                                        DisableUser(
                                          UserModel(
                                            fName: doctor.fName,
                                            lName: doctor.lName,
                                            uid: doctor.uid,
                                            role: 'doctor',
                                          ),
                                        ),
                                        context);
                              },
                              child: Icon(
                                Icons.cancel,
                                color: Color(0xFFB5020B),
                                size: size.width * 0.075,
                              ),
                            )
                          : GestureDetector(
                              onTap: () async {
                                var result =
                                    await DatabaseService(uid: doctor.uid)
                                        .updateUserStatus('doctor', 1);
                                if (result == 0) print('DIDNT WORK');
                              },
                              child: Icon(
                                FontAwesomeIcons.checkCircle,
                                color: Colors.green,
                              ),
                            ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
