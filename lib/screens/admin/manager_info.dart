import 'package:clinic/components/info_card.dart';
import 'package:clinic/langs/locale_keys.g.dart';
import 'package:clinic/models/customBottomSheets.dart';
import 'package:clinic/models/manager.dart';
import 'package:clinic/models/user.dart';
import 'package:clinic/screens/shared/chat_room.dart';
import 'package:clinic/screens/shared/loading.dart';
import 'package:clinic/services/database.dart';
import 'package:flutter/material.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../admin/edit_secretary.dart';
import 'package:easy_localization/easy_localization.dart';

class ManagerProfileAdmin extends StatefulWidget {
  static const id = 'ManagerProfileAdmin';
  Manager manager;
  ManagerProfileAdmin(Manager manager) {
    this.manager = manager;
  }

  @override
  _ManagerProfileAdminState createState() => _ManagerProfileAdminState();
}

class _ManagerProfileAdminState extends State<ManagerProfileAdmin> {
  // text field state

  bool loading = false;
  Map managerData = {};
  int curSessions;
  int newSessions;
  String error = '';

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthUser>(context);
    Size size = MediaQuery.of(context).size;
    managerData = ModalRoute.of(context).settings.arguments;

    return loading
        ? Loading()
        : MultiProvider(
            providers: [
              StreamProvider<UserModel>.value(
                value: DatabaseService(uid: user.uid).userData,
                initialData: null,
              ),
            ],
            child: Padding(
              padding: EdgeInsets.only(
                right: size.width * 0.04,
                left: size.width * 0.04,
                bottom: size.height * 0.02,
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
                          launch("tel://${widget.manager.phoneNumber}");
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
                        backgroundImage: widget.manager.picURL != '' &&
                                widget.manager.picURL != null
                            ? NetworkImage(
                                widget.manager.picURL,
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
                              fName: widget.manager.fName,
                              lName: widget.manager.lName,
                              uid: widget.manager.uid,
                              picURL: widget.manager.picURL,
                              role: 'secretary',
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
                      Navigator.pop(context);
                      CustomBottomSheets().showCustomBottomSheet(
                        size,
                        EditSecretary(
                          manager: widget.manager,
                        ),
                        context,
                      );
                    },
                    child: Text(
                      LocaleKeys.editInfo.tr(),
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  InfoCard(
                    title: LocaleKeys.managerName.tr(),
                    body: '${widget.manager.fName} ${widget.manager.lName}',
                  ),
                  InfoCard(
                    title: LocaleKeys.phoneNumber.tr(),
                    body: '${widget.manager.phoneNumber}',
                  ),
                  InfoCard(
                    title: LocaleKeys.branch.tr(),
                    body: '${widget.manager.branch}',
                  ),
                ],
              ),
            ),
          );
  }
}
