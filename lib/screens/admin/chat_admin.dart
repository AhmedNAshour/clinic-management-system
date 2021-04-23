import 'package:clinic/langs/locale_keys.g.dart';
import 'package:clinic/models/chat.dart';
import 'package:clinic/models/user.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:clinic/screens/shared/loading.dart';
import 'package:clinic/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/lists_cards/chat_list.dart';
import 'package:easy_localization/easy_localization.dart';

class ChatAdmin extends StatefulWidget {
  static final id = 'ChatAdmin';
  @override
  _ChatAdminState createState() => _ChatAdminState();
}

class _ChatAdminState extends State<ChatAdmin> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final user = Provider.of<AuthUser>(context);

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
                            ? DatabaseService(uid: user.uid).getChats(true)
                            : DatabaseService(uid: user.uid).getChats(false),
                        initialData: [],
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
  }
}
