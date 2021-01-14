import 'package:clinic/components/lists_cards/appointment_card.dart';
import 'package:clinic/models/appointment.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppointmentsListDoctor extends StatefulWidget {
  @override
  _AppointmentsListDoctorState createState() => _AppointmentsListDoctorState();
}

class _AppointmentsListDoctorState extends State<AppointmentsListDoctor> {
  @override
  Widget build(BuildContext context) {
    final appointments = Provider.of<List<Appointment>>(context) ?? [];
    // setState(() {
    //   appointments.sort((a, b) {
    //     var adate = a.startTime; //before -> var adate = a.expiry;
    //     var bdate = b.startTime; //before -> var bdate = b.expiry;
    //     return adate.compareTo(
    //         bdate); //to get the order other way just switch `adate & bdate`
    //   });
    // });

    return ListView.builder(
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        return AppointmentCard(appointment: appointments[index]);
      },
    );
  }
}
