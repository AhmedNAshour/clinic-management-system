import 'package:clinic/screens/secretary/appLanguage.dart';
import 'package:clinic/screens/secretary/notificationSettings.dart';
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
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final secretary = Provider.of<Secretary>(context);

    return Scaffold(
      backgroundColor: Color(0xFFF0F0F0),
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
                    'Heliopolis Manager',
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
                            Navigator.pushNamed(
                                context, NotificationSettings.id);
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
                            Navigator.pushNamed(context, AppLanguage.id);
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
