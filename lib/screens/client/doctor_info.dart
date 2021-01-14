import 'package:clinic/screens/shared/constants.dart';
import 'package:flutter/material.dart';

class DoctorInfo extends StatefulWidget {
  @override
  _DoctorInfoState createState() => _DoctorInfoState();
}

class _DoctorInfoState extends State<DoctorInfo> {
  int _currentIndex = 0;
  Map doctorData = {};

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    doctorData = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: size.height * 0.4,
            child: Image.asset(
              'assets/images/doctorPortraitWide.jpg',
              fit: BoxFit.fill,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
              height: size.height * 0.7,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(53),
                    topRight: Radius.circular(53)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      height: 40,
                      width: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          Text(
                            'BACK',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Dr. ${doctorData['fName']} ${doctorData['lName']}',
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    'Dentist',
                    style: TextStyle(
                      color: kPrimaryLightColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'About doctor ${doctorData['fName']}',
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Text(
                          doctorData['about'],
                          style: TextStyle(
                            color: kPrimaryLightColor,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: Center(
                      child: Container(
                        width: size.width * 0.8,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(28),
                          child: FlatButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                '/bookingScreen',
                                arguments: {
                                  'docId': doctorData['docId'],
                                  'fName': doctorData['fName'],
                                  'lName': doctorData['lName'],
                                  'profession': doctorData['profession'],
                                },
                              );
                            },
                            child: Text(
                              'BOOK APPOINTMENT',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900),
                            ),
                            color: kPrimaryLightColor,
                            padding: EdgeInsets.symmetric(
                                vertical: 20, horizontal: 40),
                          ),
                        ),
                      ),
                    ),
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
