import 'package:clinic/components/forms/rounded_button..dart';
import 'package:clinic/models/customBottomSheets.dart';
import 'package:clinic/models/doctor.dart';
import 'package:clinic/models/user.dart';
import 'package:clinic/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../shared/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../screens/admin/changeLanguage.dart';

class ProfileDoctor extends StatefulWidget {
  static final id = 'ProfileDoctor';
  @override
  _ProfileDoctorState createState() => _ProfileDoctorState();
}

class _ProfileDoctorState extends State<ProfileDoctor> {
  bool bookingNotifs;
  bool cancellingNotifs;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final doctor = Provider.of<Doctor>(context);
    final userData = Provider.of<UserData>(context);
    bookingNotifs = userData.bookingNotifs;
    cancellingNotifs = userData.cancellingNotifs;

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            child: Container(
              height: size.height * 0.13,
              width: size.width,
              color: kPrimaryColor,
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              left: size.width * 0.05,
              right: size.width * 0.05,
              top: size.height * 0.05,
            ),
            width: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Text(
                  //   LocaleKeys.welcome.tr(),
                  //   style: TextStyle(
                  //     fontSize: size.width * 0.06,
                  //     color: Colors.white,
                  //   ),
                  // ),

                  //TODO: Edit profile picture
                  CircleAvatar(
                    radius: size.width * 0.14,
                    backgroundImage:
                        doctor.picURL != '' && doctor.picURL != null
                            ? NetworkImage(doctor.picURL)
                            : AssetImage('assets/images/userPlaceholder.png'),
                  ),
                  SizedBox(
                    height: size.height * 0.015,
                  ),
                  Text(
                    'Dr. ${doctor.fName}',
                    style: TextStyle(
                      fontSize: size.width * 0.07,
                      color: kPrimaryTextColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.005,
                  ),
                  Text(
                    '${doctor.proffesion}',
                    style: TextStyle(
                      fontSize: size.width * 0.04,
                      color: kPrimaryColor,
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              isScrollControlled: true,
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
                                  return Padding(
                                    padding: EdgeInsets.only(
                                      right: size.width * 0.04,
                                      left: size.width * 0.04,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
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
                                        SizedBox(
                                          height: size.height * 0.02,
                                        ),
                                        Container(
                                          width: size.width * 0.9,
                                          margin: EdgeInsets.only(
                                              bottom: size.height * 0.02),
                                          padding:
                                              EdgeInsets.all(size.width * 0.01),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Color(0xFFF0F0F0),
                                          ),
                                          child: SwitchListTile(
                                            tileColor: Color(0xFFF0F0F0),
                                            activeColor: kPrimaryColor,
                                            value: bookingNotifs,
                                            title: Text(
                                              'Booking',
                                              style: TextStyle(
                                                  color: kPrimaryTextColor,
                                                  fontSize: size.width * 0.06),
                                            ),
                                            onChanged: (value) async {
                                              insideState(() {
                                                bookingNotifs = value;
                                              });
                                            },
                                          ),
                                        ),
                                        Container(
                                          width: size.width * 0.9,
                                          margin: EdgeInsets.only(
                                              bottom: size.height * 0.02),
                                          padding:
                                              EdgeInsets.all(size.width * 0.01),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Color(0xFFF0F0F0),
                                          ),
                                          child: SwitchListTile(
                                            tileColor: Color(0xFFF0F0F0),
                                            activeColor: kPrimaryColor,
                                            value: cancellingNotifs,
                                            title: Text(
                                              'Cancelling',
                                              style: TextStyle(
                                                  color: kPrimaryTextColor,
                                                  fontSize: size.width * 0.06),
                                            ),
                                            onChanged: (value) async {
                                              insideState(() {
                                                cancellingNotifs = value;
                                              });
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          height: size.height * 0.02,
                                        ),
                                        RoundedButton(
                                          press: () async {
                                            await DatabaseService(
                                                    uid: userData.uid)
                                                .updateNotificationsSettings(
                                                    'bookingNotifs',
                                                    bookingNotifs);

                                            await DatabaseService(
                                                    uid: userData.uid)
                                                .updateNotificationsSettings(
                                                    'cancellingNotifs',
                                                    cancellingNotifs);
                                            Navigator.pop(context);
                                          },
                                          text: 'CONFIRM',
                                        ),
                                        SizedBox(
                                          height: size.height * 0.02,
                                        ),
                                      ],
                                    ),
                                  );
                                  ;
                                });
                              },
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(size.width * 0.03),
                            margin: EdgeInsets.symmetric(
                                vertical: size.height * 0.02),
                            height: size.height * 0.15,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: kPrimaryLightColor,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                SvgPicture.asset(
                                  'assets/images/notificationProfile.svg',
                                  color: kPrimaryColor,
                                ),
                                SizedBox(
                                  height: size.height * 0.02,
                                ),
                                Text(
                                  'Notification Settings',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    // fontSize: size.width * 0.042,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: size.width * 0.05,
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            // Navigator.pushNamed(context, AppLanguage.id);
                            CustomBottomSheets().showDynamicCustomBottomSheet(
                                size,
                                ChangeLanguage(
                                  lang: userData.language,
                                ),
                                context);
                          },
                          child: Container(
                            padding: EdgeInsets.all(size.width * 0.03),
                            margin: EdgeInsets.symmetric(
                                vertical: size.height * 0.02),
                            height: size.height * 0.15,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: kPrimaryLightColor,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                SvgPicture.asset(
                                  'assets/images/language.svg',
                                  color: kPrimaryColor,
                                ),
                                SizedBox(
                                  height: size.height * 0.02,
                                ),
                                Text(
                                  'App Language',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    // fontSize: size.width * 0.042,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}