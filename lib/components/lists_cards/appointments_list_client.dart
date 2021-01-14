import 'package:clinic/components/lists_cards/appointment_card.dart';
import 'package:clinic/components/lists_cards/appointment_card_client.dart';
import 'package:clinic/models/appointment.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AppointmentsListClient extends StatefulWidget {
  @override
  _AppointmentsListClientState createState() => _AppointmentsListClientState();
  List<Appointment> searchList = List<Appointment>();
  String search = '';
  AppointmentsListClient(String search) {
    this.search = search;
  }
}

class _AppointmentsListClientState extends State<AppointmentsListClient> {
  @override
  Widget build(BuildContext context) {
    final appointments = Provider.of<List<Appointment>>(context) ?? [];
    setState(() {
      //print(DateFormat('dd-MM-yyyy').format(salesLogsList[0].date.toDate()));
      widget.searchList = appointments
          .where((element) => (element.clientFName
                  .toLowerCase()
                  .contains(widget.search.toLowerCase()) ||
              element.doctorFName
                  .toLowerCase()
                  .contains(widget.search.toLowerCase()) ||
              DateFormat('dd-MM-yyyy')
                  .format(element.startTime)
                  .contains(widget.search)))
          .toList();
      widget.searchList.sort((a, b) {
        var adate = a.startTime; //before -> var adate = a.expiry;
        var bdate = b.startTime; //before -> var bdate = b.expiry;
        return adate.compareTo(
            bdate); //to get the order other way just switch `adate & bdate`
      });
    });
    if (widget.search == null) {
      return ListView.builder(
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          return AppointmentCardClient(appointment: appointments[index]);
        },
      );
    } else {
      return ListView.builder(
        itemCount: widget.searchList.length,
        itemBuilder: (context, index) {
          return AppointmentCardClient(appointment: widget.searchList[index]);
        },
      );
    }
  }
}
