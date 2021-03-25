import 'package:clinic/components/lists_cards/appointment_card.dart';
import 'package:clinic/models/appointment.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:clinic/screens/shared/search_results/noResults.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    Size size = MediaQuery.of(context).size;
    double screenHeight = size.height;
    double screenWidth = size.width;
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
