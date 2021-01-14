import 'package:clinic/screens/shared/constants.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    Key key,
    @required this.press,
    this.text,
    this.color = kPrimaryLightColor,
    this.textColor = Colors.white,
  }) : super(key: key);

  final Function press;
  final String text;
  final Color color, textColor;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.8,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: FlatButton(
          onPressed: press,
          child: Text(
            text,
            style: TextStyle(color: textColor, fontSize: 20),
          ),
          color: color,
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
        ),
      ),
    );
  }
}
