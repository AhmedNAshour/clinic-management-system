import 'package:clinic/components/forms/rounded_button..dart';
import 'package:clinic/components/forms/rounded_input_field.dart';
import 'package:clinic/langs/locale_keys.g.dart';
import 'package:clinic/models/branch.dart';
import 'package:clinic/models/user.dart';
import 'package:clinic/screens/shared/loading.dart';
import 'package:clinic/services/auth.dart';
import 'package:clinic/services/database.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../shared/constants.dart';
import '../../models/workDay.dart';
import '../../components/lists_cards/workDays_list.dart';
import 'package:easy_localization/easy_localization.dart';

class AddDoctorAdmin extends StatefulWidget {
  static const id = 'AddDoctorSec';
  final String secretaryBranch;

  AddDoctorAdmin({this.secretaryBranch});
  @override
  _AddDoctorAdminState createState() => _AddDoctorAdminState();
}

class _AddDoctorAdminState extends State<AddDoctorAdmin> {
  AuthService _auth = AuthService();

  // text field state
  String email = '';
  String password = '';
  String fName = '';
  String lName = '';
  CountryCode countryCode;
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
  String branchID = '';
  String downloadUrl;

  final _formKey = GlobalKey<FormState>();
  Future getImage() async {
    var tempImage = await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      newProfilePic = File(tempImage.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return readyToManageSchedule == false
        ? loading
            ? Loading()
            : StreamBuilder<List<Branch>>(
                stream: DatabaseService().getBranches(status: 1),
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
                                            LocaleKeys.gender.tr(),
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
                                          LocaleKeys.selectBranch.tr(),
                                        ),
                                        items: branches.map((branch) {
                                          return DropdownMenuItem(
                                            value: branch.docID,
                                            child: Text('${branch.name}'),
                                          );
                                        }).toList(),
                                        onChanged: (val) =>
                                            setState(() => branchID = val),
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
                                              keyboardType:
                                                  TextInputType.number,
                                              onChanged: (val) {
                                                setState(
                                                    () => phoneNumber = val);
                                              },
                                              validator: (val) => val.isEmpty
                                                  ? LocaleKeys.enterAValidNumber
                                                      .tr()
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
                                      hintText: LocaleKeys.firstName.tr(),
                                      onChanged: (val) {
                                        setState(() => fName = val);
                                      },
                                      validator: (val) => val.isEmpty
                                          ? LocaleKeys.enterAName.tr()
                                          : null,
                                    ),
                                    RoundedInputField(
                                      initialValue: lName,
                                      obsecureText: false,
                                      icon: Icons.person_add_alt_1,
                                      hintText: LocaleKeys.lastName.tr(),
                                      onChanged: (val) {
                                        setState(() => lName = val);
                                      },
                                      validator: (val) => val.isEmpty
                                          ? LocaleKeys.enterAName.tr()
                                          : null,
                                    ),
                                    RoundedInputField(
                                      initialValue: specialty,
                                      obsecureText: false,
                                      icon: Icons.person,
                                      hintText: LocaleKeys.specialty.tr(),
                                      onChanged: (val) {
                                        setState(() => specialty = val);
                                      },
                                      validator: (val) => val.isEmpty
                                          ? LocaleKeys.enterASpecialty.tr()
                                          : null,
                                    ),
                                    RoundedInputField(
                                      initialValue: bio,
                                      obsecureText: false,
                                      icon: Icons.info,
                                      hintText: LocaleKeys.about.tr(),
                                      onChanged: (val) {
                                        setState(() => bio = val);
                                      },
                                    ),
                                    RoundedInputField(
                                      initialValue: email,
                                      obsecureText: false,
                                      icon: Icons.email,
                                      hintText: LocaleKeys.email.tr(),
                                      onChanged: (val) {
                                        setState(() => email = val);
                                      },
                                      validator: (val) => val.isEmpty
                                          ? LocaleKeys.enterAnEmail.tr()
                                          : null,
                                    ),
                                    RoundedInputField(
                                      obsecureText: true,
                                      icon: Icons.lock,
                                      hintText: LocaleKeys.password.tr(),
                                      onChanged: (val) {
                                        setState(() => password = val);
                                      },
                                      validator: (val) => val.length < 6
                                          ? LocaleKeys.enterAPassword.tr()
                                          : null,
                                    ),
                                    RoundedButton(
                                      text: LocaleKeys.next.tr(),
                                      press: () async {
                                        if (_formKey.currentState.validate()) {
                                          setState(() {
                                            loading = true;
                                          });
                                          AuthUser result = await _auth
                                              .createUserWithEmailAndPasword(
                                            email: email,
                                            password: password,
                                          );
                                          if (result == null) {
                                            setState(() {
                                              error =
                                                  LocaleKeys.invalidEmail.tr();
                                              loading = false;
                                            });
                                          } else {
                                            doctorId = result.uid;
                                            downloadUrl = await DatabaseService(
                                                    uid: doctorId)
                                                .uploadUserImage(newProfilePic);
                                            DatabaseService db =
                                                DatabaseService(uid: doctorId);
                                            db.updateDoctorData(
                                              about: bio,
                                              profession: specialty,
                                              fName: fName,
                                              lName: lName,
                                              countryCode: countryCode.code,
                                              countryDialCode:
                                                  countryCode.dialCode,
                                              phoneNumber: phoneNumber,
                                              gender: gender == 0
                                                  ? 'male'
                                                  : 'female',
                                              picURL: downloadUrl,
                                              status: 1,
                                              role: 'doctor',
                                              email: email,
                                              branchID: branchID,
                                            );
                                            await db.updateDoctorWorkDays();
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
                })
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
                      LocaleKeys.schedule.tr(),
                      style: TextStyle(
                          fontSize: size.width * 0.05,
                          color: kPrimaryTextColor),
                    ),
                    SizedBox(width: size.width * 0.24),
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
