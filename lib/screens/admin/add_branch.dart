import 'dart:io';
import 'package:clinic/components/forms/rounded_button..dart';
import 'package:clinic/components/forms/rounded_input_field.dart';
import 'package:clinic/models/branch.dart';
import 'package:clinic/models/user.dart';
import 'package:clinic/screens/admin/map.dart';
import 'package:clinic/screens/shared/loading.dart';
import 'package:clinic/services/auth.dart';
import 'package:clinic/services/database.dart';
import 'package:country_code_picker/country_code.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddBranch extends StatefulWidget {
  static final id = 'AddBranch';
  final Function toggleView;
  AddBranch({this.toggleView});
  @override
  _AddBranchState createState() => _AddBranchState();
}

class _AddBranchState extends State<AddBranch> {
  AuthService _auth = AuthService();

  // text field state
  String error = '';
  int numAppointments = 0;
  int gender = 0;
  bool loading = false;
  Branch branch;
  String name = '';
  String address = '';
  String phoneNumber = '';
  CountryCode countryCode;

  File newProfilePic;

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
              .updateUserProfilePicture(value.toString()),
        );
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthUser>(context);
    Size size = MediaQuery.of(context).size;
    return loading
        ? Loading()
        : SafeArea(
            child: Scaffold(
              body: StreamProvider<UserModel>.value(
                value: DatabaseService(uid: user.uid).userData,
                builder: (context, child) {
                  return Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(right: size.width * 0.04),
                        height: size.height * 0.1,
                        width: double.infinity,
                        color: kPrimaryColor,
                        child: Row(
                          children: [
                            BackButton(
                              color: Colors.white,
                            ),
                            SizedBox(width: size.width * 0.18),
                            Text(
                              'Add new branch',
                              style: TextStyle(
                                fontSize: size.width * 0.06,
                                color: Colors.white,
                              ),
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
                                  RoundedInputField(
                                    obsecureText: false,
                                    icon: Icons.edit,
                                    hintText: 'Branch Name',
                                    onChanged: (val) {
                                      setState(() => name = val);
                                    },
                                    validator: (val) =>
                                        val.isEmpty ? 'Enter a name' : null,
                                  ),
                                  RoundedInputField(
                                    obsecureText: false,
                                    icon: Icons.edit,
                                    hintText: 'Full Address',
                                    onChanged: (val) {
                                      setState(() => address = val);
                                    },
                                    validator: (val) =>
                                        val.isEmpty ? 'Enter an address' : null,
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
                                  RoundedButton(
                                    text: 'Select Location',
                                    press: () {
                                      if (_formKey.currentState.validate()) {
                                        Navigator.pushNamed(
                                            context, MapSelect.id,
                                            arguments: {
                                              'name': name,
                                              'address': address,
                                              'countryCode': countryCode,
                                              'phoneNumber': phoneNumber,
                                            });
                                      }
                                    },
                                  ),
                                  SizedBox(
                                    height: size.height * 0.02,
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
                },
                initialData: null,
              ),
            ),
          );
  }
}
