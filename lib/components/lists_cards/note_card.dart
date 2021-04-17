import 'dart:io';
import 'package:clinic/models/note.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:flutter/material.dart';

class NoteCard extends StatefulWidget {
  NoteCard({
    Key key,
    this.note,
  }) : super(key: key);

  final Note note;

  @override
  _NoteCardState createState() => _NoteCardState();
}

class _NoteCardState extends State<NoteCard> {
  File newProfilePic;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double screenHeight = size.height;
    double screenWidth = size.width;
    return Container(
      width: screenWidth * 0.9,
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.02, vertical: screenHeight * 0.02),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: kPrimaryLightColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: screenWidth * 0.07,
            backgroundImage: widget.note.doctorPicUrl != ''
                ? NetworkImage(widget.note.doctorPicUrl)
                : AssetImage('assets/images/drPlaceholder.png'),
          ),
          SizedBox(
            width: size.width * 0.03,
          ),
          Expanded(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Dr. ${widget.note.doctorFName}',
                        style: TextStyle(
                          fontSize: size.width * 0.05,
                          color: kPrimaryTextColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.note.submissionTime,
                        style: TextStyle(
                          fontSize: size.width * 0.04,
                          color: kPrimaryLightColor,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    widget.note.body,
                    style: TextStyle(
                      fontSize: size.width * 0.04,
                      color: kPrimaryLightColor,
                    ),
                  ),
                  //TODO: Add delete note button
                  //TODO: Add edit note button
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
