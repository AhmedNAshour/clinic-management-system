import 'package:clinic/screens/shared/constants.dart';
import 'package:flutter/material.dart';

class ChatDoctor extends StatefulWidget {
  static final id = 'ChatDoctor';
  @override
  _ChatDoctorState createState() => _ChatDoctorState();
}

class _ChatDoctorState extends State<ChatDoctor> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          // padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
          height: size.height * 0.1,
          width: double.infinity,
          color: kPrimaryColor,
          child: Center(
            child: Text(
              'Chat',
              style: TextStyle(
                fontSize: size.width * 0.06,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
