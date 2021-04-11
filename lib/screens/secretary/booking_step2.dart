import 'package:clinic/components/lists_cards/doctors_list.dart';
import 'package:clinic/models/client.dart';
import 'package:clinic/models/doctor.dart';
import 'package:clinic/models/user.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:clinic/screens/shared/loading.dart';
import 'package:clinic/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookingStep2 extends StatefulWidget {
  static const id = 'bookingStep2';

  @override
  _BookingStep2State createState() => _BookingStep2State();
}

class _BookingStep2State extends State<BookingStep2> {
  var textController = new TextEditingController();
  String search = '';
  bool showCancel = false;
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser>(context);
    Size size = MediaQuery.of(context).size;
    Client client = ModalRoute.of(context).settings.arguments;

    return FutureBuilder(
      future: DatabaseService(uid: user.uid).getSecretaryBranch(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          String secretaryBranch = snapshot.data;
          return SafeArea(
            child: Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: size.width * 0.04),
                      height: size.height * 0.1,
                      width: double.infinity,
                      color: kPrimaryColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          BackButton(
                            color: Colors.white,
                          ),
                          SizedBox(width: size.width * 0.1),
                          Text(
                            'Book Appointment',
                            style: TextStyle(
                              fontSize: size.width * 0.06,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                    Text(
                      'Please select a doctor for:',
                      style: TextStyle(
                        color: kPrimaryTextColor,
                        fontSize: size.width * 0.05,
                      ),
                    ),
                    Text(
                      client.gender == 'male'
                          ? 'Mr. ${client.fName} ${client.lName}'
                          : 'Mrs. ${client.fName} ${client.lName}',
                      style: TextStyle(
                        color: kPrimaryTextColor,
                        fontSize: size.width * 0.05,
                      ),
                    ),
                    SizedBox(height: size.height * 0.1),
                    Container(
                      height: size.height * 0.7,
                      child: MultiProvider(
                        providers: [
                          StreamProvider<List<Doctor>>.value(
                            value: DatabaseService()
                                .getDoctorsBySearch(secretaryBranch, ''),
                          ),
                          StreamProvider<UserData>.value(
                            value: DatabaseService(uid: user.uid).userData,
                          ),
                        ],
                        child: DoctorList.booking(
                          client: client,
                          isClientBooking: false,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return Loading();
        }
      },
    );
  }
}
