import 'package:clinic/screens/shared/constants.dart';
import 'package:flutter/material.dart';

class ChatClient extends StatefulWidget {
  static final id = 'ChatAdmin';
  @override
  _ChatClientState createState() => _ChatClientState();
}

class _ChatClientState extends State<ChatClient> {
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
