import 'package:clinic/components/lists_cards/doctor_card_client.dart';
import 'package:clinic/models/doctor.dart';
import 'package:clinic/models/user.dart';
import 'package:clinic/screens/shared/loading.dart';
import 'package:clinic/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'doctor_card_secretary.dart';

class DoctorListClient extends StatefulWidget {
  @override
  _DoctorListClientState createState() => _DoctorListClientState();

  String branchId;
  String search = '';
  List<Doctor> searchList = <Doctor>[];
  DoctorListClient(String search, branch) {
    this.branchId = branch;
    this.search = search;
  }
}

class _DoctorListClientState extends State<DoctorListClient> {
  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserData>(context);
    return StreamBuilder<Object>(
        stream: DatabaseService().getDoctorsBybranch(widget.branchId),
        builder: (context, snapshot) {
          List<Doctor> doctors = snapshot.data;
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: doctors.length,
              itemBuilder: (context, index) {
                if (doctors[index].status != 0) {
                  return userData.role == 'client'
                      ? DoctorCardCli(doctor: doctors[index])
                      : DoctorCardSec(doctor: doctors[index]);
                }
              },
            );
          } else {
            return Loading();
          }
        });
  }
}
