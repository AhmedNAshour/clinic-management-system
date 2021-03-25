import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants.dart';

class NoResults extends StatelessWidget {
  const NoResults({
    Key key,
    this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double screenHeight = size.height;
    double screenWidth = size.width;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/images/search-empty.svg'),
          SizedBox(
            height: screenHeight * 0.03,
          ),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: kPrimaryTextColor,
              fontSize: screenWidth * 0.065,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}
