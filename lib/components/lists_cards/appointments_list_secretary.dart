import 'package:clinic/components/lists_cards/appointment_card.dart';
import 'package:clinic/models/appointment.dart';
import 'package:clinic/screens/shared/search_results/noResults.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppointmentsListSecretary extends StatefulWidget {
  @override
  _AppointmentsListSecretaryState createState() =>
      _AppointmentsListSecretaryState();
  List<Appointment> searchList = <Appointment>[];
  String search = '';
  Function updateNumResultsFound;
  AppointmentsListSecretary(
      {String isSearch, Function newUpdateNumResultsFound}) {
    search = isSearch;
    updateNumResultsFound = newUpdateNumResultsFound;
  }
}

class _AppointmentsListSecretaryState extends State<AppointmentsListSecretary> {
  @override
  Widget build(BuildContext context) {
    List<Appointment> appointments =
        Provider.of<List<Appointment>>(context) ?? [];

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
            return AppointmentCard(appointment: appointments[index]);
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
          return AppointmentCard(appointment: appointments[index]);
        },
      );
    }
  }
}
