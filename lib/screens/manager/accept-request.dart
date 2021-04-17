import 'package:clinic/models/user.dart';
import 'package:clinic/screens/shared/loading.dart';
import 'package:clinic/services/database.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ndialog/ndialog.dart';
import 'package:provider/provider.dart';

class AcceptRequest extends StatefulWidget {
  static const id = 'DisableUser';
  UserModel userData;
  AcceptRequest(UserModel userData) {
    this.userData = userData;
  }

  @override
  _AcceptRequestState createState() => _AcceptRequestState();
}

class _AcceptRequestState extends State<AcceptRequest> {
  // text field state

  bool loading = false;
  Map clientData = {};
  int curSessions;
  int newSessions;
  String error = '';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    clientData = ModalRoute.of(context).settings.arguments;
    HttpsCallable notifyClientAboutRequestStatus =
        FirebaseFunctions.instance.httpsCallable(
      'requestStatusTrigger',
    );
    return loading
        ? Loading()
        : Padding(
            padding: EdgeInsets.only(
              right: size.width * 0.04,
              left: size.width * 0.04,
              bottom: size.height * 0.04,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(
                      Icons.close,
                      color: kPrimaryTextColor,
                      size: size.width * 0.085,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                Text(
                  'Are you sure you want to accept ${widget.userData.fName} ${widget.userData.lName}\'s request ?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: size.width * 0.045,
                    color: kPrimaryTextColor,
                  ),
                ),
                SizedBox(
                  height: size.height * 0.04,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: size.width * 0.4,
                      decoration: BoxDecoration(
                        color: Color(0xFFDDF0FF),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'CANCEL',
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: size.height * 0.025,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: size.width * 0.4,
                      decoration: BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextButton(
                        onPressed: () async {
                          var result =
                              await DatabaseService(uid: widget.userData.uid)
                                  .updateUserStatus(widget.userData.role, 1);
                          if (result == 0) {
                            print('DIDNT WORK');
                          } else {
                            await notifyClientAboutRequestStatus
                                .call(<String, dynamic>{
                              'client': widget.userData.uid,
                              'status': 1,
                            });
                            Navigator.pop(context);
                            await NDialog(
                              dialogStyle: DialogStyle(
                                backgroundColor: kPrimaryColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              content: Container(
                                height: size.height * 0.5,
                                width: size.width * 0.8,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      FontAwesomeIcons.checkCircle,
                                      color: Colors.white,
                                      size: size.height * 0.125,
                                    ),
                                    SizedBox(
                                      height: size.height * 0.05,
                                    ),
                                    Text(
                                      'Request Accepted',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: size.height * 0.04,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ).show(context);
                          }
                        },
                        child: Text(
                          'YES',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: size.height * 0.025,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
  }
}
