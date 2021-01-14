import 'package:auto_size_text/auto_size_text.dart';
import 'package:clinic/components/forms/rounded_button..dart';
import 'package:clinic/components/forms/rounded_input_field.dart';
import 'package:clinic/models/branch.dart';
import 'package:clinic/models/user.dart';
import 'package:clinic/screens/shared/loading.dart';
import 'package:clinic/services/auth.dart';
import 'package:clinic/services/database.dart';
import 'package:flutter/material.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';

class AddDoctor extends StatefulWidget {
  @override
  _AddDoctorState createState() => _AddDoctorState();
}

class _AddDoctorState extends State<AddDoctor> {
  AuthService _auth = AuthService();

  // text field state
  String email = '';
  String password = '';
  String fName = '';
  String lName = '';
  String phoneNumber = '';
  String about = '';
  String profession = '';
  String level = '';
  String error = '';
  int gender = 0;
  bool loading = false;
  String branch = '';
  String dummyBranchName = '';
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
                return StreamBuilder<List<Branch>>(
                    stream: DatabaseService().branches,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<Branch> branches = snapshot.data;
                        if (branches.length != 0) {
                          dummyBranchName = branches[0].name;
                          branch = branches[0].docID;
                        }
                        return Scaffold(
                          backgroundColor: kPrimaryLightColor,
                          body: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 53),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(bottom: 10),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(15),
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
                                                      fontWeight:
                                                          FontWeight.w500,
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
                                            'Add Doctor',
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
                                            Container(
                                              height: 60,
                                              width: double.infinity,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20, vertical: 5),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(29),
                                              ),
                                              child: DropdownButtonFormField(
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                ),
                                                icon: Icon(
                                                  Icons.pin_drop,
                                                  color: kPrimaryColor,
                                                ),
                                                hint: Text(
                                                  'Choose branch',
                                                ),

                                                // value: selectedName ??
                                                //     branches[0],
                                                items: branches.map((branch) {
                                                  return DropdownMenuItem(
                                                    value: branch.docID,
                                                    child:
                                                        Text('${branch.name}'),
                                                  );
                                                }).toList(),
                                                onChanged: (val) => setState(
                                                    () => branch = val),
                                              ),
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
                                              validator: (val) => val.isEmpty
                                                  ? 'Enter a name'
                                                  : null,
                                            ),
                                            RoundedInputField(
                                              obsecureText: false,
                                              icon: Icons.person_add_alt_1,
                                              hintText: 'Last Name',
                                              onChanged: (val) {
                                                setState(() => lName = val);
                                              },
                                              validator: (val) => val.isEmpty
                                                  ? 'Enter a name'
                                                  : null,
                                            ),
                                            RoundedInputField(
                                              obsecureText: false,
                                              icon: Icons.phone,
                                              hintText: 'Phone Number',
                                              onChanged: (val) {
                                                setState(
                                                    () => phoneNumber = val);
                                              },
                                              validator: (val) =>
                                                  val.length != 11
                                                      ? 'Enter a valid number'
                                                      : null,
                                            ),
                                            RoundedInputField(
                                              obsecureText: false,
                                              icon: Icons.info,
                                              hintText: 'Profession',
                                              onChanged: (val) {
                                                setState(
                                                    () => profession = val);
                                              },
                                              validator: (val) => val.isEmpty
                                                  ? 'Enter a profession'
                                                  : null,
                                            ),
                                            RoundedInputField(
                                              obsecureText: false,
                                              icon: Icons.info,
                                              hintText: 'About',
                                              onChanged: (val) {
                                                setState(() => about = val);
                                              },
                                            ),
                                            RoundedInputField(
                                              obsecureText: false,
                                              icon: Icons.email,
                                              hintText: 'Email',
                                              onChanged: (val) {
                                                setState(() => email = val);
                                              },
                                              validator: (val) => val.isEmpty
                                                  ? 'Enter an email'
                                                  : null,
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
                                                if (_formKey.currentState
                                                    .validate()) {
                                                  setState(() {
                                                    loading = true;
                                                  });
                                                  if (user.role != 'doctor') {
                                                    curEmail = user.email;
                                                    curPassword =
                                                        userData.password;
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
                                                          'doctor');
                                                  if (result == null) {
                                                    setState(() {
                                                      error =
                                                          'invalid credentials';
                                                      loading = false;
                                                    });
                                                  } else {
                                                    // Add doctor to doctors collection
                                                    DatabaseService db =
                                                        DatabaseService(
                                                            uid: result.uid);
                                                    await db.updateDoctorData(
                                                      fName,
                                                      lName,
                                                      phoneNumber,
                                                      gender == 0
                                                          ? 'male'
                                                          : 'female',
                                                      about,
                                                      profession,
                                                      branch,
                                                    );
                                                    await db
                                                        .updateDoctorWorkDays();
                                                    await _auth.signOut();
                                                    await _auth
                                                        .signInWithEmailAndPassword(
                                                            curEmail,
                                                            curPassword);
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
                                                  color: Colors.red,
                                                  fontSize: 14),
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
                      } else {
                        return Loading();
                      }
                    });
              },
            ),
          );
  }
}
