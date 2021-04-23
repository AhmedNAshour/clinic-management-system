import 'dart:io';
import 'package:clinic/components/forms/rounded_input_field.dart';
import 'package:clinic/langs/locale_keys.g.dart';
import 'package:clinic/models/branch.dart';
import 'package:clinic/models/manager.dart';
import 'package:clinic/screens/admin/mapEdit.dart';
import 'package:clinic/screens/shared/loading.dart';
import 'package:clinic/services/database.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ndialog/ndialog.dart';
import 'package:easy_localization/easy_localization.dart';

class EditBranch extends StatefulWidget {
  static final id = 'EditBranch';

  @override
  _EditBranchState createState() => _EditBranchState();
}

class _EditBranchState extends State<EditBranch> {
  // text field state
  String error = '';
  bool loading = false;
  Branch branch;
  String name = '';
  String address = '';
  String phoneNumber = '';
  CountryCode countryCode;
  String code;
  String manager = '';
  File newProfilePic;
  bool isInit = true;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if (isInit) {
      Map branchData = ModalRoute.of(context).settings.arguments;
      branch = branchData['branch'];
      name = branch.name;
      address = branch.address;
      phoneNumber = branch.phoneNumber;
      code = branch.countryCode;
      isInit = false;
    }

    return loading
        ? Loading()
        : SafeArea(
            child: Scaffold(
              body: StreamBuilder<List<Manager>>(
                stream: DatabaseService().getManagers(branch: branch.docID),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Manager> managers = snapshot.data;
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
                                'Edit branch',
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
                                      initialValue: name,
                                      obsecureText: false,
                                      icon: Icons.edit,
                                      hintText: LocaleKeys.branchName.tr(),
                                      onChanged: (val) {
                                        setState(() => name = val);
                                      },
                                      validator: (val) => val.isEmpty
                                          ? LocaleKeys.enterAName
                                          : null,
                                    ),
                                    RoundedInputField(
                                      initialValue: address,
                                      obsecureText: false,
                                      icon: Icons.edit,
                                      hintText: LocaleKeys.address.tr(),
                                      onChanged: (val) {
                                        setState(() => address = val);
                                      },
                                      validator: (val) => val.isEmpty
                                          ? LocaleKeys.enterAnAddress.tr()
                                          : null,
                                    ),
                                    SizedBox(
                                      height: size.height * 0.02,
                                    ),
                                    Container(
                                      width: size.width * 0.7,
                                      child: DropdownButtonFormField(
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                        ),
                                        hint: Text(
                                          LocaleKeys.selectManager.tr(),
                                        ),
                                        value: branch.managerID,
                                        items: managers.map((manager) {
                                          return DropdownMenuItem(
                                            value: manager.uid,
                                            child: Text(
                                              manager.fName +
                                                  ' ' +
                                                  manager.lName,
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (val) =>
                                            setState(() => manager = val),
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
                                            initialSelection: code,
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
                                              initialValue: phoneNumber,
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
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          width: size.width * 0.4,
                                          decoration: BoxDecoration(
                                            color: Color(0xFFDDF0FF),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: TextButton(
                                            onPressed: () {
                                              Navigator.pushNamed(
                                                  context, MapEdit.id,
                                                  arguments: {
                                                    'branch': Branch(
                                                      name: name,
                                                      address: address,
                                                      countryDialCode:
                                                          countryCode.dialCode,
                                                      countryCode:
                                                          countryCode.code,
                                                      phoneNumber: phoneNumber,
                                                      longitude:
                                                          branch.longitude,
                                                      latitude: branch.latitude,
                                                      managerID: manager != ''
                                                          ? manager
                                                          : branch.managerID,
                                                    ),
                                                    'oldName': branch.name,
                                                    'oldManager':
                                                        branch.managerID,
                                                  });
                                            },
                                            child: Text(
                                              LocaleKeys.editOnMap.tr(),
                                              style: TextStyle(
                                                color: kPrimaryColor,
                                                fontSize: size.height * 0.025,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: size.width * 0.4,
                                          decoration: BoxDecoration(
                                            color: kPrimaryColor,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: TextButton(
                                            onPressed: () async {
                                              await DatabaseService()
                                                  .editBranchData(
                                                oldName: branch.name,
                                                branchName: name,
                                                address: address,
                                                countryDialCode:
                                                    countryCode.dialCode,
                                                countryCode: countryCode.code,
                                                phoneNumber: phoneNumber,
                                                longitude: branch.longitude,
                                                latitude: branch.latitude,
                                                managerID: manager != ''
                                                    ? manager
                                                    : branch.managerID,
                                              );

                                              await DatabaseService()
                                                  .updateBranchManager(
                                                      oldManager:
                                                          branch.managerID,
                                                      newManager: manager,
                                                      branchName: name);

                                              Navigator.pop(context);
                                              await NDialog(
                                                dialogStyle: DialogStyle(
                                                  backgroundColor:
                                                      kPrimaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                content: Container(
                                                  height: size.height * 0.5,
                                                  width: size.width * 0.8,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        FontAwesomeIcons
                                                            .checkCircle,
                                                        color: Colors.white,
                                                        size:
                                                            size.height * 0.125,
                                                      ),
                                                      SizedBox(
                                                        height:
                                                            size.height * 0.05,
                                                      ),
                                                      Text(
                                                        'Branch Edited',
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
                                            },
                                            child: Text(
                                              LocaleKeys.edit.tr(),
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: size.height * 0.025,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
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
                  } else {
                    return Loading();
                  }
                },
              ),
            ),
          );
  }
}
