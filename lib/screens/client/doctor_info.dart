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

class DoctorProfileSec extends StatefulWidget {
  static const id = 'DoctorProfileSec';
  @override
  _DoctorProfileSecState createState() => _DoctorProfileSecState();
}

class _DoctorProfileSecState extends State<DoctorProfileSec> {
  // text field state

  bool loading = false;
  Map doctorData = {};
  int curSessions;
  int newSessions;
  final _formKey = GlobalKey<FormState>();
  String error = '';

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser>(context);
    Size size = MediaQuery.of(context).size;
    doctorData = ModalRoute.of(context).settings.arguments;
    if (curSessions == null) {
      curSessions = doctorData['numAppointments'];
    }
    return loading
        ? Loading()
        : MultiProvider(
            providers: [
              StreamProvider<UserData>.value(
                  value: DatabaseService(uid: user.uid).userData),
              StreamProvider<List<Note>>.value(
                  value: DatabaseService(uid: user.uid)
                      .getDoctorNotes(doctorData['uid'])),
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
                          backgroundImage: doctorData['picUrl'] != ''
                              ? NetworkImage(
                                  doctorData['picUrl'],
                                )
                              : AssetImage('assets/images/drPlaceholder.png'),
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
                      title: 'Doctor name',
                      body: '${doctorData['fName']} ${doctorData['lName']}',
                    ),
                    InfoCard(
                      title: 'Phone number',
                      body: '${doctorData['phoneNumber']}',
                    ),
                    InfoCard(
                      title: 'Specialty',
                      body: '${doctorData['specialty']}',
                    ),
                    Container(
                      width: size.width * 0.9,
                      margin: EdgeInsets.only(top: size.height * 0.015),
                      padding: EdgeInsets.all(size.width * 0.04),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: kPrimaryLightColor,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bio',
                            style: TextStyle(
                              color: kPrimaryTextColor,
                              fontWeight: FontWeight.bold,
                              fontSize: size.width * 0.05,
                            ),
                          ),
                          Text(
                            doctorData['bio'],
                            style: TextStyle(
                              color: kPrimaryTextColor,
                              fontSize: size.width * 0.05,
                              fontWeight: FontWeight.w100,
                            ),
                          ),
                        ],
                      ),
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
