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
import '../../models/workDay.dart';
import '../../components/lists_cards/workDays_list.dart';

class AddDoctorSec extends StatefulWidget {
  static const id = 'AddDoctorSec';
  final String secretaryBranch;

  AddDoctorSec({this.secretaryBranch});
  @override
  _AddDoctorSecState createState() => _AddDoctorSecState();
}

class _AddDoctorSecState extends State<AddDoctorSec> {
  AuthService _auth = AuthService();

  // text field state
  String email = '';
  String password = '';
  String fName = '';
  String lName = '';
  String phoneNumber = '';
  String error = '';
  String bio = '';
  int gender = 0;
  String specialty;
  bool loading = false;
  String curEmail;
  String curPassword;
  File newProfilePic;
  bool readyToManageSchedule = false;
  String doctorId = '';

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
              .updateUserProfilePicture(value.toString(), 'secretary'),
        );
  }

  Map secretaryData = {};

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser>(context);
    secretaryData = ModalRoute.of(context).settings.arguments;

    Size size = MediaQuery.of(context).size;
    return readyToManageSchedule == false
        ? loading
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
                          'Add new doctor',
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
                      // height: size.height * 0.5,
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
                                            borderRadius:
                                                BorderRadius.circular(10),
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
                                            borderRadius:
                                                BorderRadius.circular(10),
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
                                icon: Icons.person,
                                hintText: 'Specialty',
                                onChanged: (val) {
                                  setState(() => specialty = val);
                                },
                                validator: (val) =>
                                    val.isEmpty ? 'Enter a specialty' : null,
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
                                icon: Icons.info,
                                hintText: 'Bio',
                                onChanged: (val) {
                                  setState(() => bio = val);
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
                                text: 'NEXT',
                                press: () async {
                                  if (_formKey.currentState.validate()) {
                                    setState(() {
                                      loading = true;
                                    });
                                    // if (user.role != 'doctor') {
                                    //   curEmail = user.email;
                                    //   curPassword = userData.password;
                                    // }
                                    MyUser result = await _auth
                                        .createUserWithEmailAndPasword(
                                      email,
                                      password,
                                      fName,
                                      lName,
                                      phoneNumber,
                                      gender == 0 ? 'male' : 'female',
                                      'doctor',
                                      '',
                                    );
                                    if (result == null) {
                                      setState(() {
                                        error = 'invalid credentials';
                                        loading = false;
                                      });
                                    } else {
                                      String downloadUrl;
                                      doctorId = result.uid;
                                      if (newProfilePic != null) {
                                        final Reference firebaseStorageRef =
                                            FirebaseStorage.instance.ref().child(
                                                'profilePics/$doctorId.jpg');
                                        UploadTask task = firebaseStorageRef
                                            .putFile(newProfilePic);
                                        TaskSnapshot taskSnapshot = await task;
                                        downloadUrl = await taskSnapshot.ref
                                            .getDownloadURL();
                                      }

                                      // Add client to clients collectionab
                                      DatabaseService db =
                                          DatabaseService(uid: doctorId);
                                      db.updateDoctorData(
                                        fName: fName,
                                        lName: lName,
                                        phoneNumber: phoneNumber,
                                        gender: gender == 0 ? 'male' : 'female',
                                        about: bio,
                                        profession: specialty,
                                        branch: widget.secretaryBranch,
                                      );
                                      await db.updateDoctorWorkDays();
                                      await db.updateUserProfilePicture(
                                          newProfilePic != null
                                              ? downloadUrl
                                              : '',
                                          'doctor');
                                      setState(() {
                                        loading = false;
                                        readyToManageSchedule = true;
                                      });
                                    }
                                  }
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                error,
                                style:
                                    TextStyle(color: Colors.red, fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
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
                      'Schedule',
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
                  width: size.width * 0.9,
                  child: StreamProvider<List<WorkDay>>.value(
                    value: DatabaseService().getWorkDays(doctorId),
                    builder: (context, child) => WorkDaysList(
                      doctorID: doctorId,
                    ),
                  ),
                ),
              ),
            ],
          );
  }
}
