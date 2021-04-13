import 'package:clinic/components/forms/rounded_button..dart';
import 'package:clinic/components/forms/rounded_input_field.dart';
import 'package:clinic/models/branch.dart';
import 'package:clinic/models/doctor.dart';
import 'package:clinic/screens/shared/loading.dart';
import 'package:clinic/services/auth.dart';
import 'package:clinic/services/database.dart';
import 'package:flutter/material.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ndialog/ndialog.dart';
import 'dart:io';
import '../shared/constants.dart';

class EditDoctorAdmin extends StatefulWidget {
  static const id = 'AddDoctorSec';

  EditDoctorAdmin({this.doctor});
  final Doctor doctor;

  @override
  _EditDoctorAdminState createState() => _EditDoctorAdminState();
}

class _EditDoctorAdminState extends State<EditDoctorAdmin> {
  AuthService _auth = AuthService();

  // text field state
  String fName = '';
  String lName = '';
  String phoneNumber = '';
  String error = '';
  String bio = '';
  int gender = 0;
  String specialty;
  bool loading = false;
  File newProfilePic;
  String branchName = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fName = widget.doctor.fName;
    lName = widget.doctor.lName;
    phoneNumber = widget.doctor.phoneNumber;
    bio = widget.doctor.about;
    specialty = widget.doctor.proffesion;
    branchName = widget.doctor.branch;
    if (widget.doctor.gender == 'male') {
      gender = 0;
    } else {
      gender = 1;
    }
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
              .updateUserProfilePicture(value.toString(), 'doctor'),
        );
  }

  Map secretaryData = {};

  @override
  Widget build(BuildContext context) {
    secretaryData = ModalRoute.of(context).settings.arguments;

    Size size = MediaQuery.of(context).size;
    return loading
        ? Loading()
        : StreamBuilder<List<Branch>>(
            stream: DatabaseService().branches,
            builder: (context, snapshot) {
              List<Branch> branches = snapshot.data;
              if (snapshot.hasData) {
                return Column(
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
                            'Edit Dr.${widget.doctor.fName}',
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
                                      : widget.doctor.picURL == ''
                                          ? AssetImage(
                                              'assets/images/Default-image.png',
                                            )
                                          : NetworkImage(
                                              widget.doctor.picURL,
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
                                      SizedBox(
                                        height: 15,
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
                                Container(
                                  width: size.width * 0.8,
                                  child: DropdownButtonFormField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    hint: Text(
                                      'Select branch',
                                    ),
                                    items: branches.map((branch) {
                                      return DropdownMenuItem(
                                        value: branch.name,
                                        child: Text('${branch.name}'),
                                      );
                                    }).toList(),
                                    onChanged: (val) =>
                                        setState(() => branchName = val),
                                  ),
                                ),
                                RoundedInputField(
                                  initialValue: widget.doctor.fName,
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
                                  initialValue: widget.doctor.lName,
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
                                  initialValue: widget.doctor.proffesion,
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
                                  initialValue: widget.doctor.phoneNumber,
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
                                  initialValue: widget.doctor.about,
                                  obsecureText: false,
                                  icon: Icons.info,
                                  hintText: 'Bio',
                                  onChanged: (val) {
                                    setState(() => bio = val);
                                  },
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
                                                'profilePics/${widget.doctor.uid}.jpg');
                                        UploadTask task = firebaseStorageRef
                                            .putFile(newProfilePic);
                                        TaskSnapshot taskSnapshot = await task;
                                        downloadUrl = await taskSnapshot.ref
                                            .getDownloadURL();
                                      }
                                      DatabaseService db = DatabaseService(
                                          uid: widget.doctor.uid);
                                      db.updateDoctorData(
                                        fName: fName,
                                        lName: lName,
                                        phoneNumber: phoneNumber,
                                        gender: gender == 0 ? 'male' : 'female',
                                        about: bio,
                                        profession: specialty,
                                        branch: branchName,
                                      );
                                      await db.updateDoctorWorkDays();
                                      await db.updateUserProfilePicture(
                                          newProfilePic != null
                                              ? downloadUrl
                                              : '',
                                          'doctor');
                                      setState(() {
                                        loading = false;
                                      });
                                      Navigator.pop(context);
                                      await NDialog(
                                        dialogStyle: DialogStyle(
                                          backgroundColor: kPrimaryColor,
                                          borderRadius:
                                              BorderRadius.circular(10),
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
                                                'Doctor Edited',
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
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return Loading();
              }
            });
  }
}
