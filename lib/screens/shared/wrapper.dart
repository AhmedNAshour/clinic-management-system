import 'package:clinic/models/user.dart';
import 'package:clinic/screens/admin/admin_navigation.dart';
import 'package:clinic/screens/client/client_navigation.dart';
import 'package:clinic/screens/manager/secretary_navigation.dart';
import 'package:clinic/screens/shared/awaitingApproval.dart';
import 'package:clinic/screens/shared/accountDisabled.dart';
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

class _WrapperState extends State<Wrapper> {
  String role = '';
  bool loading;
  bool isInit = true;
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthUser>(context);

    if (user == null) {
      return Login();
    } else {
      return MultiProvider(
        providers: [
          StreamProvider<UserModel>.value(
            value: DatabaseService(uid: user.uid).userData,
          ),
        ],
        child: StreamBuilder<UserModel>(
            stream: DatabaseService(uid: user.uid).userData,
            builder: (context, userData) {
              if (userData.hasData) {
                context.setLocale(Locale(userData.data.language));
                if (userData.data.status == 1) {
                  return FutureBuilder(
                    future: DatabaseService(uid: user.uid)
                        .setToken(userData.data.role),
                    builder: (context, role) {
                      if (role.connectionState != ConnectionState.done) {
                        return Loading();
                      } else {
                        if (userData.data.role == 'manager') {
                          return FutureBuilder(
                            future: DatabaseService(uid: user.uid)
                                .getManagerBranch(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                _fcm.subscribeToTopic('registrationRequests');
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
                          if (userData.data.bookingNotifs) {
                            _fcm.subscribeToTopic(
                                'reservationForClient' + user.uid);
                          }
                          if (userData.data.cancellingNotifs) {
                            _fcm.subscribeToTopic(
                                'cancelledReservationForClient' + user.uid);
                          }
                          return ClientNavigation();
                        } else if (userData.data.role == 'admin') {
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
                  if (userData.data.status == 2) {
                    _fcm.subscribeToTopic('${userData.data.uid}requestStatus');
                    return AwaitingApproval();
                  } else {
                    return AccountDisabled();
                  }
                  //TODO: Add account disabled screen.
                }
              } else {
                return Loading();
              }
            }),
      );
    }
  }
}
