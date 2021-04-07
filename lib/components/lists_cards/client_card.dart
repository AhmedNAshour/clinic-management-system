import 'package:clinic/components/forms/rounded_button..dart';
import 'package:clinic/models/client.dart';
import 'package:clinic/screens/client/client_info.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:clinic/screens/shared/stringManipulation.dart';
import 'package:clinic/services/database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/customBottomSheets.dart';
import '../../screens/secretary/editClient.dart';

class ClientCard extends StatefulWidget {
  ClientCard({
    Key key,
    @required this.client,
  }) : super(key: key);

  final Client client;

  @override
  _ClientCardState createState() => _ClientCardState();
}

class _ClientCardState extends State<ClientCard> {
  int sessions = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double screenHeight = size.height;
    double screenWidth = size.width;
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            GestureDetector(
              onTap: () {
                CustomBottomSheets().showCustomBottomSheet(
                    size, ClientProfile(widget.client), context);
              },
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Container(
                  // height: screenHeight * 0.16,
                  width: screenWidth * 0.9,
                  padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.02,
                      vertical: screenHeight * 0.02),

                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: screenWidth * 0.11,
                        backgroundImage: widget.client.picURL != ''
                            ? NetworkImage(widget.client.picURL)
                            : AssetImage('assets/images/userPlaceholder.png'),
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
                                  ? StringManipulation.limitLength(
                                      'Mr. ${widget.client.fName} ${widget.client.lName}',
                                      25)
                                  : StringManipulation.limitLength(
                                      'Mrs. ${widget.client.fName} ${widget.client.lName}',
                                      25),
                              style: TextStyle(
                                color: kPrimaryTextColor,
                                fontSize: screenWidth * 0.045,
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
                                    launch(
                                        "tel://${widget.client.phoneNumber}");
                                  },
                                  child: Icon(
                                    Icons.phone_android_rounded,
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
                                    fontSize: screenWidth * 0.045,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.02,
                                  ),
                                  width: screenWidth * 0.005,
                                  height: screenHeight * 0.02,
                                  color: kPrimaryTextColor,
                                ),
                                Icon(
                                  Icons.chat_bubble_outline_rounded,
                                  color: kPrimaryColor,
                                ),
                                SizedBox(
                                  width: screenWidth * 0.01,
                                ),
                                Text(
                                  'Message',
                                  style: TextStyle(
                                    color: kPrimaryColor,
                                    fontSize: screenWidth * 0.045,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          CustomBottomSheets().showCustomBottomSheet(
                              size, EditClient(client: widget.client), context);
                        },
                        child: Icon(
                          FontAwesomeIcons.userEdit,
                          color: kPrimaryColor,
                          size: size.width * 0.05,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -size.height * 0.02,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0)),
                    ),
                    builder: (context) {
                      return FractionallySizedBox(
                        heightFactor: 0.35,
                        child: DraggableScrollableSheet(
                            initialChildSize: 1.0,
                            maxChildSize: 1.0,
                            minChildSize: 0.25,
                            builder: (BuildContext context,
                                ScrollController scrollController) {
                              return StatefulBuilder(builder:
                                  (BuildContext context,
                                      StateSetter insideState) {
                                return GestureDetector(
                                  onTap: () {
                                    insideState(() {
                                      if (sessions != 0) {
                                        sessions--;
                                      }
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: size.height * 0.02),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.only(
                                              left: size.width * 0.02,
                                              right: size.width * 0.02,
                                              bottom: size.height * 0.01),
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                width: size.height * 0.001,
                                                color: kPrimaryLightColor,
                                              ),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                'Add Sessions',
                                                style: TextStyle(
                                                    fontSize: size.width * 0.05,
                                                    color: kPrimaryTextColor),
                                              ),
                                              SizedBox(width: size.width * 0.2),
                                              IconButton(
                                                icon: Icon(
                                                  Icons.close,
                                                  color: kPrimaryTextColor,
                                                  size: size.width * 0.085,
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: size.height * 0.04,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              height: size.height * 0.07,
                                              width: size.width * 0.14,
                                              decoration: BoxDecoration(
                                                  color: kPrimaryLightColor,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(10),
                                                    bottomLeft:
                                                        Radius.circular(10),
                                                  )),
                                              child: Icon(
                                                Icons.remove,
                                                color: Colors.white,
                                              ),
                                            ),
                                            Container(
                                              height: size.height * 0.07,
                                              width: size.width * 0.25,
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  top: BorderSide(
                                                    width: size.height * 0.001,
                                                    color: kPrimaryLightColor,
                                                  ),
                                                  bottom: BorderSide(
                                                    width: size.height * 0.001,
                                                    color: kPrimaryLightColor,
                                                  ),
                                                ),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  sessions.toString(),
                                                  style: TextStyle(
                                                    color: Color(0xFF707070),
                                                    fontSize: size.width * 0.05,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                insideState(() {
                                                  sessions++;
                                                });
                                              },
                                              child: Container(
                                                height: size.height * 0.07,
                                                width: size.width * 0.14,
                                                decoration: BoxDecoration(
                                                    color: kPrimaryColor,
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topRight:
                                                          Radius.circular(10),
                                                      bottomRight:
                                                          Radius.circular(10),
                                                    )),
                                                child: Icon(
                                                  Icons.add,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: size.height * 0.03,
                                        ),
                                        RoundedButton(
                                          text: 'ADD SESSIONS',
                                          press: () async {
                                            await DatabaseService()
                                                .updateClientRemainingSessions(
                                                    numAppointments: sessions +
                                                        widget.client
                                                            .numAppointments,
                                                    documentID:
                                                        widget.client.uid);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              });
                            }),
                      );
                    },
                    isScrollControlled: true,
                  );
                },
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.02,
                        vertical: screenHeight * 0.01),
                    height: screenHeight * 0.065,
                    width: screenWidth * 0.42,
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.add,
                          color: Colors.white,
                          size: size.width * 0.07,
                        ),
                        SizedBox(
                          width: screenWidth * 0.01,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              'ADD SESSIONS',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: screenHeight * 0.02,
                              ),
                            ),
                            Text(
                              '${widget.client.numAppointments} Sessions Remaining',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: screenHeight * 0.013,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: size.height * 0.02,
        ),
      ],
    );
  }
}
