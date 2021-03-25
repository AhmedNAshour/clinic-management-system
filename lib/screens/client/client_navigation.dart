import 'package:clinic/models/appointment.dart';
import 'package:clinic/models/doctor.dart';
import 'package:clinic/models/user.dart';
import 'package:clinic/screens/client/appointments_client.dart';
import 'package:clinic/screens/client/client_home.dart';
import 'package:clinic/services/database.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ClientNavigation extends StatefulWidget {
  @override
  _ClientNavigationState createState() => _ClientNavigationState();
}

class _ClientNavigationState extends State<ClientNavigation> {
  int _currentIndex = 0;
  List<Widget> screens = [
    ClientHome(),
    AppointmentsClient(),
  ];
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser>(context);

    return MultiProvider(
      providers: [
        StreamProvider<List<Doctor>>.value(
          value: DatabaseService().doctors,
        ),
        StreamProvider<List<Appointment>>.value(
          value: DatabaseService(uid: user.uid).getAppointmentsForClient(),
        ),
      ],
      child: Scaffold(
        body: screens[_currentIndex],
        bottomNavigationBar: CurvedNavigationBar(
          // backgroundColor: kPrimaryLightColor,
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
