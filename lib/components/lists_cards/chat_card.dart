import 'package:clinic/models/chat.dart';
import 'package:clinic/models/user.dart';
import 'package:clinic/models/message.dart';
import 'package:clinic/screens/shared/chat_room.dart';

import 'package:clinic/screens/shared/constants.dart';
import 'package:clinic/services/database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatCard extends StatefulWidget {
  ChatCard({
    Key key,
    this.chat,
    this.otherUser,
  }) : super(key: key);

  final ChatModel chat;
  final UserModel otherUser;
  @override
  _ChatCardState createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double screenHeight = size.height;
    double screenWidth = size.width;
    return FutureBuilder(
      future: DatabaseService().getMessage(widget.chat.docID),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          MessageModel lastMessage = snapshot.data;
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, ChatRoom.id, arguments: {
                'otherUser': widget.otherUser,
              });
            },
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Container(
                // height: screenHeight * 0.18,
                width: screenWidth * 0.9,
                // margin: EdgeInsets.only(bottom: 15),
                padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.02,
                    vertical: screenHeight * 0.02),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: screenWidth * 0.10,
                      backgroundImage: widget.otherUser.picURL != ''
                          ? NetworkImage(widget.otherUser.picURL)
                          : AssetImage('assets/images/userPlaceholder.png'),
                    ),
                    SizedBox(
                      width: screenWidth * 0.02,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    color: kPrimaryTextColor,
                                    fontSize: screenWidth * 0.05,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: widget.otherUser.role == 'doctor'
                                          ? 'Dr. ${widget.otherUser.fName}'
                                          : widget.otherUser.fName,
                                    ),
                                    TextSpan(
                                      text: ' ${widget.otherUser.role}',
                                      style: TextStyle(
                                        color: kPrimaryLightColor,
                                        fontSize: screenHeight * 0.02,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Text(
                                '${DateFormat("MMM").format(lastMessage.time)} ${DateFormat("d").format(lastMessage.time)} - ${DateFormat("jm").format(lastMessage.time)}',
                                style: TextStyle(
                                  color: kPrimaryLightColor,
                                  fontSize: screenWidth * 0.035,
                                ),
                              ),
                            ],
                          ),
                          lastMessage.type == 0
                              ? Text(
                                  lastMessage.body,
                                  style: TextStyle(
                                    color: kPrimaryLightColor,
                                    fontSize: screenWidth * 0.035,
                                  ),
                                )
                              : Icon(
                                  Icons.image,
                                  color: kPrimaryColor,
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
