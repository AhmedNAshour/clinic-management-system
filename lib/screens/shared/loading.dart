import 'package:clinic/screens/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: kPrimaryLightColor,
      child: Center(
        child: SpinKitChasingDots(
          color: kPrimaryColor,
          size: 50,
        ),
      ),
    );
  }
}
