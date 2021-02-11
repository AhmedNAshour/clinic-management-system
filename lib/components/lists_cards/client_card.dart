import 'package:clinic/components/forms/rounded_button..dart';
import 'package:clinic/models/client.dart';
import 'package:clinic/screens/client/client_info.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:clinic/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

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
                Navigator.pushNamed(context, ClientProfile.id, arguments: {
                  'fName': widget.client.fName,
                  'lName': widget.client.lName,
                  'age': widget.client.age,
                  'gender': widget.client.gender,
                  'numAppointments': widget.client.numAppointments,
                  'phoneNumber': widget.client.phoneNumber,
                  'uid': widget.client.uid,
                  'picUrl': widget.client.picURL,
                  'email': widget.client.email,
                });
              },
              child: Container(
                height: screenHeight * 0.16,
                width: screenWidth * 0.9,
                margin: EdgeInsets.only(bottom: size.height * 0.025),
                padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.02,
                    vertical: screenHeight * 0.02),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: screenWidth * 0.02),
                      child: CircleAvatar(
                        radius: screenWidth * 0.11,
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
                                child: SvgPicture.asset(
                                  'assets/images/call.svg',
                                  height: screenHeight * 0.04,
                                  width: screenWidth * 0.04,
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
                              Container(
                                margin: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.02,
                                ),
                                width: screenWidth * 0.005,
                                height: screenHeight * 0.02,
                                color: kPrimaryTextColor,
                              ),
                              SvgPicture.asset(
                                'assets/images/chat.svg',
                                height: screenHeight * 0.04,
                                width: screenWidth * 0.04,
                              ),
                              SizedBox(
                                width: screenWidth * 0.01,
                              ),
                              Text(
                                'Message',
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
                    GestureDetector(
                      onTap: () {},
                      child: SvgPicture.asset(
                        'assets/images/edit.svg',
                        color: kPrimaryColor,
                        height: screenHeight * 0.04,
                        width: screenWidth * 0.04,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return FractionallySizedBox(
                        heightFactor: 0.3,
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
                                        Text(
                                          'Add Sessions',
                                          style: TextStyle(
                                            fontSize: size.width * 0.05,
                                            color: kPrimaryTextColor,
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
          ],
        ),
        SizedBox(
          height: size.height * 0.02,
        ),
      ],
    );
  }
}
