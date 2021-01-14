import 'package:auto_size_text/auto_size_text.dart';
import 'package:clinic/components/forms/rounded_button..dart';
import 'package:clinic/components/forms/rounded_input_field.dart';
import 'package:clinic/models/user.dart';
import 'package:clinic/screens/shared/loading.dart';
import 'package:clinic/services/auth.dart';
import 'package:clinic/services/database.dart';
import 'package:flutter/material.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';

class AddClient extends StatefulWidget {
  final Function toggleView;
  AddClient({this.toggleView});
  @override
  _AddClientState createState() => _AddClientState();
}

class _AddClientState extends State<AddClient> {
  AuthService _auth = AuthService();

  // text field state
  String email = '';
  String password = '';
  String fName = '';
  String lName = '';
  String phoneNumber = '';
  String error = '';
  int numAppointments = 0;
  int gender = 0;
  int age;
  bool loading = false;
  String curEmail;
  String curPassword;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser>(context);
    Size size = MediaQuery.of(context).size;
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
                                    'Add Client',
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
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    //Gender switch
                                    ToggleSwitch(
                                      minWidth: 90.0,
                                      initialLabelIndex: 0,
                                      cornerRadius: 20.0,
                                      activeFgColor: Colors.white,
                                      inactiveBgColor: Colors.grey,
                                      inactiveFgColor: Colors.white,
                                      labels: ['Male', 'Female'],
                                      icons: [
                                        FontAwesomeIcons.mars,
                                        FontAwesomeIcons.venus
                                      ],
                                      activeBgColors: [
                                        Colors.blue,
                                        Colors.pink
                                      ],
                                      onToggle: (index) {
                                        gender = index;
                                      },
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    RoundedInputField(
                                      obsecureText: false,
                                      icon: Icons.person_add_alt,
                                      hintText: 'First Name',
                                      onChanged: (val) {
                                        setState(() => fName = val);
                                      },
                                      validator: (val) =>
                                          val.isEmpty ? 'Enter a name' : null,
                                    ),
                                    RoundedInputField(
                                      obsecureText: false,
                                      icon: Icons.person_add_alt_1,
                                      hintText: 'Last Name',
                                      onChanged: (val) {
                                        setState(() => lName = val);
                                      },
                                      validator: (val) =>
                                          val.isEmpty ? 'Enter a name' : null,
                                    ),
                                    RoundedInputField(
                                      obsecureText: false,
                                      icon: Icons.calendar_today,
                                      hintText: 'Age',
                                      onChanged: (val) {
                                        setState(() => age = int.parse(val));
                                      },
                                      validator: (val) =>
                                          val.isEmpty ? 'Enter an age' : null,
                                    ),
                                    RoundedInputField(
                                      obsecureText: false,
                                      icon: Icons.phone,
                                      hintText: 'Phone Number',
                                      onChanged: (val) {
                                        setState(() => phoneNumber = val);
                                      },
                                      validator: (val) => val.length != 11
                                          ? 'Enter a valid number'
                                          : null,
                                    ),
                                    RoundedInputField(
                                      obsecureText: false,
                                      icon: Icons.add,
                                      hintText: 'Remaining Sessions',
                                      onChanged: (val) {
                                        setState(() =>
                                            numAppointments = int.parse(val));
                                      },
                                    ),
                                    RoundedInputField(
                                      obsecureText: false,
                                      icon: Icons.email,
                                      hintText: 'Email',
                                      onChanged: (val) {
                                        setState(() => email = val);
                                      },
                                      validator: (val) =>
                                          val.isEmpty ? 'Enter an email' : null,
                                    ),
                                    RoundedInputField(
                                      obsecureText: true,
                                      icon: Icons.lock,
                                      hintText: 'Password',
                                      onChanged: (val) {
                                        setState(() => password = val);
                                      },
                                      validator: (val) => val.length < 6
                                          ? ' Enter a password 6+ chars long '
                                          : null,
                                    ),
                                    RoundedButton(
                                      text: 'Add',
                                      press: () async {
                                        if (_formKey.currentState.validate()) {
                                          setState(() {
                                            loading = true;
                                          });
                                          if (user.role != 'client') {
                                            curEmail = user.email;
                                            curPassword = userData.password;
                                          }
                                          MyUser result = await _auth
                                              .registerWithEmailAndPasword(
                                                  email,
                                                  password,
                                                  fName,
                                                  lName,
                                                  phoneNumber,
                                                  gender == 0
                                                      ? 'male'
                                                      : 'female',
                                                  'client');
                                          if (result == null) {
                                            setState(() {
                                              error = 'invalid credentials';
                                              loading = false;
                                            });
                                          } else {
                                            // Add client to clients collectionab
                                            DatabaseService db =
                                                DatabaseService(
                                                    uid: result.uid);
                                            db.updateClientData(
                                              fName,
                                              lName,
                                              phoneNumber,
                                              gender == 0 ? 'male' : 'female',
                                              numAppointments,
                                              age,
                                            );
                                            await _auth.signOut();
                                            await _auth
                                                .signInWithEmailAndPassword(
                                                    curEmail, curPassword);
                                            loading = false;
                                          }
                                        }
                                      },
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      error,
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 14),
                                    ),
                                  ],
                                ),
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
