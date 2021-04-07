import 'package:clinic/models/client.dart';
import 'package:clinic/models/user.dart';
import 'package:clinic/screens/client/client_info.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:clinic/services/database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/customBottomSheets.dart';
import '../../screens/secretary/accept-request.dart';
import '../../screens/secretary/deny_request.dart';

class RequestCard extends StatefulWidget {
  RequestCard({
    Key key,
    @required this.client,
  }) : super(key: key);

  final Client client;

  @override
  _RequestCardState createState() => _RequestCardState();
}

class _RequestCardState extends State<RequestCard> {
  int sessions = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double screenHeight = size.height;
    double screenWidth = size.width;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: () {
            CustomBottomSheets().showCustomBottomSheet(
                size, ClientProfile(widget.client), context);
          },
          child: Container(
            height: screenHeight * 0.16,
            width: screenWidth * 0.9,
            margin: EdgeInsets.only(bottom: size.height * 0.025),
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.02, vertical: screenHeight * 0.02),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: screenWidth * 0.02),
                  child: CircleAvatar(
                    radius: screenWidth * 0.10,
                    backgroundImage: widget.client.picURL != ''
                        ? NetworkImage(widget.client.picURL)
                        : AssetImage('assets/images/userPlaceholder.png'),
                  ),
                ),
                SizedBox(
                  width: screenWidth * 0.02,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        widget.client.gender == 'male'
                            ? 'Mr. ${widget.client.fName} ${widget.client.lName}'
                            : 'Mrs. ${widget.client.fName} ${widget.client.lName}',
                        style: TextStyle(
                          color: kPrimaryTextColor,
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.01,
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              launch("tel://${widget.client.phoneNumber}");
                            },
                            child: Icon(
                              FontAwesomeIcons.mobileAlt,
                              color: kPrimaryColor,
                            ),
                          ),
                          SizedBox(
                            width: screenWidth * 0.01,
                          ),
                          Text(
                            'Call',
                            style: TextStyle(
                              color: kPrimaryColor,
                              fontSize: screenWidth * 0.05,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        CustomBottomSheets().showDynamicCustomBottomSheet(
                            size,
                            AcceptRequest(
                              UserData(
                                fName: widget.client.fName,
                                lName: widget.client.lName,
                                uid: widget.client.uid,
                                role: 'client',
                              ),
                            ),
                            context);
                      },
                      child: Icon(
                        FontAwesomeIcons.check,
                        color: kPrimaryColor,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        CustomBottomSheets().showDynamicCustomBottomSheet(
                            size,
                            DenyRequest(
                              UserData(
                                fName: widget.client.fName,
                                lName: widget.client.lName,
                                uid: widget.client.uid,
                                role: 'client',
                              ),
                            ),
                            context);
                      },
                      child: Icon(
                        FontAwesomeIcons.minus,
                        color: kPrimaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
