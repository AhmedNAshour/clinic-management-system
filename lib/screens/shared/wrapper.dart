import 'package:clinic/models/user.dart';
import 'package:clinic/screens/admin/admin_navigation.dart';
import 'package:clinic/screens/client/client_navigation.dart';
import 'package:clinic/screens/secretary/secretary_navigation.dart';
import '../doctor/doctor_navigation.dart';
import 'package:clinic/screens/shared/loading.dart';
import 'package:clinic/screens/shared/login.dart';
import 'package:clinic/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:easy_localization/easy_localization.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

bool loading = true;
final FirebaseMessaging _fcm = FirebaseMessaging.instance;

class _WrapperState extends State<Wrapper> {
  String role = '';
  bool loading;
  bool isInit = true;
  @override
  void didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    if (isInit) {
      // await Provider.of<DesignElements>(context).getPrimaryColor();
      // await Provider.of<DesignElements>(context, listen: false)
      //     .getPrimaryLightColor();
      // await Provider.of<DesignElements>(context, listen: false)
      //     .getPrimaryTextColor();
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser>(context);

    if (user == null) {
      return Login();
    } else {
      return MultiProvider(
        providers: [
          StreamProvider<UserData>.value(
            value: DatabaseService(uid: user.uid).userData,
          ),
        ],
        child: StreamBuilder<UserData>(
            stream: DatabaseService(uid: user.uid).userData,
            builder: (context, userData) {
              if (userData.hasData) {
                if (userData.data.status == 1) {
                  return FutureBuilder(
                    future: DatabaseService(uid: user.uid)
                        .setToken(userData.data.role),
                    builder: (context, role) {
                      context.setLocale(Locale(userData.data.language));
                      if (role.connectionState != ConnectionState.done) {
                        return Loading();
                      } else {
                        if (userData.data.role == 'secretary') {
                          return FutureBuilder(
                            future: DatabaseService(uid: user.uid)
                                .getSecretaryBranch(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                //TODO: subbscirbe to notifications according to notification settings
                                if (userData.data.bookingNotifs) {
                                  _fcm.subscribeToTopic(
                                      'reservationIn${snapshot.data}Branch');
                                }
                                if (userData.data.cancellingNotifs) {
                                  _fcm.subscribeToTopic(
                                      'cancelledReservationIn${snapshot.data}Branch');
                                }
                                return SecretaryNavigation();
                              } else {
                                return Loading();
                              }
                            },
                          );
                        } else if (userData.data.role == 'client') {
                          //TODO: call notification function when secretary books or cancels for this client
                          //TODO: subscirbe to notifications according to notification settings
                          return ClientNavigation();
                        } else if (userData.data.role == 'admin') {
                          //TODO: subscirbe to notifications according to notification settings
                          return AdminNavigation();
                        } else {
                          if (userData.data.bookingNotifs) {
                            _fcm.subscribeToTopic(
                                'reservationBookedForDoctor${userData.data.uid}');
                          }
                          if (userData.data.cancellingNotifs) {
                            _fcm.subscribeToTopic(
                                'reservationCancelledForDoctor${userData.data.uid}');
                          }
                          return DoctorNavigation();
                        }
                      }
                    },
                  );
                } else {
                  return Loading();
                }
              } else {
                return Loading();
              }
            }),
      );
    }
  }
}
