import 'package:auto_size_text/auto_size_text.dart';
import 'package:clinic/models/doctor.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:flutter/material.dart';

class DoctorCardSec extends StatelessWidget {
  const DoctorCardSec({
    Key key,
    @required this.doctor,
  }) : super(key: key);

  final Doctor doctor;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(bottom: 10),
        width: size.width * 0.8,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(11), color: Colors.white),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage:
                  AssetImage('assets/images/doctorPortraitCenter.jpg'),
              radius: (80 / 100 * size.width) * 0.1,
            ),
            SizedBox(
              width: size.width * 0.04,
            ),
            Expanded(
              flex: 2,
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctor.fName + ' ' + doctor.lName,
                      style: TextStyle(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    Text(
                      doctor.proffesion,
                      style: TextStyle(
                          color: kPrimaryLightColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/doctorScheduleScreen',
                      arguments: {
                        'docId': doctor.uid,
                        'fName': doctor.fName,
                        'lName': doctor.lName,
                        'profession': doctor.proffesion,
                      });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  margin: EdgeInsets.only(left: 10),
                  child: Center(
                    child: AutoSizeText(
                      'EDIT',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                      minFontSize: 15,
                      maxLines: 1,
                    ),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: kPrimaryLightColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
