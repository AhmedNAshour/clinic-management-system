import 'package:auto_size_text/auto_size_text.dart';
import 'package:clinic/components/forms/rounded_button..dart';
import 'package:clinic/components/forms/rounded_input_field.dart';
import 'package:clinic/models/user.dart';
import 'package:clinic/screens/shared/loading.dart';
import 'package:clinic/services/database.dart';
import 'package:flutter/material.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:provider/provider.dart';

class ClientInfo extends StatefulWidget {
  @override
  _ClientInfoState createState() => _ClientInfoState();
}

class _ClientInfoState extends State<ClientInfo> {
  // text field state

  bool loading = false;
  Map clientData = {};
  int curSessions;
  int newSessions;
  final _formKey = GlobalKey<FormState>();
  String error = '';

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser>(context);
    Size size = MediaQuery.of(context).size;
    clientData = ModalRoute.of(context).settings.arguments;
    if (curSessions == null) {
      curSessions = clientData['numAppointments'];
    }
    return loading
        ? Loading()
        : SafeArea(
            child: StreamProvider<UserData>.value(
              value: DatabaseService(uid: user.uid).userData,
              builder: (context, child) {
                final userData = Provider.of<UserData>(context);
                return Scaffold(
                  backgroundColor: kPrimaryLightColor,
                  body: Column(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 53),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    height: 40,
                                    width: 100,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Icon(
                                          Icons.arrow_back,
                                          color: kPrimaryLightColor,
                                        ),
                                        Text(
                                          'BACK',
                                          style: TextStyle(
                                              color: kPrimaryLightColor,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 20),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: AutoSizeText(
                                    'Client Info',
                                    style: TextStyle(
                                        fontSize: 55,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                    minFontSize: 30,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 53, vertical: 40),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(53),
                                topRight: Radius.circular(53)),
                          ),
                          child: Container(
                            // height: size.height * 0.5,
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AutoSizeText(
                                    'Name: ${clientData['fName']} ${clientData['lName']}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  AutoSizeText(
                                    'Age: ${clientData['age']}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  AutoSizeText(
                                    'Gender: ${clientData['gender']}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  AutoSizeText(
                                    'Phone number: ${clientData['phoneNumber']}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  AutoSizeText(
                                    'Remaining appointments: ${clientData['numAppointments']}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  RoundedButton(
                                    press: () {
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (context) {
                                            return FractionallySizedBox(
                                              heightFactor: 0.7,
                                              child: DraggableScrollableSheet(
                                                  initialChildSize: 1.0,
                                                  maxChildSize: 1.0,
                                                  minChildSize: 0.25,
                                                  builder: (BuildContext
                                                          context,
                                                      ScrollController
                                                          scrollController) {
                                                    return SingleChildScrollView(
                                                      child: Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 20,
                                                                vertical: 40),
                                                        child: Column(
                                                          children: <Widget>[
                                                            Text(
                                                              'Add Sessions',
                                                              style: TextStyle(
                                                                color:
                                                                    kPrimaryColor,
                                                                fontSize: 30,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 20,
                                                            ),
                                                            Text(
                                                              'Current number: $curSessions',
                                                              style: TextStyle(
                                                                color:
                                                                    kPrimaryColor,
                                                                fontSize: 25,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            Form(
                                                              key: _formKey,
                                                              child: Column(
                                                                children: [
                                                                  RoundedInputField(
                                                                    icon: Icons
                                                                        .add,
                                                                    obsecureText:
                                                                        false,
                                                                    hintText:
                                                                        'New number',
                                                                    onChanged:
                                                                        (val) {
                                                                      setState(() =>
                                                                          newSessions =
                                                                              int.parse(val));
                                                                    },
                                                                    validator: (val) => val
                                                                            .isEmpty
                                                                        ? 'Enter a valid number'
                                                                        : null,
                                                                  ),
                                                                  RoundedButton(
                                                                    text: 'Add',
                                                                    press:
                                                                        () async {
                                                                      if (_formKey
                                                                          .currentState
                                                                          .validate()) {
                                                                        await DatabaseService().updateClientRemainingSessions(
                                                                            numAppointments:
                                                                                newSessions,
                                                                            documentID:
                                                                                clientData['uid']);
                                                                      }
                                                                    },
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                          10),
                                                                  Text(
                                                                    error,
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .red,
                                                                        fontSize:
                                                                            14),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  }),
                                            );
                                          },
                                          isScrollControlled: true);
                                    },
                                    text: 'ADD SESSIONS',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
  }
}
