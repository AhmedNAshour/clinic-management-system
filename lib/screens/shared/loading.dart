import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      color: Colors.white,
      child: Center(
        child: Lottie.asset(
          'assets/animations/heartLoading.json',
          width: size.width * 0.6,
        ),
      ),
    );
  }
}
