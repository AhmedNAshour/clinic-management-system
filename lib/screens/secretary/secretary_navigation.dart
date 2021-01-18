import 'package:clinic/models/appointment.dart';
import 'package:clinic/models/client.dart';
import 'package:clinic/models/doctor.dart';
import 'package:clinic/models/user.dart';
import 'package:clinic/screens/secretary/appointments_secretary.dart';
import 'package:clinic/screens/secretary/booking_step1.dart';
import 'package:clinic/screens/secretary/secretaryHome.dart';
import 'package:clinic/services/auth.dart';
import 'package:clinic/services/database.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class SecretaryNavigation extends StatefulWidget {
  @override
  _SecretaryNavigationState createState() => _SecretaryNavigationState();
}

class _SecretaryNavigationState extends State<SecretaryNavigation> {
  int _currentIndex = 1;
  List<Widget> screens = [
    AppointmentsSecretary(),
    SecretaryHome(),
    BookingStep1(),
  ];
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final user = Provider.of<MyUser>(context);

    return MultiProvider(
      providers: [
        StreamProvider<List<Doctor>>.value(
          value: DatabaseService().doctors,
        ),
        StreamProvider<List<Appointment>>.value(
          value: DatabaseService().appointments,
        ),
        StreamProvider<List<Client>>.value(
          value: DatabaseService().clients,
        ),
      ],
      child: SafeArea(
        child: Scaffold(
          body: screens[_currentIndex],
          bottomNavigationBar: CurvedNavigationBar(
            backgroundColor: kPrimaryLightColor,
            animationDuration: Duration(milliseconds: 300),
            height: 60,
            index: 1,
            items: [
              FaIcon(
                FontAwesomeIcons.calendarAlt,
                size: 30,
                color: kPrimaryColor,
              ),
              FaIcon(
                FontAwesomeIcons.home,
                size: 30,
                color: kPrimaryColor,
              ),
              FaIcon(
                FontAwesomeIcons.plusCircle,
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
      ),
    );
  }
}
