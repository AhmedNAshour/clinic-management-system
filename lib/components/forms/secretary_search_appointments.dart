import 'package:clinic/components/forms/rounded_button..dart';
import 'package:clinic/components/forms/search_input_field.dart';
import 'package:clinic/components/forms/text_field_container.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../screens/shared/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchAppointmentsForm extends StatefulWidget {
  const SearchAppointmentsForm({
    Key key,
    @required this.dateSearch,
    @required this.dateTextController,
    this.changeDateSearch,
    this.changeClientNumberSearch,
    this.changeClientNameSearch,
    this.changeDoctorNameSearch,
    this.doctorNameSearch,
    this.clientNameSearch,
    this.clientNumberSearch,
  }) : super(key: key);

  final String dateSearch;
  final TextEditingController dateTextController;
  final Function changeDateSearch;
  final Function changeClientNumberSearch;
  final Function changeClientNameSearch;
  final Function changeDoctorNameSearch;
  final String doctorNameSearch;
  final String clientNameSearch;
  final String clientNumberSearch;

  @override
  _SearchAppointmentsFormState createState() => _SearchAppointmentsFormState();
}

class _SearchAppointmentsFormState extends State<SearchAppointmentsForm> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        child: Column(
          children: [
            TextFieldContainer(
              child: TextFormField(
                onTap: () {
                  showDatePicker(
                    context: context,
                    initialDate: widget.dateSearch == ''
                        ? DateTime.now()
                        : DateTime.parse(widget.dateSearch),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  ).then((value) => setState(() {
                        if (value == null) {
                          widget.changeDateSearch('');
                          widget.dateTextController.text = '';
                          // showCancel =
                          //     false;
                        } else {
                          widget.changeDateSearch(
                              DateFormat('yyyy-MM-dd').format(value));
                          widget.dateTextController.text =
                              DateFormat('yyyy-MM-dd').format(value);
                          // showCancel =
                          //     true;
                        }
                      }));
                },
                controller: widget.dateTextController,
                // initialValue: widget.dateSearch,
                decoration: InputDecoration(
                  focusColor: kPrimaryColor,
                  labelStyle: TextStyle(
                    color: kPrimaryColor,
                  ),
                  labelText: 'Select Date',
                  icon: SvgPicture.asset('assets/images/date.svg'),
                ),
                onChanged: (val) {
                  widget.changeDateSearch(val);
                },
              ),
            ),
            SearchInputField(
              initialValue: widget.doctorNameSearch,
              labelText: 'Doctor Name',
              iconPath: 'assets/images/doctor.svg',
              obsecureText: false,
              hintText: 'Doctor name',
              onChanged: (val) {
                widget.changeDoctorNameSearch(val);
              },
            ),
            SearchInputField(
              initialValue: widget.clientNameSearch,
              labelText: 'Client Name',
              iconPath: 'assets/images/client.svg',
              obsecureText: false,
              hintText: 'Client name',
              onChanged: (val) {
                widget.changeClientNameSearch(val);
              },
            ),
            SearchInputField(
              initialValue: widget.clientNumberSearch,
              labelText: 'Client Number',
              iconPath: 'assets/images/client-num.svg',
              obsecureText: false,
              hintText: 'Client number',
              onChanged: (val) {
                widget.changeClientNumberSearch(val);
              },
            ),
            RoundedButton(
              text: 'SEARCH',
              press: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
