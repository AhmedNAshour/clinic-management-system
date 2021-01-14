import 'package:auto_size_text/auto_size_text.dart';
import 'package:clinic/models/client.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ClientCard extends StatelessWidget {
  const ClientCard({
    Key key,
    @required this.client,
  }) : super(key: key);

  final Client client;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/clientInfoScreen', arguments: {
          'fName': client.fName,
          'lName': client.lName,
          'age': client.age,
          'gender': client.gender,
          'numAppointments': client.numAppointments,
          'phoneNumber': client.phoneNumber,
          'uid': client.uid,
        });
      },
      child: Container(
        padding: EdgeInsets.all(25),
        margin: EdgeInsets.only(bottom: 10),
        width: size.width * 0.8,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28), color: Colors.white),
        child: Row(
          children: [
            // CircleAvatar(
            //   backgroundImage:
            //       AssetImage('assets/images/doctorPortraitCenter.jpg'),
            //   radius: (80 / 100 * size.width) * 0.1,
            // ),
            // SizedBox(
            //   width: size.width * 0.04,
            // ),
            Expanded(
              flex: 3,
              child: AutoSizeText(
                client.gender == 'male'
                    ? 'Mr. ${client.fName} ${client.lName}'
                    : 'Mrs. ${client.fName} ${client.lName}',
                style: TextStyle(color: kPrimaryColor, fontSize: 20),
                minFontSize: 15,
                maxLines: 1,
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: Container(
                  child: IconButton(
                    icon: FaIcon(
                      FontAwesomeIcons.mobileAlt,
                      size: 30,
                      color: kPrimaryColor,
                    ),
                    onPressed: () {
                      launch("tel://${client.phoneNumber}");
                    },
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
