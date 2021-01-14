import 'package:clinic/screens/shared/constants.dart';
import 'package:flutter/material.dart';

class TimeSlot extends StatelessWidget {
  const TimeSlot({
    Key key,
    @required this.time,
  }) : super(key: key);

  final String time;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        margin: EdgeInsets.only(left: 10),
        child: Center(
          child: Text(
            time,
            style: TextStyle(
                color: kPrimaryColor,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18), color: Colors.white),
      ),
    );
  }
}
