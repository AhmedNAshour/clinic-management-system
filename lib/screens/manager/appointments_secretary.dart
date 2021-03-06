import 'package:clinic/components/forms/secretary_search_appointments.dart';
import 'package:clinic/components/lists_cards/appointments_list_secretary.dart';
import 'package:clinic/langs/locale_keys.g.dart';
import 'package:clinic/models/manager.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:clinic/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class AppointmentsSecretary extends StatefulWidget {
  @override
  _AppointmentsSecretaryState createState() => _AppointmentsSecretaryState();
}

class _AppointmentsSecretaryState extends State<AppointmentsSecretary> {
  var textController = new TextEditingController();
  String search = '';
  bool showCancel = false;
  String day = '';
  // DateFormat("yyyy-MM-dd").format(DateTime.now())
  int selectedType = 0;
  int status;
  String dateComparison;
  List<String> appointmentTypes = [
    'Today',
    'Upcoming',
    'Past',
    'Canceled',
  ];

  List<String> appointmentTypesAR = [
    'اليوم',
    'القادم',
    'السابق',
    'ملغى',
  ];

  int getStatus(int selectedType) {
    if (selectedType == 0 || selectedType == 1 || selectedType == 2) status = 1;
    if (selectedType == 3) status = 0;
    return status;
  }

  var dateTextController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final secretary = Provider.of<Manager>(context);

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
                LocaleKeys.appointments.tr(),
                style: TextStyle(
                  fontSize: size.width * 0.06,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: size.width * 0.2),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0)),
                    ),
                    builder: (context) {
                      return StatefulBuilder(builder:
                          (BuildContext context, StateSetter insideState) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                            vertical: size.height * 0.02,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(
                                    left: size.width * 0.02,
                                    right: size.width * 0.02,
                                    bottom: size.height * 0.01),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      width: size.height * 0.001,
                                      color: kPrimaryLightColor,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      LocaleKeys.search.tr(),
                                      style: TextStyle(
                                          fontSize: size.width * 0.05,
                                          color: kPrimaryTextColor),
                                    ),
                                    SizedBox(width: size.width * 0.28),
                                    IconButton(
                                      icon: Icon(
                                        Icons.close,
                                        color: kPrimaryTextColor,
                                        size: size.width * 0.085,
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              // SizedBox(
                              //   height: size.height * 0.02,
                              // ),
                              Container(
                                child: SearchAppointmentsForm(),
                              ),
                            ],
                          ),
                        );
                      });
                    },
                    isScrollControlled: true,
                  );
                },
                child: SvgPicture.asset(
                  'assets/images/search.svg',
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        Container(
          height: size.height * 0.1,
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
                      context.locale.toString() == 'en'
                          ? appointmentTypes[index]
                          : appointmentTypesAR[index],
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
            child: StreamProvider.value(
                value: DatabaseService().getAppointments(
                  status: getStatus(selectedType),
                  branch: secretary.branch,
                  dateComparison: appointmentTypes[selectedType],
                ),
                child: AppointmentsListSecretary(isSearch: 'no')),
          ),
        ),
      ],
    );
  }
}
