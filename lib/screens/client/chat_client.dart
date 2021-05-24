import 'package:clinic/components/lists_cards/secretary_card.dart';
import 'package:clinic/langs/locale_keys.g.dart';
import 'package:clinic/models/manager.dart';
import 'package:clinic/models/user.dart';
import 'package:clinic/models/chat.dart';
import 'package:clinic/screens/shared/chat_room.dart';
import '../../components/lists_cards/chat_list.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:clinic/screens/shared/loading.dart';
import 'package:clinic/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class ChatClient extends StatefulWidget {
  static final id = 'ChatAdmin';
  @override
  _ChatClientState createState() => _ChatClientState();
}

class _ChatClientState extends State<ChatClient> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final user = Provider.of<AuthUser>(context);
    double screenHeight = size.height;
    double screenWidth = size.width;

    return StreamBuilder<Object>(
        stream: DatabaseService().getManagers(isBoss: true),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Manager> managers = snapshot.data;
            return Column(
              children: [
                Container(
                  // padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
                  height: size.height * 0.1,
                  width: double.infinity,
                  color: kPrimaryColor,
                  child: Center(
                    child: Text(
                      LocaleKeys.chat.tr(),
                      style: TextStyle(
                        fontSize: size.width * 0.06,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
                Container(
                  width: size.width * 0.7,
                  child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                    hint: Text(
                      LocaleKeys.chatWithbranch.tr(),
                    ),
                    items: managers.map((manager) {
                      return DropdownMenuItem(
                        value: manager.uid,
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              color: kPrimaryTextColor,
                              fontSize: screenWidth * 0.05,
                              fontWeight: FontWeight.bold,
                            ),
                            children: <TextSpan>[
                              TextSpan(text: manager.fName),
                              TextSpan(text: ' '),
                              TextSpan(
                                text: manager.branch,
                                style: TextStyle(
                                  color: kPrimaryLightColor,
                                  fontSize: screenHeight * 0.02,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (val) => setState(() {
                      Manager manager =
                          managers.singleWhere((element) => element.uid == val);
                      Navigator.pushNamed(context, ChatRoom.id, arguments: {
                        'otherUser': UserModel(
                          fName: manager.fName,
                          lName: manager.lName,
                          uid: manager.uid,
                          picURL: manager.picURL,
                          role: 'manager',
                        ),
                      });
                    }),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                Expanded(
                  child: FutureBuilder(
                    future: DatabaseService(uid: user.uid).getChatsLength(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Container(
                          child: MultiProvider(
                            providers: [
                              StreamProvider<List<ChatModel>>.value(
                                value: snapshot.data > 0
                                    ? DatabaseService(uid: user.uid)
                                        .getChats(true)
                                    : DatabaseService(uid: user.uid)
                                        .getChats(false),
                              ),
                              StreamProvider<UserModel>.value(
                                value: DatabaseService(uid: user.uid).userData,
                              ),
                            ],
                            child: ChatsList(),
                          ),
                        );
                      } else {
                        return Loading();
                      }
                    },
                  ),
                ),
              ],
            );
          } else {
            return Loading();
          }
        });
  }
}
