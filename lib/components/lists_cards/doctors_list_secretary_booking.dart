import 'package:clinic/models/client.dart';
import 'package:clinic/models/doctor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'doctor_card_secretary.dart';

class DoctorListSecretaryBooking extends StatefulWidget {
  @override
  _DoctorListSecretaryBookingState createState() =>
      _DoctorListSecretaryBookingState();
  List<Doctor> searchList = <Doctor>[];
  String search = '';
  String branch;
  Client client;
  DoctorListSecretaryBooking(String search, branch, Client client) {
    this.search = search;
    this.branch = branch;
    this.client = client;
  }
}

class _DoctorListSecretaryBookingState
    extends State<DoctorListSecretaryBooking> {
  @override
  Widget build(BuildContext context) {
    final doctors = Provider.of<List<Doctor>>(context) ?? [];
    setState(() {
      //print(DateFormat('dd-MM-yyyy').format(salesLogsList[0].date.toDate()));
      widget.searchList = doctors
          .where((element) => (element.fName
                  .toLowerCase()
                  .contains(widget.search.toLowerCase()) ||
              element.lName
                  .toLowerCase()
                  .contains(widget.search.toLowerCase()) ||
              element.phoneNumber.contains(widget.search) &&
                  element.branch == widget.branch))
          .toList();
    });
    if (widget.search == null) {
      return ListView.builder(
        itemCount: doctors.length,
        itemBuilder: (context, index) {
          return DoctorCardSec(doctor: doctors[index]);
        },
      );
    } else {
      return ListView.builder(
        itemCount: widget.searchList.length,
        itemBuilder: (context, index) {
          return DoctorCardSec(doctor: widget.searchList[index]);
        },
      );
    }
  }
}
