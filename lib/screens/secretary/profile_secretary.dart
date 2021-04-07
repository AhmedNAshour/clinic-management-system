import 'package:clinic/components/forms/rounded_button..dart';
import 'package:clinic/models/customBottomSheets.dart';
import 'package:clinic/models/user.dart';
import 'package:clinic/screens/admin/changeLanguage.dart';
import 'package:clinic/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/secretary.dart';
import '../shared/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'changePassword.dart';

class ProfileSecretary extends StatefulWidget {
  static final id = 'ProfileSecretary';
  @override
  _ProfileSecretaryState createState() => _ProfileSecretaryState();
}

class _ProfileSecretaryState extends State<ProfileSecretary> {
  bool bookingNotifs;
  bool cancellingNotifs;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final secretary = Provider.of<Secretary>(context);
    final userData = Provider.of<UserData>(context);
    bookingNotifs = userData.bookingNotifs;
    cancellingNotifs = userData.cancellingNotifs;

    return Scaffold(
      // backgroundColor: Color(0xFFF0F0F0),
      body: Stack(
        children: [
          Positioned(
            child: Container(
              height: size.height * 0.2,
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
                  Text(
                    'My Account',
                    style: TextStyle(
                      fontSize: size.width * 0.06,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.04,
                  ),
                  CircleAvatar(
                    radius: size.width * 0.14,
                    backgroundImage: secretary.picURL != ''
                        ? NetworkImage(secretary.picURL)
                        : AssetImage('assets/images/userPlaceholder.png'),
                  ),
                  SizedBox(
                    height: size.height * 0.015,
                  ),
                  Text(
                    secretary.fName,
                    style: TextStyle(
                      fontSize: size.width * 0.07,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.005,
                  ),
                  Text(
                    '${secretary.branch} Manager',
                    style: TextStyle(
                      fontSize: size.width * 0.05,
                      color: Colors.black,
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
                            Navigator.pushNamed(context, ChangePassword.id);
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
                                  'assets/images/change.svg',
                                  color: kPrimaryColor,
                                ),
                                SizedBox(
                                  height: size.height * 0.02,
                                ),
                                Text(
                                  'Change Password',
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
                          onTap: () {},
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
                                  'assets/images/envelope.svg',
                                  color: kPrimaryColor,
                                ),
                                SizedBox(
                                  height: size.height * 0.02,
                                ),
                                Text(
                                  'Change Email',
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
