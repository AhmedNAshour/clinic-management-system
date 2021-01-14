import 'package:auto_size_text/auto_size_text.dart';
import 'package:clinic/models/client.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:flutter/material.dart';

class ClientCardSecretaryBooking extends StatelessWidget {
  const ClientCardSecretaryBooking({
    Key key,
    @required this.client,
  }) : super(key: key);

  final Client client;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        client.numAppointments > 0
            ? Navigator.pushNamed(context, '/bookingStep2', arguments: {
                'fName': client.fName,
                'lName': client.lName,
                'age': client.age,
                'gender': client.gender,
                'numAppointments': client.numAppointments,
                'phoneNumber': client.phoneNumber,
                'uid': client.uid,
              })
            : null;
      },
      child: Container(
        padding: EdgeInsets.all(25),
        margin: EdgeInsets.only(bottom: 10),
        width: size.width * 0.8,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30), color: Colors.white),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // CircleAvatar(
            //   backgroundImage:
            //       AssetImage('assets/images/doctorPortraitCenter.jpg'),
            //   radius: (80 / 100 * size.width) * 0.1,
            // ),
            // SizedBox(
            //   width: size.width * 0.04,
            // ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoSizeText(
                  client.gender == 'male'
                      ? 'Mr. ${client.fName} ${client.lName}'
                      : 'Mrs. ${client.fName} ${client.lName}',
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                AutoSizeText(
                  'Number: ${client.phoneNumber}',
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            AutoSizeText(
              '${client.numAppointments}',
              style: TextStyle(
                color: client.numAppointments != 0 ? kPrimaryColor : Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
