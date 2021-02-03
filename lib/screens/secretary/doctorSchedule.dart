import 'package:auto_size_text/auto_size_text.dart';
import 'package:clinic/components/lists_cards/workDays_list.dart';
import 'package:clinic/models/workDay.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:clinic/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_switch/flutter_switch.dart';

class DoctorSchedule extends StatefulWidget {
  @override
  _DoctorScheduleState createState() => _DoctorScheduleState();
}

class _DoctorScheduleState extends State<DoctorSchedule> {
  Map doctorData = {};
  List<bool> values = List.filled(7, false);
  List<WorkDay> workDays = [];
  bool status = true;
  @override
  Widget build(BuildContext context) {
    doctorData = ModalRoute.of(context).settings.arguments;
    // bool status = doctorData['status'];
    return StreamProvider<List<WorkDay>>.value(
      value: DatabaseService().getWorkDays(doctorData['docId']),
      child: Scaffold(
        backgroundColor: kPrimaryLightColor,
        body: Column(
          children: [
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 53),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          height: 40,
                          width: 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(
                                Icons.arrow_back,
                                color: kPrimaryLightColor,
                              ),
                              Text(
                                'BACK',
                                style: TextStyle(
                                    color: kPrimaryLightColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: AutoSizeText(
                          'Dr. ' + doctorData['fName'],
                          style: TextStyle(
                              fontSize: 55,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                          minFontSize: 30,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              child: FlutterSwitch(
                width: 125.0,
                height: 55.0,
                valueFontSize: 15,
                toggleSize: 30,
                value: status,
                borderRadius: 30.0,
                padding: 8.0,
                showOnOff: true,
                activeText: 'on',
                activeColor: kPrimaryLightColor,
                inactiveText: 'off',
                onToggle: (val) async {
                  if (status) {
                    await DatabaseService().updateDoctorStatus(
                        doctorID: doctorData['docId'], working: 1);
                  } else {
                    await DatabaseService().updateDoctorStatus(
                        doctorID: doctorData['docId'], working: 0);
                  }
                  setState(() {
                    status = val;
                  });
                },
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(53),
                      topRight: Radius.circular(53)),
                ),
                child: WorkDaysList(
                  doctorID: doctorData['docId'],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
