import 'package:clinic/components/forms/rounded_button..dart';
import 'package:clinic/components/forms/rounded_input_field.dart';
import 'package:clinic/models/client.dart';
import 'package:clinic/screens/shared/loading.dart';
import 'package:clinic/services/auth.dart';
import 'package:clinic/services/database.dart';
import 'package:flutter/material.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import '../shared/constants.dart';
import 'package:ndialog/ndialog.dart';

class EditClient extends StatefulWidget {
  EditClient({this.client});
  final Client client;
  @override
  _EditClientState createState() => _EditClientState();
}

class _EditClientState extends State<EditClient> {
  AuthService _auth = AuthService();

  // text field state
  String email = '';
  String fName = '';
  String lName = '';
  String phoneNumber = '';
  String error = '';
  int numAppointments = 0;
  int gender = 0;
  int age;
  bool loading = false;
  File newProfilePic;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    email = widget.client.email;
    fName = widget.client.fName;
    lName = widget.client.lName;
    phoneNumber = widget.client.phoneNumber;
    numAppointments = widget.client.numAppointments;
    if (widget.client.gender == 'male') {
      gender = 0;
    } else {
      gender = 1;
    }
    age = widget.client.age;
  }

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
                      'Edit ${widget.client.fName}',
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
                                : widget.client.picURL == ''
                                    ? AssetImage(
                                        'assets/images/Default-image.png',
                                      )
                                    : NetworkImage(
                                        widget.client.picURL,
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
                            initialValue: widget.client.fName,
                            obsecureText: false,
                            icon: Icons.person_add_alt,
                            hintText: '${widget.client.fName}',
                            onChanged: (val) {
                              setState(() => fName = val);
                            },
                            validator: (val) =>
                                val.isEmpty ? 'Enter a name' : null,
                          ),
                          RoundedInputField(
                            initialValue: widget.client.lName,
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
                            initialValue: widget.client.age.toString(),
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
                            initialValue: widget.client.phoneNumber,
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
                            initialValue:
                                widget.client.numAppointments.toString(),
                            obsecureText: false,
                            icon: Icons.add,
                            hintText: 'Remaining Sessions',
                            onChanged: (val) {
                              setState(() => numAppointments = int.parse(val));
                            },
                          ),
                          RoundedInputField(
                            initialValue: widget.client.email,
                            obsecureText: false,
                            icon: Icons.email,
                            hintText: 'Email',
                            onChanged: (val) {
                              setState(() => email = val);
                            },
                            validator: (val) =>
                                val.isEmpty ? 'Enter an email' : null,
                          ),
                          RoundedButton(
                            text: 'Edit',
                            press: () async {
                              if (_formKey.currentState.validate()) {
                                setState(() {
                                  loading = true;
                                });

                                String downloadUrl;
                                if (newProfilePic != null) {
                                  final Reference firebaseStorageRef =
                                      FirebaseStorage.instance.ref().child(
                                          'profilePics/${widget.client.uid}.jpg');
                                  UploadTask task =
                                      firebaseStorageRef.putFile(newProfilePic);
                                  TaskSnapshot taskSnapshot = await task;
                                  downloadUrl =
                                      await taskSnapshot.ref.getDownloadURL();
                                }

                                DatabaseService db =
                                    DatabaseService(uid: widget.client.uid);
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
                                    newProfilePic != null
                                        ? downloadUrl
                                        : widget.client.picURL,
                                    'client');

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
                                          'Client Edited',
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
