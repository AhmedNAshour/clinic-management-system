import 'package:clinic/components/lists_cards/doctor_card_Admin.dart';
import 'package:clinic/models/doctor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DoctorListAdmin extends StatefulWidget {
  @override
  _DoctorListAdminState createState() => _DoctorListAdminState();
}

class _DoctorListAdminState extends State<DoctorListAdmin> {
  @override
  Widget build(BuildContext context) {
    final doctors = Provider.of<List<Doctor>>(context) ?? [];
    // final userData = Provider.of<UserData>(context);
    return ListView.builder(
      itemCount: doctors.length,
      itemBuilder: (context, index) {
        return DoctorCardAdmin(doctor: doctors[index]);
      },
    );
  }
}
