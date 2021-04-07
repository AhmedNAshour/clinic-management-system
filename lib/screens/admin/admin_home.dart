import 'package:clinic/models/appointment.dart';
import 'package:clinic/models/user.dart';
import 'package:clinic/screens/admin/branches.dart';
import 'package:clinic/screens/shared/loading.dart';
import 'package:clinic/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'clientsAdmin.dart';
import 'doctorsAdmin.dart';
import 'managersAdmin.dart';
import '../shared/constants.dart';

class AdminHome extends StatefulWidget {
  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  List<Appointment> todaysAppointments;
  List<Appointment> pastAppointments;
  List<Appointment> upcomingAppointments;
  List<Appointment> cancelledAppointments;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData>(context);
    Size size = MediaQuery.of(context).size;
    double screenHeight = size.height;
    double screenWidth = size.width;
    List<Appointment> appointments =
        Provider.of<List<Appointment>>(context) ?? [];
    todaysAppointments = appointments
        .where((element) =>
            element.day == DateFormat("yyyy-MM-dd").format(DateTime.now()))
        .toList();
    pastAppointments = appointments
        .where((element) => element.startTime.isBefore(DateTime.now()))
        .toList();
    upcomingAppointments = appointments
        .where((element) => element.startTime.isAfter(DateTime.now()))
        .toList();
    cancelledAppointments =
        appointments.where((element) => element.status == 'canceled').toList();

    return user != null
        ? Scaffold(
            body: Stack(
              children: [
                Positioned(
                  child: Container(
                    height: screenHeight * 0.3,
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50),
                        bottomRight: Radius.circular(50),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.02,
                      vertical: screenHeight * 0.04),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(screenWidth * 0.02),
                            child: CircleAvatar(
                              radius: screenWidth * 0.10,
                              backgroundImage:
                                  user.picURL != '' && user.picURL != null
                                      ? NetworkImage(user.picURL)
                                      : AssetImage(
                                          'assets/images/userPlaceholder.png'),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(screenWidth * 0.02),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Welcome ${user.fName}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: screenWidth * 0.07,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Admin',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: screenWidth * 0.05,
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    await AuthService().signOut();
                                  },
                                  child: Text(
                                    'Sign out',
                                    style: TextStyle(
                                        color: kPrimaryLightColor,
                                        fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Container(
                        padding: EdgeInsets.all(screenWidth * 0.04),
                        height: screenHeight * 0.18,
                        width: screenWidth * 0.9,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/images/Add-Appointment.svg',
                                  color: kPrimaryColor,
                                ),
                                SizedBox(
                                  width: screenWidth * 0.04,
                                ),
                                Text(
                                  'Appointments Report',
                                  style: TextStyle(
                                    color: kPrimaryColor,
                                    fontSize: screenWidth * 0.06,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: screenHeight * 0.03),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AppointmentsReportItem(
                                  name: 'Today',
                                  count: todaysAppointments.length,
                                ),
                                AppointmentsReportItem(
                                  name: 'Previous',
                                  count: pastAppointments.length,
                                ),
                                AppointmentsReportItem(
                                  name: 'Upcoming',
                                  count: upcomingAppointments.length,
                                ),
                                AppointmentsReportItem(
                                  name: 'Cancelled',
                                  count: cancelledAppointments.length,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Expanded(
                        child: Container(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Container(
                                  width: screenWidth * 0.9,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.pushNamed(
                                                context, ClientsAdmin.id);
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(
                                                size.width * 0.03),
                                            margin: EdgeInsets.symmetric(
                                                vertical: size.height * 0.02),
                                            height: size.height * 0.15,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: kPrimaryLightColor,
                                                  blurRadius: 10.0,
                                                  spreadRadius: 0.5,
                                                  offset: Offset(0,
                                                      0), // shadow direction: bottom right
                                                )
                                              ],
                                            ),
                                            child: Column(
                                              children: [
                                                SvgPicture.asset(
                                                  'assets/images/user-defult.svg',
                                                  color: kPrimaryColor,
                                                  height: screenWidth * 0.1,
                                                ),
                                                SizedBox(
                                                  height: size.height * 0.02,
                                                ),
                                                Text(
                                                  'Clients',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: size.width * 0.05,
                                                    color: kPrimaryTextColor,
                                                    fontWeight: FontWeight.bold,
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
                                            Navigator.pushNamed(
                                                context, DoctorsAdmin.id);
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(
                                                size.width * 0.03),
                                            margin: EdgeInsets.symmetric(
                                                vertical: size.height * 0.02),
                                            height: size.height * 0.15,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: kPrimaryLightColor,
                                                  blurRadius: 10.0,
                                                  spreadRadius: 0.5,
                                                  offset: Offset(0,
                                                      0), // shadow direction: bottom right
                                                )
                                              ],
                                            ),
                                            child: Column(
                                              children: [
                                                SvgPicture.asset(
                                                  'assets/images/user-defult.svg',
                                                  color: kPrimaryColor,
                                                  height: screenWidth * 0.1,
                                                ),
                                                SizedBox(
                                                  height: size.height * 0.02,
                                                ),
                                                Text(
                                                  'Doctors',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: size.width * 0.05,
                                                    color: kPrimaryTextColor,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: screenWidth * 0.9,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.pushNamed(
                                                context, ManagersAdmin.id);
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(
                                                size.width * 0.03),
                                            margin: EdgeInsets.symmetric(
                                                vertical: size.height * 0.02),
                                            height: size.height * 0.15,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: kPrimaryLightColor,
                                                  blurRadius: 10.0,
                                                  spreadRadius: 0.5,
                                                  offset: Offset(0,
                                                      0), // shadow direction: bottom right
                                                )
                                              ],
                                            ),
                                            child: Column(
                                              children: [
                                                SvgPicture.asset(
                                                  'assets/images/user-defult.svg',
                                                  color: kPrimaryColor,
                                                  height: screenWidth * 0.1,
                                                ),
                                                SizedBox(
                                                  height: size.height * 0.02,
                                                ),
                                                Text(
                                                  'Managers',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: size.width * 0.05,
                                                    color: kPrimaryTextColor,
                                                    fontWeight: FontWeight.bold,
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
                                            Navigator.pushNamed(
                                                context, Branches.id);
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(
                                                size.width * 0.03),
                                            margin: EdgeInsets.symmetric(
                                                vertical: size.height * 0.02),
                                            height: size.height * 0.15,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: kPrimaryLightColor,
                                                  blurRadius: 10.0,
                                                  spreadRadius: 0.5,
                                                  offset: Offset(0,
                                                      0), // shadow direction: bottom right
                                                )
                                              ],
                                            ),
                                            child: Column(
                                              children: [
                                                SvgPicture.asset(
                                                  'assets/images/user-defult.svg',
                                                  color: kPrimaryColor,
                                                  height: screenWidth * 0.1,
                                                ),
                                                SizedBox(
                                                  height: size.height * 0.02,
                                                ),
                                                Text(
                                                  'Branches',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: size.width * 0.05,
                                                    color: kPrimaryTextColor,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        : Loading();
  }
}

class AppointmentsReportItem extends StatelessWidget {
  const AppointmentsReportItem({
    Key key,
    this.name,
    this.count,
  }) : super(key: key);

  final String name;
  final int count;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.maybeOf(context).size;
    double screenWidth = size.width;
    return Column(
      children: [
        Text(
          name,
          style: TextStyle(
            fontSize: screenWidth * 0.045,
            fontWeight: FontWeight.bold,
            color: kPrimaryTextColor,
          ),
        ),
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: screenWidth * 0.04,
            fontWeight: FontWeight.bold,
            color: kPrimaryLightColor,
          ),
        ),
      ],
    );
  }
}
