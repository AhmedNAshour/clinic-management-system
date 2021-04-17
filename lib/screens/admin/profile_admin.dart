import 'package:clinic/components/forms/rounded_button..dart';
import 'package:clinic/models/user.dart';
import 'package:clinic/services/auth.dart';
import 'package:clinic/services/database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:smart_select/smart_select.dart';
import '../shared/constants.dart';

class ProfileAdmin extends StatefulWidget {
  static final id = 'ProfileAdmin';
  @override
  _ProfileAdminState createState() => _ProfileAdminState();
}

class _ProfileAdminState extends State<ProfileAdmin> {
  bool bookingNotifs;
  bool cancellingNotifs;
  int userLang;
  final List<S2Choice<String>> langs = [
    S2Choice<String>(value: 'en', title: 'English'),
    S2Choice<String>(value: 'ar', title: 'عربي'),
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final admin = Provider.of<UserModel>(context);
    final userData = Provider.of<UserModel>(context);
    userLang =
        langs.indexWhere((element) => element.value == userData.language);

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: size.width * 0.14,
                  backgroundImage: admin.picURL != '' && admin.picURL != null
                      ? NetworkImage(admin.picURL)
                      : AssetImage('assets/images/userPlaceholder.png'),
                ),
                SizedBox(
                  height: size.height * 0.015,
                ),
                Text(
                  admin.fName,
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
                  'Admin',
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
                          height: size.height * 0.18,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: kPrimaryLightColor,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                FontAwesomeIcons.solidBell,
                                color: kPrimaryColor,
                                size: size.width * 0.13,
                              ),
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                              Text(
                                'Notification Settings',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: size.width * 0.042,
                                  color: kPrimaryTextColor,
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
                                        height: size.height * 0.2,
                                        child: ListView.builder(
                                          itemCount: langs.length,
                                          itemBuilder: (context, index) {
                                            return Container(
                                              width: size.width * 0.9,
                                              margin: EdgeInsets.only(
                                                  bottom: size.height * 0.02),
                                              padding: EdgeInsets.all(
                                                  size.width * 0.01),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Color(0xFFF0F0F0),
                                              ),
                                              child: SwitchListTile(
                                                tileColor: Color(0xFFF0F0F0),
                                                activeColor: kPrimaryColor,
                                                value: userLang == index
                                                    ? true
                                                    : false,
                                                title: Text(
                                                  langs[index].title,
                                                  style: TextStyle(
                                                      color: kPrimaryTextColor,
                                                      fontSize:
                                                          size.width * 0.06),
                                                ),
                                                onChanged: (value) async {
                                                  insideState(() {
                                                    if (value == true) {
                                                      userLang = index;
                                                    }
                                                  });
                                                },
                                              ),
                                            );
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
                                              .updateUserLang(
                                                  langs[userLang].value);
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
                          height: size.height * 0.18,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: kPrimaryLightColor,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                FontAwesomeIcons.globe,
                                color: kPrimaryColor,
                                size: size.width * 0.13,
                              ),
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                              Text(
                                'Language',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: size.width * 0.042,
                                  color: kPrimaryTextColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () async {
                    // Navigator.pushNamed(context, AppLanguage.id);
                    await AuthService().signOut();
                  },
                  child: Container(
                    padding: EdgeInsets.all(size.width * 0.03),
                    margin: EdgeInsets.symmetric(vertical: size.height * 0.02),
                    width: size.width * 0.9,
                    height: size.height * 0.15,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: kPrimaryLightColor,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          FontAwesomeIcons.signOutAlt,
                          color: kPrimaryColor,
                          size: size.width * 0.13,
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        Text(
                          'Sign out',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: size.width * 0.042,
                            color: kPrimaryTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
