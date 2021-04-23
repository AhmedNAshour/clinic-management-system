import 'package:clinic/components/forms/rounded_button..dart';
import 'package:clinic/models/client.dart';
import 'package:clinic/screens/manager/booking_step2.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:clinic/services/database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ndialog/ndialog.dart';

class ClientCardSecretaryBooking extends StatefulWidget {
  ClientCardSecretaryBooking({
    Key key,
    @required this.client,
  }) : super(key: key);

  final Client client;

  @override
  _ClientCardSecretaryBookingState createState() =>
      _ClientCardSecretaryBookingState();
}

class _ClientCardSecretaryBookingState
    extends State<ClientCardSecretaryBooking> {
  int sessions = 1;

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
                widget.client.numAppointments > 0
                    ? Navigator.pushNamed(context, BookingStep2.id,
                        arguments: widget.client)
                    : null;
              },
              child: Container(
                height: screenHeight * 0.12,
                width: screenWidth * 0.9,
                margin: EdgeInsets.only(
                    bottom: size.height * 0.025, top: size.height * 0.01),
                padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.02,
                    vertical: screenHeight * 0.02),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: kPrimaryLightColor,
                      blurRadius: 10.0,
                      spreadRadius: 0.5,
                      offset: Offset(0, 0), // shadow direction: bottom right
                    )
                  ],
                ),
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
                        mainAxisAlignment: MainAxisAlignment.center,
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
                        ],
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0)),
                    ),
                    builder: (context) {
                      return StatefulBuilder(builder:
                          (BuildContext context, StateSetter insideState) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                              vertical: size.height * 0.02),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                                  mainAxisAlignment: MainAxisAlignment.end,
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      insideState(() {
                                        if (sessions != 1) {
                                          sessions--;
                                        }
                                      });
                                    },
                                    child: Container(
                                      height: size.height * 0.07,
                                      width: size.width * 0.14,
                                      decoration: BoxDecoration(
                                          color: kPrimaryLightColor,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            bottomLeft: Radius.circular(10),
                                          )),
                                      child: Icon(
                                        Icons.remove,
                                        color: Colors.white,
                                      ),
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
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(10),
                                            bottomRight: Radius.circular(10),
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
                                  await DatabaseService
                                      .updateClientRemainingSessions(
                                          numAppointments: sessions +
                                              widget.client.numAppointments,
                                          documentID: widget.client.uid);
                                  Navigator.pop(context);
                                  await NDialog(
                                    dialogStyle: DialogStyle(
                                      backgroundColor: kPrimaryColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    content: Container(
                                      height: size.height * 0.5,
                                      width: size.width * 0.8,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            FontAwesomeIcons.checkCircle,
                                            color: Colors.white,
                                            size: size.height * 0.125,
                                          ),
                                          SizedBox(
                                            height: size.height * 0.05,
                                          ),
                                          Text(
                                            'Sessions Added',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: size.height * 0.04,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ).show(context);
                                },
                              ),
                            ],
                          ),
                        );
                      });
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
