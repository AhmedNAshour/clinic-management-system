import 'package:clinic/models/appointment.dart';
import 'package:clinic/models/branch.dart';
import 'package:clinic/models/client.dart';
import 'package:clinic/models/doctor.dart';
import 'package:clinic/screens/admin/admin_home.dart';
import 'package:clinic/screens/admin/appointments_admin.dart';
import 'package:clinic/services/auth.dart';
import 'package:clinic/services/database.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class AdminNavigation extends StatefulWidget {
  @override
  _AdminNavigationState createState() => _AdminNavigationState();
}

class _AdminNavigationState extends State<AdminNavigation> {
  int _currentIndex = 0;
  List<Widget> screens = [
    AdminHome(),
    AppointmentsAdmin(),
  ];
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final AuthService _auth = AuthService();
    return MultiProvider(
      providers: [
        StreamProvider<List<Doctor>>.value(
          value: DatabaseService().doctors,
        ),
        StreamProvider<List<Appointment>>.value(
          value: DatabaseService().appointments,
        ),
        StreamProvider<List<Branch>>.value(
          value: DatabaseService().branches,
        ),
        StreamProvider<List<Client>>.value(
          value: DatabaseService().clients,
        ),
      ],
      child: Scaffold(
        body: screens[_currentIndex],
        bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: kPrimaryLightColor,
          animationDuration: Duration(milliseconds: 300),
          height: 60,
          index: 0,
          items: [
            FaIcon(
              FontAwesomeIcons.home,
              size: 30,
              color: kPrimaryColor,
            ),
            FaIcon(
              FontAwesomeIcons.calendarAlt,
              size: 30,
              color: kPrimaryColor,
            ),
          ],
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}
