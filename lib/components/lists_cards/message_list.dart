import 'package:clinic/models/message.dart';
import 'package:clinic/models/user.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MessageList extends StatefulWidget {
  @override
  _MessageListState createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  @override
  Widget build(BuildContext context) {
    final messages = Provider.of<List<MessageModel>>(context) ?? [];
    final user = Provider.of<MyUser>(context);
    Size size = MediaQuery.of(context).size;
    double screenHeight = size.height;
    double screenWidth = size.width;

    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index) {
        return Align(
          alignment: messages[index].sender == user.uid
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: Container(
            margin: EdgeInsets.all(screenWidth * 0.02),
            width: screenWidth * 0.5,
            padding: EdgeInsets.all(screenWidth * 0.03),
            decoration: BoxDecoration(
              border: messages[index].sender != user.uid
                  ? Border.all(
                      color: kPrimaryLightColor,
                    )
                  : null,
              color: messages[index].sender == user.uid
                  ? kPrimaryColor
                  : Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    messages[index].body,
                    style: TextStyle(
                      fontSize: screenWidth * 0.035,
                      color: messages[index].sender == user.uid
                          ? Colors.white
                          : kPrimaryTextColor,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '${DateFormat("MMM").format(messages[index].time)} ${DateFormat("d").format(messages[index].time)} - ${DateFormat("jm").format(messages[index].time)}',
                    style: TextStyle(
                      fontSize: screenWidth * 0.025,
                      color: kPrimaryLightColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
