import 'package:clinic/langs/locale_keys.g.dart';
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
import 'package:easy_localization/easy_localization.dart';

class CancelAppointmentClient extends StatefulWidget {
  static const id = 'DisableUser';
  Appointment appointment;
  CancelAppointmentClient(Appointment appointment) {
    this.appointment = appointment;
  }

  @override
  _CancelAppointmentClientState createState() =>
      _CancelAppointmentClientState();
}

class _CancelAppointmentClientState extends State<CancelAppointmentClient> {
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
    HttpsCallable notifyManagersAboutCancellation =
        FirebaseFunctions.instance.httpsCallable(
      'secretaryCancellingTrigger',
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
                  LocaleKeys.cancelAppointmentWarning.tr(),
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
                          LocaleKeys.no.tr(),
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
                              id: widget.appointment.docID, status: 0);

                          await DatabaseService().addAppointmentNotifications(
                            forClient: false,
                            appointment: widget.appointment,
                            status: 1,
                            type: 0,
                          );
                          await notifyManagersAboutCancellation
                              .call(<String, dynamic>{
                            'doctor': widget.appointment.doctorFName +
                                ' ' +
                                widget.appointment.doctorLName,
                            'client': widget.appointment.clientFName +
                                ' ' +
                                widget.appointment.clientLName,
                            'branch': widget.appointment.branch,
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
                                    LocaleKeys.appointmentCancelled.tr(),
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
