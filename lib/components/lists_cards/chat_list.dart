import 'package:clinic/models/chat.dart';
import 'package:clinic/models/user.dart';
import 'package:clinic/screens/shared/loading.dart';
import 'package:clinic/screens/shared/search_results/noResults.dart';
import 'package:clinic/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'chat_card.dart';

class ChatsList extends StatefulWidget {
  @override
  _ChatsListState createState() => _ChatsListState();
}

class _ChatsListState extends State<ChatsList> {
  @override
  Widget build(BuildContext context) {
    final chats = Provider.of<List<ChatModel>>(context) ?? [];
    final currentUser = Provider.of<MyUser>(context);
    if (chats.isNotEmpty) {
      return ListView.builder(
        itemCount: chats.length,
        itemBuilder: (context, index) {
          return StreamBuilder<UserData>(
              stream: chats[index].user1ID == currentUser.uid
                  ? DatabaseService(uid: chats[index].user2ID).userData
                  : DatabaseService(uid: chats[index].user1ID).userData,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ChatCard(
                    chat: chats[index],
                    otherUser: snapshot.data,
                  );
                } else {
                  return Loading();
                }
              });
        },
      );
    } else {
      return NoResults(
        text: 'No chats',
      );
    }
  }
}
