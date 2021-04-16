import 'package:clinic/components/forms/rounded_button..dart';
import 'package:clinic/components/forms/search_input_field.dart';
import 'package:clinic/screens/shared/search_results/doctors_search_results.dart';
import 'package:flutter/material.dart';

class SearchDoctorsForm extends StatefulWidget {
  const SearchDoctorsForm({
    Key key,
    this.changeDoctorNameSearch,
    this.doctorNameSearch,
  }) : super(key: key);

  final Function changeDoctorNameSearch;
  final String doctorNameSearch;

  @override
  _SearchDoctorsFormState createState() => _SearchDoctorsFormState();
}

class _SearchDoctorsFormState extends State<SearchDoctorsForm> {
  String doctorNameSearch;
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
              Navigator.pushNamed(context, DoctorsSearchResults.id, arguments: {
                'doctorName': doctorNameSearch,
              });
            },
          ),
        ],
      ),
    );
  }
}
