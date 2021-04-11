import 'package:clinic/components/info_card.dart';
import 'package:clinic/components/lists_cards/notes_list.dart';
import 'package:clinic/models/appointment.dart';
import 'package:clinic/models/customBottomSheets.dart';
import 'package:clinic/models/note.dart';
import 'package:clinic/models/user.dart';
import 'package:clinic/screens/secretary/editClient.dart';
import 'package:clinic/screens/shared/loading.dart';
import 'package:clinic/services/database.dart';
import 'package:flutter/material.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AppointmentInfo extends StatefulWidget {
  static const id = 'ClientProfile';
  String appointmentID;
  AppointmentInfo(String appointmentID) {
    this.appointmentID = appointmentID;
  }

  @override
  _AppointmentInfoState createState() => _AppointmentInfoState();
}

class _AppointmentInfoState extends State<AppointmentInfo> {
  // text field state

  bool loading = false;
  Map clientData = {};
  int curSessions;
  int newSessions;
  final _formKey = GlobalKey<FormState>();
  String error = '';

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser>(context);
    Size size = MediaQuery.of(context).size;
    clientData = ModalRoute.of(context).settings.arguments;

    return loading
        ? Loading()
        : FutureBuilder(
            future: DatabaseService().getAppointment(widget.appointmentID),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                Appointment appointment = snapshot.data;
                return Padding(
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
                      CircleAvatar(
                        radius: size.width * 0.12,
                        backgroundImage: appointment.doctorPicURL != ''
                            ? NetworkImage(
                                appointment.doctorPicURL,
                              )
                            : AssetImage('assets/images/doctorPlaceholder.png'),
                      ),
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                      InfoCard(
                        title: 'Doctor name',
                        body: '${appointment.doctorFName}',
                      ),
                      InfoCard(
                        title: 'Date',
                        body:
                            '${DateFormat("MMM").format(appointment.startTime)} ${DateFormat("d").format(appointment.startTime)}',
                      ),
                      InfoCard(
                        title: 'Time',
                        body:
                            '${DateFormat("jm").format(appointment.startTime)}',
                      ),
                      InfoCard(
                        title: 'Branch',
                        body: '${appointment.branch}',
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Doctors notes',
                          style: TextStyle(
                            color: kPrimaryTextColor,
                            fontWeight: FontWeight.bold,
                            fontSize: size.width * 0.05,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          width: size.width * 0.9,
                          child: MultiProvider(
                            providers: [
                              StreamProvider<UserData>.value(
                                value: DatabaseService(uid: user.uid).userData,
                              ),
                              StreamProvider<List<Note>>.value(
                                value: DatabaseService()
                                    .getClientNotes(appointment.clientID),
                              ),
                            ],
                            child: NotesList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Loading();
              }
            });
  }
}
