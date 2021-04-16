import 'package:clinic/components/lists_cards/doctor_card_Admin.dart';
import 'package:clinic/components/lists_cards/doctor_card_client.dart';
import 'package:clinic/components/lists_cards/doctor_card_secretary.dart';
import 'package:clinic/components/lists_cards/doctor_card_secretary_booking.dart';
import 'package:clinic/models/client.dart';
import 'package:clinic/models/doctor.dart';
import 'package:clinic/models/user.dart';
import 'package:clinic/screens/shared/search_results/noResults.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'doctor_card_client_booking.dart';

class DoctorList extends StatefulWidget {
  @override
  _DoctorListState createState() => _DoctorListState();
  Client client;
  String search = '';
  bool isClientBooking = false;
  DoctorList({String isSearch}) {
    this.search = isSearch;
  }
  DoctorList.booking({Client client, bool isClientBooking}) {
    this.client = client;
    this.isClientBooking = isClientBooking;
  }
}

class _DoctorListState extends State<DoctorList> {
  @override
  Widget build(BuildContext context) {
    final doctors = Provider.of<List<Doctor>>(context) ?? [];
    final userData = Provider.of<UserModel>(context);
    Size size = MediaQuery.of(context).size;
    if (widget.client != null || widget.isClientBooking) {
      return GridView.builder(
        clipBehavior: Clip.none,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: size.width * 0.9,
        ),
        itemCount: doctors.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              widget.isClientBooking
                  ? DoctorCardClientBooking(
                      doctor: doctors[index],
                    )
                  : DoctorCardSecBooking(
                      doctor: doctors[index],
                      client: widget.client,
                    ),
            ],
          );
        },
      );
    }
    if (widget.search == 'yes') {
      if (doctors.isNotEmpty) {
        return ListView.builder(
          itemCount: doctors.length,
          itemBuilder: (context, index) {
            return userData.role == 'client'
                ? DoctorCardCli(doctor: doctors[index])
                : userData.role == 'secretary'
                    ? DoctorCardSec(doctor: doctors[index])
                    : DoctorCardAdmin(doctor: doctors[index]);
          },
        );
      }
      return NoResults(
        text: 'No Doctors Found',
      );
    }
    return ListView.builder(
      itemCount: doctors.length,
      itemBuilder: (context, index) {
        return userData.role == 'client'
            ? DoctorCardCli(doctor: doctors[index])
            : userData.role == 'secretary'
                ? DoctorCardSec(doctor: doctors[index])
                : DoctorCardAdmin(doctor: doctors[index]);
      },
    );
  }
}
