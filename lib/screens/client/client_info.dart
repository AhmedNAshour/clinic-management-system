import 'package:clinic/components/info_card.dart';
import 'package:clinic/components/lists_cards/notes_list.dart';
import 'package:clinic/models/note.dart';
import 'package:clinic/models/user.dart';
import 'package:clinic/screens/shared/loading.dart';
import 'package:clinic/services/database.dart';
import 'package:flutter/material.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class ClientProfile extends StatefulWidget {
  static const id = 'ClientProfile';
  @override
  _ClientProfileState createState() => _ClientProfileState();
}

class _ClientProfileState extends State<ClientProfile> {
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
    if (curSessions == null) {
      curSessions = clientData['numAppointments'];
    }
    return loading
        ? Loading()
        : MultiProvider(
            providers: [
              StreamProvider<UserData>.value(
                  value: DatabaseService(uid: user.uid).userData),
              StreamProvider<List<Note>>.value(
                  value: DatabaseService(uid: user.uid)
                      .getClientNotes(clientData['uid'])),
            ],
            child: Scaffold(
              backgroundColor: Colors.white,
              body: Padding(
                padding: EdgeInsets.only(
                  top: size.height * 0.04,
                  right: size.width * 0.04,
                  left: size.width * 0.04,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/images/call.svg',
                          height: size.height * 0.05,
                          width: size.width * 0.05,
                        ),
                        SizedBox(
                          width: size.width * 0.05,
                        ),
                        CircleAvatar(
                          radius: size.width * 0.12,
                          backgroundImage: clientData['picUrl'] != ''
                              ? NetworkImage(
                                  clientData['picUrl'],
                                )
                              : AssetImage('assets/images/userPlaceholder.png'),
                        ),
                        SizedBox(
                          width: size.width * 0.05,
                        ),
                        SvgPicture.asset(
                          'assets/images/chat.svg',
                          height: size.height * 0.05,
                          width: size.width * 0.05,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    InkWell(
                      onTap: () async {},
                      child: Text(
                        'Edit',
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    InfoCard(
                      title: 'Client name',
                      body: '${clientData['fName']} ${clientData['lName']}',
                    ),
                    InfoCard(
                      title: 'Age',
                      body: '${clientData['age']}',
                    ),
                    InfoCard(
                      title: 'Phone number',
                      body: '${clientData['phoneNumber']}',
                    ),
                    InfoCard(
                      title: 'Remaining sessions',
                      body: '${clientData['numAppointments']}',
                    ),
                    InfoCard(
                      title: 'Email',
                      body: '${clientData['email']}',
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
            ),
          );
  }
}
