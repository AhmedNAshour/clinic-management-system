import 'package:clinic/components/forms/rounded_button..dart';
import 'package:clinic/components/forms/search_input_field.dart';
import 'package:clinic/screens/shared/search_results/doctors_search_results.dart';
import 'package:flutter/material.dart';

class SearchDoctorsFormAdmin extends StatefulWidget {
  const SearchDoctorsFormAdmin({
    Key key,
    this.changeDoctorNameSearch,
    this.doctorNameSearch,
  }) : super(key: key);

  final Function changeDoctorNameSearch;
  final String doctorNameSearch;

  @override
  _SearchDoctorsFormAdminState createState() => _SearchDoctorsFormAdminState();
}

class _SearchDoctorsFormAdminState extends State<SearchDoctorsFormAdmin> {
  String doctorNameSearch;
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          SearchInputField(
            initialValue: widget.doctorNameSearch,
            labelText: 'Doctor Name',
            iconPath: 'assets/images/doctor.svg',
            obsecureText: false,
            hintText: 'Doctor name',
            onChanged: (val) {
              doctorNameSearch = val;
            },
          ),
          RoundedButton(
            text: 'SEARCH',
            press: () {
              widget.changeDoctorNameSearch(doctorNameSearch);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
