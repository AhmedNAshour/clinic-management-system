import 'package:clinic/models/user.dart';
import 'package:clinic/screens/admin/admin_navigation.dart';
import 'package:clinic/screens/doctor/doctor_home.dart';
import 'package:clinic/screens/client/client_navigation.dart';
import 'package:clinic/screens/secretary/secretary_navigation.dart';
import 'package:clinic/screens/shared/loading.dart';
import 'package:clinic/screens/shared/login.dart';
import 'package:clinic/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

bool loading = true;
final FirebaseMessaging _fcm = FirebaseMessaging();

class _WrapperState extends State<Wrapper> {
  String role = '';
  bool loading;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser>(context);

    if (user == null) {
      return Login();
    } else {
      return MultiProvider(
        providers: [
          StreamProvider<UserData>.value(
              value: DatabaseService(uid: user.uid).userData),
        ],
        child: FutureBuilder(
          future: DatabaseService(uid: user.uid).getUserRoleAndSetToken(),
          builder: (context, role) {
            if (!role.hasData) {
              return Loading();
            } else {
              if (role.data == 'secretary') {
                return FutureBuilder(
                  future: DatabaseService(uid: user.uid).getSecretaryBranch(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      print('Branch: ${snapshot.data}');
                      _fcm.subscribeToTopic(
                          'reservationIn${snapshot.data}Branch');
                      return SecretaryNavigation();
                    } else {
                      return Loading();
                    }
                  },
                );
              } else if (role.data == 'client') {
                return ClientNavigation();
              } else if (role.data == 'admin') {
                return AdminNavigation();
              } else {
                return DoctorHome();
              }
            }
          },
        ),
      );
    }
  }
}
