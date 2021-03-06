import 'package:clinic/components/lists_cards/workDays_list.dart';
import 'package:clinic/langs/locale_keys.g.dart';
import 'package:clinic/models/doctor.dart';
import 'package:clinic/models/workDay.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:clinic/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class DoctorSchedule extends StatefulWidget {
  static const id = 'doctorSchedule';
  @override
  _DoctorScheduleState createState() => _DoctorScheduleState();
}

class _DoctorScheduleState extends State<DoctorSchedule> {
  Doctor doctor;
  List<bool> values = List.filled(7, false);
  List<WorkDay> workDays = [];
  bool status = true;
  @override
  Widget build(BuildContext context) {
    doctor = ModalRoute.of(context).settings.arguments;
    Size size = MediaQuery.of(context).size;

    // bool status = doctorData['status'];
    return StreamProvider<List<WorkDay>>.value(
      value: DatabaseService().getWorkDays(doctor.uid),
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
                height: size.height * 0.1,
                width: double.infinity,
                color: kPrimaryColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    BackButton(
                      color: Colors.white,
                    ),
                    SizedBox(width: size.width * 0.22),
                    Text(
                      LocaleKeys.schedule.tr(),
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
                  width: size.width * 0.9,
                  child: WorkDaysList(
                    doctorID: doctor.uid,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
