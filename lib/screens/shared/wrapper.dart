import 'package:clinic/models/user.dart';
import 'package:clinic/screens/admin/admin_home.dart';
import 'package:clinic/screens/admin/admin_navigation.dart';
import 'package:clinic/screens/doctor/doctor_home.dart';
import 'package:clinic/screens/admin/appointments_admin.dart';
import 'package:clinic/screens/client/client_home.dart';
import 'package:clinic/screens/client/client_navigation.dart';
import 'package:clinic/screens/secretary/secretaryHome.dart';
import 'package:clinic/screens/secretary/secretary_navigation.dart';
import 'package:clinic/screens/shared/loading.dart';
import 'package:clinic/screens/shared/login.dart';
import 'package:clinic/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

bool loading = true;

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
          future: DatabaseService(uid: user.uid).getUserRole(),
          builder: (context, role) {
            if (!role.hasData) {
              return Loading();
            } else {
              if (role.data == 'secretary') {
                return SecretaryNavigation();
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
