import 'package:clinic/components/lists_cards/doctor_card_client.dart';
import 'package:clinic/components/lists_cards/doctor_card_secretary.dart';
import 'package:clinic/components/lists_cards/doctor_card_secretary_booking.dart';
import 'package:clinic/models/client.dart';
import 'package:clinic/models/doctor.dart';
import 'package:clinic/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DoctorList extends StatefulWidget {
  @override
  _DoctorListState createState() => _DoctorListState();
  Client client;
  DoctorList();
  DoctorList.booking(Client client) {
    this.client = client;
  }
}

class _DoctorListState extends State<DoctorList> {
  @override
  Widget build(BuildContext context) {
    final doctors = Provider.of<List<Doctor>>(context) ?? [];
    final userData = Provider.of<UserData>(context);
    Size size = MediaQuery.of(context).size;
    if (widget.client != null) {
      return GridView.builder(
        clipBehavior: Clip.none,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: size.width * 0.9,
        ),
        itemCount: doctors.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              DoctorCardSecBooking(
                doctor: doctors[index],
                client: widget.client,
              ),
            ],
          );
        },
      );
    }
    return ListView.builder(
      itemCount: doctors.length,
      itemBuilder: (context, index) {
        return userData.role == 'client'
            ? DoctorCardCli(doctor: doctors[index])
            : DoctorCardSec(doctor: doctors[index]);
      },
    );
  }
}
