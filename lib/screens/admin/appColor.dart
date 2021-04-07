import 'package:clinic/screens/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChangeAppColor extends StatefulWidget {
  static final id = 'ChangeAppColor';
  @override
  _ChangeAppColorState createState() => _ChangeAppColorState();
}

class _ChangeAppColorState extends State<ChangeAppColor> {
  String currentPassword = '';
  String newPassword = '';
  String newPasswordConfirm = '';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Color kPrimaryColor =
        Provider.of<DesignElements>(context, listen: false).primaryColor;
    Color kPrimaryLightColor =
        Provider.of<DesignElements>(context, listen: false).primaryLightColor;
    Color kPrimaryTextColor =
        Provider.of<DesignElements>(context, listen: false).primaryTextColor;

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
                  SizedBox(width: size.width * 0.25),
                  Text(
                    'App Colors',
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
          ],
        ),
      ),
    );
  }
}
