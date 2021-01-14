import 'package:auto_size_text/auto_size_text.dart';
import 'package:clinic/components/lists_cards/doctors_list_client.dart';
import 'package:clinic/models/branch.dart';
import 'package:clinic/models/user.dart';
import 'package:clinic/screens/client/search_field.dart';
import 'package:clinic/screens/shared/loading.dart';
import 'package:clinic/services/auth.dart';
import 'package:clinic/services/database.dart';
import 'package:flutter/material.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class ClientHome extends StatefulWidget {
  @override
  _ClientHomeState createState() => _ClientHomeState();
}

class _ClientHomeState extends State<ClientHome> {
  String branchId = '';
  var textController = new TextEditingController();
  String search = '';
  bool showCancel = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final AuthService _auth = AuthService();
    final user = Provider.of<UserData>(context);

    return user != null
        ? FutureBuilder(
            future: DatabaseService(uid: user.uid).getClientRemainingSessions(),
            builder: (context, numAppointments) {
              if (numAppointments.hasData) {
                return StreamBuilder<List<Branch>>(
                    stream: DatabaseService().branches,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<Branch> branches = snapshot.data;
                        if (branches.length != 0) {
                          if (branchId == '') {
                            branchId = '';
                          }
                        }
                        return Container(
                          width: double.infinity,
                          color: kPrimaryColor,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  padding: EdgeInsets.only(
                                      top: size.height * 0.1,
                                      left: 30,
                                      right: 30),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          InkWell(
                                            onTap: () async {
                                              await _auth.signOut();
                                            },
                                            child: Text(
                                              'Sign out',
                                              style: TextStyle(
                                                  color: kPrimaryLightColor,
                                                  fontSize: 14),
                                            ),
                                          ),
                                          Text(
                                            'Hello, ${user.fName}',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 38,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        numAppointments.data != 0
                                            ? 'You have ${numAppointments.data} sessions left. Find a doctor below'
                                            : 'You have ${numAppointments.data} sessions left. Please contact a secretary',
                                        style: TextStyle(
                                            color: kPrimaryLightColor,
                                            fontSize: 14),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        'Select a branch',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                      SizedBox(height: 10),
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
                                          items: branches.map((branch) {
                                            return DropdownMenuItem(
                                              value: branch.docID,
                                              child: Text('${branch.name}'),
                                            );
                                          }).toList(),
                                          onChanged: (val) => setState(() {
                                            branchId = val;
                                          }),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  )),
                              Expanded(
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 30),
                                  decoration: BoxDecoration(
                                    color: kPrimaryLightColor,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(53),
                                        topRight: Radius.circular(53)),
                                  ),
                                  child: Column(
                                    children: [
                                      // Form(
                                      //   child: Container(
                                      //     decoration: BoxDecoration(
                                      //       color: Colors.white,
                                      //       borderRadius:
                                      //           BorderRadius.circular(28),
                                      //     ),
                                      //     child: Row(
                                      //       mainAxisAlignment:
                                      //           MainAxisAlignment.spaceEvenly,
                                      //       children: <Widget>[
                                      //         Container(
                                      //           width: size.width * 0.5,
                                      //           margin: EdgeInsets.symmetric(
                                      //               horizontal: 10,
                                      //               vertical: 10),
                                      //           child: TextFormField(
                                      //             controller: textController,
                                      //             decoration: InputDecoration(
                                      //               icon: Icon(
                                      //                 Icons.search,
                                      //                 color: kPrimaryColor,
                                      //               ),
                                      //               hintText: "Search Doctors",
                                      //               border: InputBorder.none,
                                      //             ),
                                      //             onChanged: (val) {
                                      //               setState(
                                      //                   () => search = val);
                                      //             },
                                      //           ),
                                      //         ),
                                      //         IconButton(
                                      //           icon: Icon(
                                      //             Icons.cancel,
                                      //             color: kPrimaryColor,
                                      //           ),
                                      //           enableFeedback: showCancel,
                                      //           onPressed: () {
                                      //             setState(() {
                                      //               search = '';
                                      //               textController.text = '';
                                      //               showCancel = false;
                                      //             });
                                      //           },
                                      //           // DateFormat('dd-MM-yyyy').format(value))
                                      //         ),
                                      //       ],
                                      //     ),
                                      //   ),
                                      // ),
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          'Doctors in selected branch: ',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Expanded(
                                        child: branchId == ''
                                            ? Center(
                                                child: AutoSizeText(
                                                  'PLEASE SELECT A BRANCH',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 50,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                  minFontSize: 15,
                                                  maxLines: 1,
                                                ),
                                              )
                                            : DoctorListClient(
                                                search, branchId),
                                      ),
                                    ],
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
              } else {
                return Loading();
              }
            },
          )
        : Loading();
  }
}
