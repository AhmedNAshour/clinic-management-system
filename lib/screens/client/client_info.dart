import 'package:clinic/components/info_card.dart';
import 'package:clinic/components/lists_cards/notes_list.dart';
import 'package:clinic/langs/locale_keys.g.dart';
import 'package:clinic/models/customBottomSheets.dart';
import 'package:clinic/models/note.dart';
import 'package:clinic/models/user.dart';
import 'package:clinic/screens/manager/editClient.dart';
import 'package:clinic/screens/shared/chat_room.dart';
import 'package:clinic/screens/shared/loading.dart';
import 'package:clinic/services/database.dart';
import 'package:flutter/material.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/client.dart';
import 'package:easy_localization/easy_localization.dart';

class ClientProfile extends StatefulWidget {
  static const id = 'ClientProfile';
  Client client;
  ClientProfile(Client client) {
    this.client = client;
  }

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
    final user = Provider.of<AuthUser>(context);
    Size size = MediaQuery.of(context).size;
    clientData = ModalRoute.of(context).settings.arguments;
    if (curSessions == null) {
      curSessions = widget.client.numAppointments;
    }
    return loading
        ? Loading()
        : MultiProvider(
            providers: [
              StreamProvider<UserModel>.value(
                  value: DatabaseService(uid: user.uid).userData),
              StreamProvider<List<Note>>.value(
                  value: DatabaseService(uid: user.uid)
                      .getClientNotes(widget.client.uid)),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          launch(
                              "tel://${widget.client.countryDialCode}${widget.client.phoneNumber}");
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
                        backgroundImage: widget.client.picURL != ''
                            ? NetworkImage(
                                widget.client.picURL,
                              )
                            : AssetImage('assets/images/userPlaceholder.png'),
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
                              fName: widget.client.fName,
                              lName: widget.client.lName,
                              uid: widget.client.uid,
                              picURL: widget.client.picURL,
                              role: 'client',
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
                      CustomBottomSheets().showCustomBottomSheet(
                          size, EditClient(client: widget.client), context);
                    },
                    child: Text(
                      LocaleKeys.edit.tr(),
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  InfoCard(
                    title: LocaleKeys.clientName.tr(),
                    body: '${widget.client.fName} ${widget.client.lName}',
                  ),
                  InfoCard(
                    title: LocaleKeys.age.tr(),
                    body: '${widget.client.age}',
                  ),
                  InfoCard(
                    title: LocaleKeys.phoneNumber.tr(),
                    body: '${widget.client.phoneNumber}',
                  ),
                  InfoCard(
                    title: LocaleKeys.appointmentsRemaining.tr(),
                    body: '${widget.client.numAppointments}',
                  ),
                  InfoCard(
                    title: LocaleKeys.email.tr(),
                    body: '${widget.client.email}',
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
  }
}
