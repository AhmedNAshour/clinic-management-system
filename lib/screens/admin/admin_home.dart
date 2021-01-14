import 'package:clinic/models/user.dart';
import 'package:clinic/screens/shared/loading.dart';
import 'package:clinic/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class AdminHome extends StatefulWidget {
  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final AuthService _auth = AuthService();
    final user = Provider.of<UserData>(context);

    return user != null
        ? Container(
            width: double.infinity,
            color: kPrimaryColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    padding: EdgeInsets.only(
                        top: size.height * 0.1, left: 30, right: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () async {
                                await _auth.signOut();
                              },
                              child: Text(
                                'Sign out',
                                style: TextStyle(
                                    color: kPrimaryLightColor, fontSize: 14),
                              ),
                            ),
                            Text(
                              'Hello, ${user.fName}',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 38,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                      ],
                    )),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                    decoration: BoxDecoration(
                      color: kPrimaryLightColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(53),
                          topRight: Radius.circular(53)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          height: size.height * 0.1,
                          width: double.infinity,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: FlatButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/clientsScreen');
                              },
                              color: Colors.white,
                              child: Text(
                                'Clients',
                                style: TextStyle(
                                    color: kPrimaryColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          height: size.height * 0.1,
                          width: double.infinity,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: FlatButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/doctorsScreen');
                              },
                              color: Colors.white,
                              child: Text(
                                'Doctors',
                                style: TextStyle(
                                    color: kPrimaryColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          height: size.height * 0.1,
                          width: double.infinity,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: FlatButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, '/secretariesScreen');
                              },
                              color: Colors.white,
                              child: Text(
                                'Secretaries',
                                style: TextStyle(
                                    color: kPrimaryColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          height: size.height * 0.1,
                          width: double.infinity,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: FlatButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/branchesScreen');
                              },
                              color: Colors.white,
                              child: Text(
                                'Branches',
                                style: TextStyle(
                                    color: kPrimaryColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        : Loading();
  }
}
