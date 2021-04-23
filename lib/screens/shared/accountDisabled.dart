import 'package:clinic/components/forms/rounded_button..dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:clinic/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AccountDisabled extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: size.height * 0.02,
              ),
              Lottie.asset(
                'assets/animations/canceled.json',
                width: size.width * 0.8,
              ),
              Text(
                'Sorry, Your account has been disabled.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: size.width * 0.08, color: kPrimaryColor),
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              RoundedButton(
                press: () async {
                  await AuthService().signOut();
                },
                text: 'SIGN OUT',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
