import 'package:auto_size_text/auto_size_text.dart';
import 'package:clinic/components/lists_cards/appointments_list_admin.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppointmentsAdmin extends StatefulWidget {
  @override
  _AppointmentsAdminState createState() => _AppointmentsAdminState();
}

class _AppointmentsAdminState extends State<AppointmentsAdmin> {
  var textController = new TextEditingController();
  String search = '';
  bool showCancel = false;

  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 53),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: AutoSizeText(
                    'Appointments',
                    style: TextStyle(
                        fontSize: 55,
                        fontWeight: FontWeight.bold,
                        color: kPrimaryColor),
                    minFontSize: 30,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: Container(
            padding: EdgeInsets.only(left: 30, right: 30, top: 30),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(53), topRight: Radius.circular(53)),
              color: kPrimaryLightColor,
            ),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Form(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: size.width * 0.5,
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: TextFormField(
                              controller: textController,
                              decoration: InputDecoration(
                                icon: Icon(
                                  Icons.search,
                                  color: kPrimaryColor,
                                ),
                                hintText: "Search Products",
                                border: InputBorder.none,
                              ),
                              onChanged: (val) {
                                setState(() => search = val);
                              },
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.date_range,
                              color: kPrimaryColor,
                            ),
                            onPressed: () {
                              showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2020),
                                      lastDate: DateTime(2030))
                                  .then((value) => setState(() {
                                        if (value == null) {
                                          search = '';
                                          textController.text = '';
                                          showCancel = false;
                                        } else {
                                          search = DateFormat('dd-MM-yyyy')
                                              .format(value);
                                          textController.text =
                                              DateFormat('dd-MM-yyyy')
                                                  .format(value);
                                          showCancel = true;
                                        }
                                      }));
                            },
                            // DateFormat('dd-MM-yyyy').format(value))
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.cancel,
                              color: kPrimaryColor,
                            ),
                            enableFeedback: showCancel,
                            onPressed: () {
                              setState(() {
                                search = '';
                                textController.text = '';
                                showCancel = false;
                              });
                            },
                            // DateFormat('dd-MM-yyyy').format(value))
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: AppointmentsListAdmin(search),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
