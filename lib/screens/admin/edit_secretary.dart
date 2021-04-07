import 'dart:io';
import 'package:clinic/components/forms/rounded_button..dart';
import 'package:clinic/components/forms/rounded_input_field.dart';
import 'package:clinic/models/branch.dart';
import 'package:clinic/models/secretary.dart';
import 'package:clinic/models/user.dart';
import 'package:clinic/screens/shared/loading.dart';
import 'package:clinic/services/auth.dart';
import 'package:clinic/services/database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ndialog/ndialog.dart';
import 'package:provider/provider.dart';

class EditSecretary extends StatefulWidget {
  final Secretary secretary;
  EditSecretary({this.secretary});
  @override
  _EditSecretaryState createState() => _EditSecretaryState();
}

class _EditSecretaryState extends State<EditSecretary> {
  AuthService _auth = AuthService();

  // text field state
  String fName = '';
  String lName = '';
  String phoneNumber = '';
  String error = '';
  int gender = 0;
  int age;
  bool loading = false;
  Branch branch;
  String branchName = '';
  File newProfilePic;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fName = widget.secretary.fName;
    lName = widget.secretary.lName;
    phoneNumber = widget.secretary.phoneNumber;
    branchName = widget.secretary.branch;
    if (widget.secretary.gender == 'male') {
      gender = 0;
    } else {
      gender = 1;
    }
  }

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
                return StreamBuilder<List<Branch>>(
                    stream: DatabaseService().branches,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<Branch> branches = snapshot.data;
                        if (branches.length != 0) {
                          branch = branches[0];
                        }
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
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
                                    'Edit ${widget.secretary.fName}',
                                    style: TextStyle(
                                        fontSize: size.width * 0.05,
                                        color: kPrimaryTextColor),
                                  ),
                                  SizedBox(width: size.width * 0.15),
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
                                              : widget.secretary.picURL == ''
                                                  ? AssetImage(
                                                      'assets/images/Default-image.png',
                                                    )
                                                  : NetworkImage(
                                                      widget.secretary.picURL,
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
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      vertical:
                                                          size.height * 0.02,
                                                      horizontal:
                                                          size.width * 0.04,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: gender == 0
                                                          ? kPrimaryColor
                                                          : Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
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
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      vertical:
                                                          size.height * 0.02,
                                                      horizontal:
                                                          size.width * 0.04,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: gender == 1
                                                          ? kPrimaryColor
                                                          : Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
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
                                            onChanged: (val) => setState(
                                                () => branchName = val),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        RoundedInputField(
                                          initialValue: widget.secretary.fName,
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
                                          initialValue: widget.secretary.lName,
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
                                          initialValue:
                                              widget.secretary.phoneNumber,
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

                                        RoundedButton(
                                          text: 'Add',
                                          press: () async {
                                            if (_formKey.currentState
                                                .validate()) {
                                              setState(() {
                                                loading = true;
                                              });

                                              String downloadUrl;
                                              if (newProfilePic != null) {
                                                final Reference
                                                    firebaseStorageRef =
                                                    FirebaseStorage.instance
                                                        .ref()
                                                        .child(
                                                            'profilePics/${widget.secretary.uid}.jpg');
                                                UploadTask task =
                                                    firebaseStorageRef
                                                        .putFile(newProfilePic);
                                                TaskSnapshot taskSnapshot =
                                                    await task;
                                                downloadUrl = await taskSnapshot
                                                    .ref
                                                    .getDownloadURL();

                                                // Add client to clients collectionab
                                                DatabaseService db =
                                                    DatabaseService(
                                                        uid: widget
                                                            .secretary.uid);
                                                await db.updateSecretaryData(
                                                  fName: fName,
                                                  lName: lName,
                                                  phoneNumber: phoneNumber,
                                                  gender: gender == 0
                                                      ? 'male'
                                                      : 'female',
                                                  branchId: branch.docID,
                                                  branchName: branch.name,
                                                  picURL: '',
                                                );
                                                await db
                                                    .updateUserProfilePicture(
                                                        newProfilePic != null
                                                            ? downloadUrl
                                                            : '',
                                                        'secretary');

                                                setState(() {
                                                  loading = false;
                                                });
                                                await NDialog(
                                                  dialogStyle: DialogStyle(
                                                    backgroundColor:
                                                        kPrimaryColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  content: Container(
                                                    height: size.height * 0.5,
                                                    width: size.width * 0.8,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          child:
                                                              SvgPicture.asset(
                                                            'assets/images/check2.svg',
                                                            fit: BoxFit.none,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: size.height *
                                                              0.05,
                                                        ),
                                                        Text(
                                                          'Manager Edited',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize:
                                                                size.height *
                                                                    0.04,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
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
              },
              initialData: null,
            ),
          );
  }
}
