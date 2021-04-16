import 'package:clinic/components/forms/rounded_button..dart';
import 'package:clinic/components/forms/rounded_input_field.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChangePassword extends StatefulWidget {
  static final id = 'ChangePassword';
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();
  String currentPassword = '';
  String newPassword = '';

  String newPasswordConfirm = '';
  //  Container(
  //             height: size.height * 0.1,
  //             width: double.infinity,
  //             color: kPrimaryColor,
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.start,
  //               children: [
  //                 BackButton(
  //                   color: Colors.white,
  //                 ),
  //                 SizedBox(width: size.width * 0.2),
  //                 Text(
  //                   'Change Password',
  //                   style: TextStyle(
  //                     fontSize: size.width * 0.06,
  //                     color: Colors.white,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              height: size.height * 0.1,
              width: double.infinity,
              color: kPrimaryColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  BackButton(
                    color: Colors.white,
                  ),
                  SizedBox(width: size.width * 0.2),
                  Text(
                    'Change Password',
                    style: TextStyle(
                      fontSize: size.width * 0.06,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: size.height * 0.03,
            ),
            SvgPicture.asset(
              'assets/images/change.svg',
              color: kPrimaryColor,
              width: size.width * 0.3,
              height: size.width * 0.3,
            ),
            SizedBox(
              height: size.height * 0.03,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  RoundedInputField(
                    labelText: 'Current Password',
                    obsecureText: true,
                    icon: Icons.lock,
                    hintText: 'Current Password',
                    onChanged: (val) {
                      setState(() => currentPassword = val);
                    },
                    validator: (val) => val.length < 6
                        ? ' Enter a password 6+ chars long '
                        : null,
                  ),
                  RoundedInputField(
                    labelText: 'New Password',
                    obsecureText: true,
                    icon: Icons.lock,
                    hintText: 'New Password',
                    onChanged: (val) {
                      setState(() => newPassword = val);
                    },
                    validator: (val) => val.length < 6
                        ? ' Enter a password 6+ chars long '
                        : null,
                  ),
                  RoundedInputField(
                    labelText: 'Confirm Password',
                    obsecureText: true,
                    icon: Icons.lock,
                    hintText: 'Confirm Password',
                    onChanged: (val) {
                      setState(() => currentPassword = val);
                    },
                    validator: (val) => val.length < 6
                        ? ' Enter a password 6+ chars long '
                        : null,
                  ),
                  SizedBox(
                    height: size.height * 0.05,
                  ),
                  RoundedButton(
                    text: 'Change Password',
                    press: () async {
                      if (_formKey.currentState.validate()) {}
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
