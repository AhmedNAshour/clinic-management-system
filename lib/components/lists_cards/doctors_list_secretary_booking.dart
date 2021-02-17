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
  Client client;
  DoctorListSecretaryBooking(Client client) {
    this.client = client;
  }
}

class _DoctorListSecretaryBookingState
    extends State<DoctorListSecretaryBooking> {
  @override
  Widget build(BuildContext context) {
    final doctors = Provider.of<List<Doctor>>(context) ?? [];
    return ListView.builder(
      itemCount: doctors.length,
      itemBuilder: (context, index) {
        return DoctorCardSec(doctor: doctors[index]);
      },
    );
  }
}
