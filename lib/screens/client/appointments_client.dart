import 'package:auto_size_text/auto_size_text.dart';
import 'package:clinic/components/lists_cards/appointments_list_client.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class AppointmentsClient extends StatefulWidget {
  @override
  _AppointmentsClientState createState() => _AppointmentsClientState();
}

class _AppointmentsClientState extends State<AppointmentsClient> {
  var textController = new TextEditingController();
  String search = '';
  bool showCancel = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Container(
            child: SvgPicture.asset(
              'assets/images/calendar2.svg',
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
                  AutoSizeText(
                    'Your Appointments',
                    style: TextStyle(
                        fontSize: 55,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                    minFontSize: 30,
                    maxLines: 1,
                  ),
                  SizedBox(
                    height: 10,
                  ),
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
                                hintText: "Search Appointments",
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
                    child: AppointmentsListClient(search),
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
