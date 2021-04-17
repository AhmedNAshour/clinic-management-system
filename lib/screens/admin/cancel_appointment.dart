import 'package:clinic/models/appointment.dart';
import 'package:clinic/models/user.dart';
import 'package:clinic/screens/shared/loading.dart';
import 'package:clinic/services/database.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ndialog/ndialog.dart';
import 'package:provider/provider.dart';

class CancelAppointment extends StatefulWidget {
  static const id = 'DisableUser';
  Appointment appointment;
  CancelAppointment(Appointment appointment) {
    this.appointment = appointment;
  }

  @override
  _CancelAppointmentState createState() => _CancelAppointmentState();
}

class _CancelAppointmentState extends State<CancelAppointment> {
  // text field state

  bool loading = false;
  Map clientData = {};
  int curSessions;
  int newSessions;
  final _formKey = GlobalKey<FormState>();
  String error = '';

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthUser>(context);
    Size size = MediaQuery.of(context).size;
    clientData = ModalRoute.of(context).settings.arguments;
    HttpsCallable notifyClientAboutCancellation =
        FirebaseFunctions.instance.httpsCallable(
      'clientCancellingTrigger',
    );
    return loading
        ? Loading()
        : Padding(
            padding: EdgeInsets.only(
              right: size.width * 0.04,
              left: size.width * 0.04,
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
                  'Are you sure you want to cancel this appointment ?',
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
                          int old = await DatabaseService()
                              .getSpecificClientRemainingSessions(
                                  widget.appointment.clientID);
                          await DatabaseService.updateClientRemainingSessions(
                              numAppointments: old + 1,
                              documentID: widget.appointment.clientID);
                          await DatabaseService().updateAppointmentStatus(
                              id: widget.appointment.docID, status: 'canceled');

                          await DatabaseService().addAppointmentNotifications(
                            forClient: true,
                            appointment: widget.appointment,
                            status: 1,
                            type: 0,
                          );

                          await notifyClientAboutCancellation
                              .call(<String, dynamic>{
                            'client': widget.appointment.clientID,
                            'doctor': widget.appointment.doctorFName +
                                ' ' +
                                widget.appointment.doctorLName,
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
                                    'Appointment Cancelled',
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
                SizedBox(
                  height: size.height * 0.02,
                ),
              ],
            ),
          );
  }
}
