import 'package:clinic/models/appointment.dart';
import 'package:clinic/screens/shared/search_results/noResults.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'appointment_card_doctor.dart';

class AppointmentsListDoctor extends StatefulWidget {
  @override
  _AppointmentsListDoctorState createState() => _AppointmentsListDoctorState();
  List<Appointment> searchList = <Appointment>[];
  String search = '';
  AppointmentsListDoctor(String search) {
    this.search = search;
  }
}

class _AppointmentsListDoctorState extends State<AppointmentsListDoctor> {
  @override
  Widget build(BuildContext context) {
    final appointments = Provider.of<List<Appointment>>(context) ?? [];

    appointments.sort((a, b) {
      var adate = a.startTime; //before -> var adate = a.expiry;
      var bdate = b.startTime; //before -> var bdate = b.expiry;
      return adate.compareTo(
          bdate); //to get the order other way just switch `adate & bdate`
    });

    if (widget.search == 'yes') {
      if (appointments.isNotEmpty) {
        return ListView.builder(
          itemCount: appointments.length,
          itemBuilder: (context, index) {
            return AppointmentCardDoctor(appointment: appointments[index]);
          },
        );
      }
      return NoResults(
        text: 'No Appointments Found',
      );
    } else {
      return ListView.builder(
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          return AppointmentCardDoctor(appointment: appointments[index]);
        },
      );
    }
  }
}
