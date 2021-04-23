import 'package:clinic/components/info_card.dart';
import 'package:clinic/components/lists_cards/notes_list.dart';
import 'package:clinic/langs/locale_keys.g.dart';
import 'package:clinic/models/note.dart';
import 'package:clinic/models/user.dart';
import 'package:clinic/screens/manager/doctorSchedule.dart';
import 'package:clinic/screens/shared/chat_room.dart';
import 'package:clinic/screens/shared/loading.dart';
import 'package:clinic/services/database.dart';
import 'package:flutter/material.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/doctor.dart';
import 'package:easy_localization/easy_localization.dart';

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
    final user = Provider.of<AuthUser>(context);
    Size size = MediaQuery.of(context).size;
    doctorData = ModalRoute.of(context).settings.arguments;

    return loading
        ? Loading()
        : MultiProvider(
            providers: [
              StreamProvider<UserModel>.value(
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
                            'otherUser': UserModel(
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
                  InkWell(
                    onTap: () async {
                      Navigator.pushNamed(context, DoctorSchedule.id,
                          arguments: widget.doctor);
                    },
                    child: Text(
                      LocaleKeys.editSchedule.tr(),
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  InfoCard(
                    title: LocaleKeys.doctorName.tr(),
                    body: '${widget.doctor.fName} ${widget.doctor.lName}',
                  ),
                  InfoCard(
                    title: LocaleKeys.phoneNumber.tr(),
                    body: '${widget.doctor.phoneNumber}',
                  ),
                  InfoCard(
                    title: LocaleKeys.specialty.tr(),
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
                          LocaleKeys.about.tr(),
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
                      LocaleKeys.doctorNotes.tr(),
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
