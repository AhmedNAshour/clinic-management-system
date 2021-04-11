import 'package:clinic/components/info_card.dart';
import 'package:clinic/components/lists_cards/notes_list.dart';
import 'package:clinic/models/customBottomSheets.dart';
import 'package:clinic/models/note.dart';
import 'package:clinic/models/user.dart';
import 'package:clinic/screens/secretary/doctorSchedule.dart';
import 'package:clinic/screens/shared/chat_room.dart';
import 'package:clinic/screens/shared/loading.dart';
import 'package:clinic/services/database.dart';
import 'package:flutter/material.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/doctor.dart';

class DoctorProfileSec extends StatefulWidget {
  static const id = 'DoctorProfileSec';
  Doctor doctor;
  DoctorProfileSec(Doctor doctor) {
    this.doctor = doctor;
  }

  @override
  _DoctorProfileSecState createState() => _DoctorProfileSecState();
}

class _DoctorProfileSecState extends State<DoctorProfileSec> {
  // text field state

  bool loading = false;
  Map doctorData = {};
  int curSessions;
  int newSessions;
  String error = '';

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser>(context);
    Size size = MediaQuery.of(context).size;
    doctorData = ModalRoute.of(context).settings.arguments;

    return loading
        ? Loading()
        : MultiProvider(
            providers: [
              StreamProvider<UserData>.value(
                  value: DatabaseService(uid: user.uid).userData),
              StreamProvider<List<Note>>.value(
                  value: DatabaseService(uid: user.uid)
                      .getDoctorNotes(widget.doctor.uid)),
            ],
            child: Padding(
              padding: EdgeInsets.only(
                right: size.width * 0.04,
                left: size.width * 0.04,
              ),
              child: Column(
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          launch("tel://${widget.doctor.phoneNumber}");
                        },
                        child: Icon(
                          Icons.phone_android_rounded,
                          color: kPrimaryColor,
                        ),
                      ),
                      SizedBox(
                        width: size.width * 0.05,
                      ),
                      CircleAvatar(
                        radius: size.width * 0.12,
                        backgroundImage: widget.doctor.picURL != ''
                            ? NetworkImage(
                                widget.doctor.picURL,
                              )
                            : AssetImage('assets/images/drPlaceholder.png'),
                      ),
                      SizedBox(
                        width: size.width * 0.05,
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.chat_bubble_outline_rounded,
                        ),
                        color: kPrimaryColor,
                        onPressed: () {
                          Navigator.pushNamed(context, ChatRoom.id, arguments: {
                            'otherUser': UserData(
                              fName: widget.doctor.fName,
                              lName: widget.doctor.lName,
                              uid: widget.doctor.uid,
                              picURL: widget.doctor.picURL,
                              role: 'doctor',
                            ),
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  // InkWell(
                  //   onTap: () async {
                  //     Navigator.pop(context);
                  //     CustomBottomSheets().showCustomBottomSheet(
                  //       size,
                  //       EditDoc(
                  //         secretary: widget.manager,
                  //       ),
                  //       context,
                  //     );
                  //   },
                  //   child: Text(
                  //     'Edit info',
                  //     style: TextStyle(
                  //       color: kPrimaryColor,
                  //       fontSize: 14,
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: size.height * 0.02,
                  // ),
                  InkWell(
                    onTap: () async {
                      Navigator.pushNamed(context, DoctorSchedule.id,
                          arguments: widget.doctor);
                    },
                    child: Text(
                      'Edit Schedule',
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  InfoCard(
                    title: 'Doctor name',
                    body: '${widget.doctor.fName} ${widget.doctor.lName}',
                  ),
                  InfoCard(
                    title: 'Phone number',
                    body: '${widget.doctor.phoneNumber}',
                  ),
                  InfoCard(
                    title: 'Specialty',
                    body: '${widget.doctor.proffesion}',
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
                          widget.doctor.about,
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
          );
  }
}
