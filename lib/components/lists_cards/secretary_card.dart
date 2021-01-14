import 'package:clinic/models/client.dart';
import 'package:clinic/models/secretary.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:flutter/material.dart';

class SecretaryCard extends StatelessWidget {
  const SecretaryCard({
    Key key,
    @required this.secretary,
  }) : super(key: key);

  final Secretary secretary;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        // Navigator.pushNamed(context, '/doctorScreen');
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${secretary.fName} ${secretary.lName}',
                  style: TextStyle(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
