import 'package:clinic/components/forms/rounded_button..dart';
import 'package:clinic/components/forms/rounded_input_field.dart';
import 'package:clinic/models/user.dart';
import 'package:clinic/screens/shared/loading.dart';
import 'package:clinic/services/auth.dart';
import 'package:clinic/services/database.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../shared/constants.dart';
import 'package:ndialog/ndialog.dart';

class AddClient extends StatefulWidget {
  AddClient();
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
  CountryCode countryCode;
  String phoneNumber = '';
  String error = '';
  int numAppointments = 0;
  int gender = 0;
  int age;
  bool loading = false;
  String curEmail;
  String curPassword;
  File newProfilePic;

  final _formKey = GlobalKey<FormState>();
  Future getImage() async {
    var tempImage = await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      newProfilePic = File(tempImage.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthUser>(context);
    Size size = MediaQuery.of(context).size;
    return loading
        ? Loading()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
                      'Add new client',
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
              Expanded(
                child: Container(
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          //Gender switch
                          CircleAvatar(
                            radius: size.width * 0.12,
                            backgroundImage: newProfilePic != null
                                ? FileImage(newProfilePic)
                                : AssetImage(
                                    'assets/images/Default-image.png',
                                  ),
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Positioned(
                                  bottom: -size.width * 0.01,
                                  right: -size.width * 0.01,
                                  child: GestureDetector(
                                    onTap: () {
                                      getImage();
                                    },
                                    child: SvgPicture.asset(
                                      'assets/images/add.svg',
                                      width: size.width * 0.095,
                                      height: size.width * 0.095,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.04,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: size.width * 0.1),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/images/gender.svg',
                                ),
                                SizedBox(
                                  width: size.width * 0.02,
                                ),
                                Text(
                                  'Gender',
                                  style: TextStyle(
                                    color: kPrimaryTextColor,
                                    fontSize: size.width * 0.06,
                                  ),
                                ),
                                SizedBox(
                                  width: size.width * 0.04,
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        gender = 0;
                                      });
                                    },
                                    child: Container(
                                      // width: size.width * 0.35,
                                      // height: size.height * 0.07,
                                      padding: EdgeInsets.symmetric(
                                        vertical: size.height * 0.02,
                                        horizontal: size.width * 0.04,
                                      ),
                                      decoration: BoxDecoration(
                                        color: gender == 0
                                            ? kPrimaryColor
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: gender == 0
                                              ? Colors.transparent
                                              : kPrimaryLightColor,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Male',
                                          style: TextStyle(
                                            color: gender == 0
                                                ? Colors.white
                                                : kPrimaryTextColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: size.width * 0.02,
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        gender = 1;
                                      });
                                    },
                                    child: Container(
                                      // width: size.width * 0.35,
                                      // height: size.height * 0.07,
                                      padding: EdgeInsets.symmetric(
                                        vertical: size.height * 0.02,
                                        horizontal: size.width * 0.04,
                                      ),
                                      decoration: BoxDecoration(
                                        color: gender == 1
                                            ? kPrimaryColor
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: gender == 1
                                              ? Colors.transparent
                                              : kPrimaryLightColor,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Female',
                                          style: TextStyle(
                                            color: gender == 1
                                                ? Colors.white
                                                : kPrimaryTextColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          Container(
                            width: size.width * 0.8,
                            child: Row(
                              children: [
                                CountryCodePicker(
                                  padding: EdgeInsets.zero,
                                  onChanged: (value) {
                                    setState(() {
                                      countryCode = value;
                                    });
                                  },
                                  onInit: (value) {
                                    countryCode = value;
                                  },
                                  // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                                  initialSelection: 'EG',
                                  // optional. Shows only country name and flag
                                  showCountryOnly: false,
                                  // optional. Shows only country name and flag when popup is closed.
                                  showOnlyCountryWhenClosed: false,
                                  // optional. aligns the flag and the Text left
                                  alignLeft: false,
                                ),
                                Container(
                                  margin: EdgeInsets.only(bottom: 20),
                                  width: size.width * 0.55,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 5),
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    onChanged: (val) {
                                      setState(() => phoneNumber = val);
                                    },
                                    validator: (val) => val.isEmpty
                                        ? 'Enter a valid number'
                                        : null,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          RoundedInputField(
                            initialValue: fName,
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
                            initialValue: lName,
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
                            inputType: TextInputType.number,
                            initialValue: age != null ? age.toString() : '',
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
                            inputType: TextInputType.number,
                            initialValue: numAppointments != null
                                ? numAppointments.toString()
                                : 0.toString(),
                            obsecureText: false,
                            icon: Icons.add,
                            hintText: 'Remaining Sessions',
                            onChanged: (val) {
                              setState(() => numAppointments = int.parse(val));
                            },
                          ),
                          RoundedInputField(
                            initialValue: email,
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
                                AuthUser result =
                                    await _auth.createUserWithEmailAndPasword(
                                  email: email,
                                  password: password,
                                );
                                if (result == null) {
                                  setState(() {
                                    error = 'invalid email';
                                    loading = false;
                                  });
                                } else {
                                  String downloadUrl =
                                      await DatabaseService(uid: result.uid)
                                          .uploadUserImage(newProfilePic);

                                  DatabaseService db =
                                      DatabaseService(uid: result.uid);
                                  db.updateClientData(
                                    numAppointments: numAppointments,
                                    age: age,
                                    fName: fName,
                                    lName: lName,
                                    countryCode: countryCode.code,
                                    countryDialCode: countryCode.dialCode,
                                    phoneNumber: phoneNumber,
                                    gender: gender == 0 ? 'male' : 'female',
                                    picURL: downloadUrl,
                                    status: 1,
                                    role: 'client',
                                    email: email,
                                  );
                                  setState(() {
                                    loading = false;
                                  });
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
                                            'Client Added',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: size.height * 0.04,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(
                                            height: size.height * 0.02,
                                          ),
                                          Text(
                                            'Client can now sign in',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: size.height * 0.025,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ).show(context);
                                }
                              }
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            error,
                            style: TextStyle(color: Colors.red, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
  }
}
