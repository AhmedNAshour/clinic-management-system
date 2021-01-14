import 'package:clinic/components/lists_cards/appointments_list_secretary.dart';
import 'package:clinic/models/appointment.dart';
import 'package:clinic/models/user.dart';
import 'package:clinic/screens/shared/loading.dart';
import 'package:clinic/services/auth.dart';
import 'package:clinic/services/database.dart';
import 'package:flutter/material.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SecretaryHome extends StatefulWidget {
  @override
  _SecretaryHomeState createState() => _SecretaryHomeState();
}

class _SecretaryHomeState extends State<SecretaryHome> {
  String day = DateFormat("yyyy-MM-dd").format(DateTime.now());
  var textController = new TextEditingController();
  String search = '';
  bool showCancel = false;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData>(context);
    Size size = MediaQuery.of(context).size;
    final AuthService _auth = AuthService();
    return user != null
        ? StreamProvider<List<Appointment>>.value(
            value: DatabaseService().getAppointmentsForSelectedDay(day),
            child: Container(
              width: double.infinity,
              color: kPrimaryColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(
                        top: size.height * 0.1, left: 30, right: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () async {
                            await _auth.signOut();
                          },
                          child: Text(
                            'Sign out',
                            style: TextStyle(
                                color: kPrimaryLightColor, fontSize: 14),
                          ),
                        ),
                        Text(
                          'Hello, ${user.fName}',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 38,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                height: size.height * 0.1,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: FlatButton(
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, '/clientsScreen');
                                    },
                                    color: Colors.white,
                                    child: Text(
                                      'Clients',
                                      style: TextStyle(
                                          color: kPrimaryColor,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 20),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                height: size.height * 0.1,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: FlatButton(
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, '/doctorsScreen');
                                    },
                                    color: Colors.white,
                                    child: Text(
                                      'Doctors',
                                      style: TextStyle(
                                          color: kPrimaryColor,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 20),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      decoration: BoxDecoration(
                        color: kPrimaryLightColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(53),
                            topRight: Radius.circular(53)),
                      ),
                      child: Column(
                        children: [
                          Form(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(28),
                              ),
                              child: Row(
                                // mainAxisAlignment:
                                //     MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      width: size.width * 0.5,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      child: TextFormField(
                                        controller: textController,
                                        decoration: InputDecoration(
                                          icon: Icon(
                                            Icons.search,
                                            color: kPrimaryColor,
                                          ),
                                          hintText: "Search Appointments",
                                          border: InputBorder.none,
                                        ),
                                        onChanged: (val) {
                                          setState(() => search = val);
                                        },
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.cancel,
                                      color: kPrimaryColor,
                                    ),
                                    enableFeedback: showCancel,
                                    onPressed: () {
                                      setState(() {
                                        search = '';
                                        textController.text = '';
                                        showCancel = false;
                                      });
                                    },
                                    // DateFormat('dd-MM-yyyy').format(value))
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Today's Appointments",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Expanded(
                            child: AppointmentsListSecretary(search),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : Loading();
  }
}
