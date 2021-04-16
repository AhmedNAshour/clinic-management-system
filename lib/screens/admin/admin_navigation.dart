import 'package:clinic/models/appointment.dart';
import 'package:clinic/models/branch.dart';
import 'package:clinic/models/client.dart';
import 'package:clinic/models/doctor.dart';
import 'package:clinic/screens/admin/admin_home.dart';
import 'package:clinic/screens/admin/appointments_admin.dart';
import 'package:clinic/services/database.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'chat_admin.dart';
import 'notifications_admin.dart';
import 'profile_admin.dart';

class AdminNavigation extends StatefulWidget {
  @override
  _AdminNavigationState createState() => _AdminNavigationState();
}

class _AdminNavigationState extends State<AdminNavigation> {
  int _currentIndex = 0;
  List<Widget> screens = [
    AdminHome(),
    AppointmentsAdmin(),
    ChatAdmin(),
    NotificationsAdmin(),
    ProfileAdmin(),
  ];
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return MultiProvider(
      providers: [
        StreamProvider<List<Doctor>>.value(
          value: DatabaseService().getDoctors(),
          initialData: [],
        ),
        StreamProvider<List<Appointment>>.value(
          value: DatabaseService().getAppointments(),
          initialData: [],
        ),
        StreamProvider<List<Branch>>.value(
          value: DatabaseService().getBranches(status: 1),
          initialData: [],
        ),
        StreamProvider<List<Client>>.value(
          value: DatabaseService().getClients(),
          initialData: [],
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
