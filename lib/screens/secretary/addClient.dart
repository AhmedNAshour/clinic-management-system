import 'package:clinic/components/forms/rounded_button..dart';
import 'package:clinic/components/forms/rounded_input_field.dart';
import 'package:clinic/models/user.dart';
import 'package:clinic/screens/shared/loading.dart';
import 'package:clinic/services/auth.dart';
import 'package:clinic/services/database.dart';
import 'package:flutter/material.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
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

  uploadImage(String uid) async {
    final Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('profilePics/$uid.jpg');
    UploadTask task = firebaseStorageRef.putFile(newProfilePic);
    TaskSnapshot taskSnapshot = await task;
    taskSnapshot.ref.getDownloadURL().then(
          (value) => DatabaseService(uid: uid)
              .updateUserProfilePicture(value.toString(), 'client'),
        );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser>(context);
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
                              setState(() => numAppointments = int.parse(val));
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
                                // if (user.role != 'client') {
                                //   // curEmail = user.email;
                                //   // curPassword = userData.password;
                                // }
                                MyUser result =
                                    await _auth.createUserWithEmailAndPasword(
                                  email,
                                  password,
                                  fName,
                                  lName,
                                  phoneNumber,
                                  gender == 0 ? 'male' : 'female',
                                  'client',
                                  '',
                                  1,
                                );
                                if (result == null) {
                                  setState(() {
                                    error = 'invalid credentials';
                                    loading = false;
                                  });
                                } else {
                                  String downloadUrl;
                                  if (newProfilePic != null) {
                                    final Reference firebaseStorageRef =
                                        FirebaseStorage.instance.ref().child(
                                            'profilePics/${result.uid}.jpg');
                                    UploadTask task = firebaseStorageRef
                                        .putFile(newProfilePic);
                                    TaskSnapshot taskSnapshot = await task;
                                    downloadUrl =
                                        await taskSnapshot.ref.getDownloadURL();
                                  }

                                  // Add client to clients collectionab
                                  DatabaseService db =
                                      DatabaseService(uid: result.uid);
                                  db.updateClientData(
                                    fName: fName,
                                    lName: lName,
                                    phoneNumber: phoneNumber,
                                    gender: gender == 0 ? 'male' : 'female',
                                    numAppointments: numAppointments,
                                    age: age,
                                    email: email,
                                    status: 1,
                                  );
                                  await db.updateUserProfilePicture(
                                      newProfilePic != null ? downloadUrl : '',
                                      'client');

                                  setState(() {
                                    loading = false;
                                  });
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
                                          Container(
                                            child: SvgPicture.asset(
                                              'assets/images/check2.svg',
                                              fit: BoxFit.none,
                                              color: Colors.white,
                                            ),
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
                                          SizedBox(
                                            height: size.height * 0.04,
                                          ),
                                          Container(
                                            width: size.width * 0.8,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: GestureDetector(
                                                onTap: () {
                                                  AuthService().signOut();
                                                },
                                                child: Container(
                                                  child: Center(
                                                    child: Text(
                                                      'SIGN IN',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize:
                                                            size.height * 0.025,
                                                      ),
                                                    ),
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: kPrimaryColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    border: Border.all(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  padding: EdgeInsets.symmetric(
                                                    vertical: 20,
                                                    horizontal: 40,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ).show(context);
                                  // await _auth.signOut();
                                  // await _auth
                                  //     .signInWithEmailAndPassword(
                                  //         curEmail, curPassword);
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
