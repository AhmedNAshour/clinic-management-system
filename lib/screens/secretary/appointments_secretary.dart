import 'package:clinic/components/lists_cards/appointments_list_secretary.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppointmentsSecretary extends StatefulWidget {
  @override
  _AppointmentsSecretaryState createState() => _AppointmentsSecretaryState();
}

class _AppointmentsSecretaryState extends State<AppointmentsSecretary> {
  var textController = new TextEditingController();
  String search = '';
  bool showCancel = false;

  int selectedType = 0;
  List<String> appointmentTypes = [
    'Today',
    'Upcoming',
    'Past',
    'Cancelled',
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
          height: size.height * 0.1,
          width: double.infinity,
          color: kPrimaryColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Appointments',
                style: TextStyle(
                  fontSize: size.width * 0.06,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: size.width * 0.2),
              SvgPicture.asset(
                'assets/images/search.svg',
                color: Colors.white,
              ),
            ],
          ),
        ),
        Container(
          height: size.height * 0.12,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: appointmentTypes.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedType = index;
                  });
                },
                child: Container(
                  width: size.width * 0.35,
                  margin: EdgeInsets.symmetric(
                    vertical: size.height * 0.02,
                    horizontal: size.width * 0.02,
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: size.height * 0.02,
                    horizontal: size.width * 0.04,
                  ),
                  decoration: BoxDecoration(
                    color: selectedType == index ? kPrimaryColor : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: selectedType == index
                          ? Colors.transparent
                          : kPrimaryLightColor,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      appointmentTypes[index],
                      style: TextStyle(
                          color: selectedType == index
                              ? Colors.white
                              : kPrimaryLightColor,
                          fontSize: size.width * 0.05),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Expanded(
          child: Container(
            width: size.width * 0.9,
            child: AppointmentsListSecretary(search),
          ),
        ),
      ],
    );
  }
}
