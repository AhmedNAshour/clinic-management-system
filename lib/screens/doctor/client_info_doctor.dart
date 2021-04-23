import 'package:clinic/components/forms/rounded_button..dart';
import 'package:clinic/components/forms/rounded_input_field.dart';
import 'package:clinic/components/info_card.dart';
import 'package:clinic/components/lists_cards/notes_list.dart';
import 'package:clinic/langs/locale_keys.g.dart';
import 'package:clinic/models/doctor.dart';
import 'package:clinic/models/note.dart';
import 'package:clinic/models/user.dart';
import 'package:clinic/screens/shared/loading.dart';
import 'package:clinic/services/database.dart';
import 'package:flutter/material.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../models/client.dart';
import 'package:easy_localization/easy_localization.dart';

class ClientProfileDoctor extends StatefulWidget {
  static const id = 'ClientProfile';
  String clientId;
  ClientProfileDoctor(String clientId) {
    this.clientId = clientId;
  }

  @override
  _ClientProfileDoctorState createState() => _ClientProfileDoctorState();
}

class _ClientProfileDoctorState extends State<ClientProfileDoctor> {
  // text field state
  String note = '';
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

    return loading
        ? Loading()
        : StreamBuilder<Client>(
            stream: DatabaseService(uid: widget.clientId).client,
            builder: (context, snapshot) {
              Client client = snapshot.data;
              if (snapshot.hasData) {
                return StreamBuilder<Doctor>(
                    stream: DatabaseService(uid: user.uid).doctor,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        Doctor doctor = snapshot.data;
                        return MultiProvider(
                          providers: [
                            StreamProvider<UserModel>.value(
                                value: DatabaseService(uid: widget.clientId)
                                    .userData),
                            StreamProvider<List<Note>>.value(
                                value: DatabaseService()
                                    .getClientNotes(widget.clientId)),
                          ],
                          child: Padding(
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
                                  backgroundImage: client.picURL != ''
                                      ? NetworkImage(
                                          client.picURL,
                                        )
                                      : AssetImage(
                                          'assets/images/userPlaceholder.png'),
                                ),
                                SizedBox(
                                  height: size.height * 0.01,
                                ),
                                InkWell(
                                  onTap: () async {
                                    showModalBottomSheet(
                                        isScrollControlled: true,
                                        context: context,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(20.0),
                                              topRight: Radius.circular(20.0)),
                                        ),
                                        builder: (context) {
                                          return StatefulBuilder(builder:
                                              (BuildContext context,
                                                  StateSetter insideState) {
                                            return Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: size.height * 0.02),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        left: size.width * 0.02,
                                                        right:
                                                            size.width * 0.02,
                                                        bottom:
                                                            size.height * 0.01),
                                                    decoration: BoxDecoration(
                                                      border: Border(
                                                        bottom: BorderSide(
                                                          width: size.height *
                                                              0.001,
                                                          color:
                                                              kPrimaryLightColor,
                                                        ),
                                                      ),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        Text(
                                                          LocaleKeys.addNote
                                                              .tr(),
                                                          style: TextStyle(
                                                              fontSize:
                                                                  size.width *
                                                                      0.05,
                                                              color:
                                                                  kPrimaryTextColor),
                                                        ),
                                                        SizedBox(
                                                            width: size.width *
                                                                0.25),
                                                        IconButton(
                                                          icon: Icon(
                                                            Icons.close,
                                                            color:
                                                                kPrimaryTextColor,
                                                            size: size.width *
                                                                0.085,
                                                          ),
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: size.height * 0.02,
                                                  ),
                                                  Form(
                                                    key: _formKey,
                                                    child: Column(
                                                      children: [
                                                        RoundedInputField(
                                                          labelText: LocaleKeys
                                                              .note
                                                              .tr(),
                                                          icon: FontAwesomeIcons
                                                              .notesMedical,
                                                          obsecureText: false,
                                                          hintText: LocaleKeys
                                                              .note
                                                              .tr(),
                                                          onChanged: (val) {
                                                            setState(() =>
                                                                note = val);
                                                          },
                                                          validator: (val) => val
                                                                  .isEmpty
                                                              ? LocaleKeys
                                                                  .insertANote
                                                                  .tr()
                                                              : null,
                                                        ),
                                                        Text(
                                                          error,
                                                          style: TextStyle(
                                                              color: Colors.red,
                                                              fontSize: 14),
                                                        ),
                                                        RoundedButton(
                                                          text: LocaleKeys.add
                                                              .tr(),
                                                          press: () async {
                                                            if (_formKey
                                                                .currentState
                                                                .validate()) {
                                                              await DatabaseService()
                                                                  .addNote(
                                                                clientID: widget
                                                                    .clientId,
                                                                doctorID:
                                                                    user.uid,
                                                                body: note,
                                                                doctorFName:
                                                                    doctor
                                                                        .fName,
                                                                doctorLName:
                                                                    doctor
                                                                        .lName,
                                                              );
                                                            }
                                                            await DatabaseService
                                                                .updateAppointmentNote(
                                                                    note: note);
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          });
                                        });
                                  },
                                  child: Text(
                                    LocaleKeys.addNote.tr(),
                                    style: TextStyle(
                                      color: kPrimaryColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                InfoCard(
                                  title: LocaleKeys.clientName.tr(),
                                  body: '${client.fName} ${client.lName}',
                                ),
                                InfoCard(
                                  title: LocaleKeys.age.tr(),
                                  body: '${client.age}',
                                ),
                                SizedBox(
                                  height: size.height * 0.02,
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    LocaleKeys.doctorNotes.tr(),
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
                                    child: NotesList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return Loading();
                      }
                    });
              } else {
                return Loading();
              }
            });
  }
}
