import 'package:clinic/models/client.dart';
import 'package:clinic/models/doctor.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:flutter/material.dart';

class DoctorCardSecretaryBooking extends StatelessWidget {
  const DoctorCardSecretaryBooking({
    Key key,
    @required this.doctor,
    this.client,
  }) : super(key: key);

  final Doctor doctor;
  final Client client;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/bookingStep3', arguments: {
          'clientFName': client.fName,
          'clientLName': client.lName,
          'clientUID': client.uid,
          'clientNumAppointments': client.numAppointments,
          'clientGender': client.gender,
          'clientPhoneNumber': client.phoneNumber,
          'doctorUID': doctor.uid,
          'doctorFName': doctor.fName,
          'doctorLName': doctor.lName,
          'doctorProfession': doctor.proffesion,
          'doctorAbout': doctor.about
        });
      },
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
          ],
        ),
      ),
    );
  }
}
