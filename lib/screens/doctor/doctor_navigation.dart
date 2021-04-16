import 'package:clinic/models/doctor.dart';
import 'package:clinic/models/user.dart';
import 'package:clinic/screens/doctor/doctor_home.dart';
import 'package:clinic/services/database.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'chat_doctor.dart';
import 'notifications_doctor.dart';
import 'profile_doctor.dart';

class DoctorNavigation extends StatefulWidget {
  @override
  _DoctorNavigationState createState() => _DoctorNavigationState();
}

class _DoctorNavigationState extends State<DoctorNavigation> {
  int _currentIndex = 0;
  List<Widget> screens = [
    DoctorHome(),
    ChatDoctor(),
    NotificationsDoctor(),
    ProfileDoctor(),
  ];
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthUser>(context);
    Size size = MediaQuery.maybeOf(context).size;
    return MultiProvider(
      providers: [
        StreamProvider<Doctor>.value(
          value: DatabaseService(uid: user.uid).doctor,
        ),
      ],
      child: SafeArea(
        child: Scaffold(
          body: screens[_currentIndex],
          bottomNavigationBar: CurvedNavigationBar(
            backgroundColor: Colors.transparent,
            animationDuration: Duration(milliseconds: 300),
            height: 60,
            index: 0,
            items: [
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
