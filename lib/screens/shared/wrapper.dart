import 'package:clinic/models/user.dart';
import 'package:clinic/screens/admin/admin_navigation.dart';
import 'package:clinic/screens/client/client_navigation.dart';
import 'package:clinic/screens/manager/secretary_navigation.dart';
import 'package:clinic/screens/shared/awaitingApproval.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ndialog/ndialog.dart';
import '../doctor/doctor_navigation.dart';
import 'package:clinic/screens/shared/loading.dart';
import 'package:clinic/screens/shared/login.dart';
import 'package:clinic/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:easy_localization/easy_localization.dart';
import 'constants.dart';

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
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      Size size = MediaQuery.of(context).size;
      print("NOTIFICATION" + notification.title);
      // NDialog(
      //   dialogStyle: DialogStyle(
      //     backgroundColor: kPrimaryColor,
      //     borderRadius: BorderRadius.circular(10),
      //   ),
      //   content: Container(
      //     height: size.height * 0.5,
      //     width: size.width * 0.8,
      //     child: Column(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: [
      //         Icon(
      //           FontAwesomeIcons.solidBell,
      //           color: Colors.white,
      //           size: size.height * 0.125,
      //         ),
      //         SizedBox(
      //           height: size.height * 0.05,
      //         ),
      //         Text(
      //           notification.title,
      //           style: TextStyle(
      //             color: Colors.white,
      //             fontSize: size.height * 0.04,
      //             fontWeight: FontWeight.bold,
      //           ),
      //         ),
      //         SizedBox(
      //           height: size.height * 0.02,
      //         ),
      //         Text(
      //           notification.body,
      //           style: TextStyle(
      //             color: Colors.white,
      //             fontSize: size.height * 0.025,
      //           ),
      //           textAlign: TextAlign.center,
      //         ),
      //       ],
      //     ),
      //   ),
      // ).show(context);
    });
  }

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
                if (userData.data.status == 1) {
                  return FutureBuilder(
                    future: DatabaseService(uid: user.uid)
                        .setToken(userData.data.role),
                    builder: (context, role) {
                      context.setLocale(Locale(userData.data.language));
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
                          //TODO: call notification function when secretary books or cancels for this client
                          //TODO: subscribe to notifications according to notification settings
                          return ClientNavigation();
                        } else if (userData.data.role == 'admin') {
                          //TODO: subscribe to notifications according to notification settings
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
                  return AwaitingApproval();
                }
              } else {
                return Loading();
              }
            }),
      );
    }
  }
}
