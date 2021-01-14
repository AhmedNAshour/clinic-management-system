import 'package:auto_size_text/auto_size_text.dart';
import 'package:clinic/components/lists_cards/doctors_list_secretary_booking.dart';
import 'package:clinic/models/client.dart';
import 'package:clinic/models/doctor.dart';
import 'package:clinic/models/user.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:clinic/screens/shared/loading.dart';
import 'package:clinic/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookingStep2 extends StatefulWidget {
  @override
  _BookingStep2State createState() => _BookingStep2State();
}

class _BookingStep2State extends State<BookingStep2> {
  var textController = new TextEditingController();
  String search = '';
  bool showCancel = false;
  bool loading = false;
  Map patientData = {};
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser>(context);
    print(user.uid);
    Size size = MediaQuery.of(context).size;
    patientData = ModalRoute.of(context).settings.arguments;
    Client client = Client(
      fName: patientData['fName'],
      lName: patientData['lName'],
      phoneNumber: patientData['phoneNumber'],
      numAppointments: patientData['numAppointments'],
      age: patientData['age'],
      gender: patientData['gender'],
      uid: patientData['uid'],
    );

    return FutureBuilder(
      future: DatabaseService(uid: user.uid).getSecretaryBranch(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print(snapshot.data);
          return StreamProvider<List<Doctor>>.value(
            value: DatabaseService().doctors,
            builder: (context, child) {
              return Scaffold(
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 53),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: AutoSizeText(
                                'Step 2: Choose Doctor',
                                style: TextStyle(
                                    fontSize: 55,
                                    fontWeight: FontWeight.bold,
                                    color: kPrimaryColor),
                                minFontSize: 20,
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Container(
                        padding: EdgeInsets.only(left: 30, right: 30, top: 30),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(53),
                              topRight: Radius.circular(53)),
                          color: kPrimaryLightColor,
                        ),
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: AutoSizeText(
                                  'Find a doctor for ${patientData['fName']} ${patientData['lName']}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                  minFontSize: 15,
                                  maxLines: 1,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Form(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(28),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Container(
                                        width: size.width * 0.5,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 10),
                                        child: TextFormField(
                                          controller: textController,
                                          decoration: InputDecoration(
                                            icon: Icon(
                                              Icons.search,
                                              color: kPrimaryColor,
                                            ),
                                            hintText: "Search Doctors",
                                            border: InputBorder.none,
                                          ),
                                          onChanged: (val) {
                                            setState(() => search = val);
                                          },
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.cancel,
                                          color: kPrimaryColor,
                                        ),
                                        enableFeedback: showCancel,
                                        onPressed: () {
                                          setState(() {
                                            search = '';
                                            textController.text = '';
                                            showCancel = false;
                                          });
                                        },
                                        // DateFormat('dd-MM-yyyy').format(value))
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Expanded(
                                child: DoctorListSecretaryBooking(
                                    search, snapshot.data, client),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        } else {
          print('No data');
          return Loading();
        }
      },
    );
  }
}
