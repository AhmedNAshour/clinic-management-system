import 'package:clinic/components/lists_cards/appointment_card.dart';
import 'package:clinic/models/appointment.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AppointmentsListSecretary extends StatefulWidget {
  @override
  _AppointmentsListSecretaryState createState() =>
      _AppointmentsListSecretaryState();
  List<Appointment> searchList = <Appointment>[];
  String search = '';
  AppointmentsListSecretary(String search) {
    this.search = search;
  }
}

class _AppointmentsListSecretaryState extends State<AppointmentsListSecretary> {
  @override
  Widget build(BuildContext context) {
    List<Appointment> appointments =
        Provider.of<List<Appointment>>(context) ?? [];
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

    if (widget.search == "") {
      appointments = appointments
          .where((element) => element.endTime.isAfter(DateTime.now()))
          .toList();
      appointments.sort((a, b) {
        var adate = a.startTime; //before -> var adate = a.expiry;
        var bdate = b.startTime; //before -> var bdate = b.expiry;
        return adate.compareTo(
            bdate); //to get the order other way just switch `adate & bdate`
      });

      return ListView.builder(
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          return AppointmentCard(appointment: appointments[index]);
        },
      );
    } else {
      return ListView.builder(
        itemCount: widget.searchList.length,
        itemBuilder: (context, index) {
          return AppointmentCard(appointment: widget.searchList[index]);
        },
      );
    }
  }
}
