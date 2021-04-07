import 'package:clinic/models/user.dart';
import 'package:clinic/screens/secretary/appointments_secretary.dart';
import 'package:clinic/screens/secretary/secretaryHome.dart';
import 'package:clinic/services/database.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../models/secretary.dart';
import 'notifications_secretary.dart';
import 'profile_secretary.dart';
import 'chat_secretary.dart';

class SecretaryNavigation extends StatefulWidget {
  @override
  _SecretaryNavigationState createState() => _SecretaryNavigationState();
}

class _SecretaryNavigationState extends State<SecretaryNavigation> {
  int _currentIndex = 0;
  List<Widget> screens = [
    SecretaryHome(),
    AppointmentsSecretary(),
    Chat(),
    NotificationsSecretary(),
    ProfileSecretary(),
  ];
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final user = Provider.of<MyUser>(context);

    return MultiProvider(
      providers: [
        StreamProvider<Secretary>.value(
          value: DatabaseService(uid: user.uid).secretary,
          initialData: null,
        ),
      ],
      child: SafeArea(
        child: Scaffold(
          // backgroundColor: Color(0xFFF0F0F0),
          body: screens[_currentIndex],
          bottomNavigationBar: CurvedNavigationBar(
            backgroundColor: Colors.transparent,
            animationDuration: Duration(milliseconds: 300),
            height: 60,
            index: 0,
            items: [
              SvgPicture.asset(
                'assets/images/home.svg',
                color: kPrimaryColor,
                height: size.width * 0.07,
                width: size.width * 0.07,
              ),
              SvgPicture.asset(
                'assets/images/appointments.svg',
                color: kPrimaryColor,
                height: size.width * 0.07,
                width: size.width * 0.07,
              ),
              SvgPicture.asset(
                'assets/images/message.svg',
                color: kPrimaryColor,
                height: size.width * 0.07,
                width: size.width * 0.07,
              ),
              SvgPicture.asset(
                'assets/images/notification.svg',
                color: kPrimaryColor,
                height: size.width * 0.07,
                width: size.width * 0.07,
              ),
              SvgPicture.asset(
                'assets/images/account.svg',
                color: kPrimaryColor,
                height: size.width * 0.07,
                width: size.width * 0.07,
              ),
            ],
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
