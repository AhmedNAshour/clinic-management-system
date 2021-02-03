import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:clinic/models/appointment.dart';
import 'package:clinic/models/client.dart';
import 'package:clinic/models/user.dart';
import 'package:clinic/models/workDay.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:clinic/screens/shared/loading.dart';
import 'package:clinic/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class BookAppointment extends StatefulWidget {
  @override
  _BookAppointmentState createState() => _BookAppointmentState();
}

class _BookAppointmentState extends State<BookAppointment> {
  CalendarController _controller;
  TextStyle dayStyle(FontWeight fontWeight) {
    return TextStyle(color: Color(0xff30384c), fontWeight: FontWeight.bold);
  }

  Map doctorData = {};

  List offDays = [];
  List<DateTime> startTimes = [];
  List<DateTime> reserved = [];
  DateTime startTime;
  DateTime endTime;
  DateTime selectedDay = DateTime.now();
  int selectedWeekday = DateTime.now().weekday;
  int selectedTimeSlotIndex;
  String dummyStartDate = DateFormat("yyyy-MM-dd").format(DateTime.now());

  @override
  void initState() {
    super.initState();
    _controller = CalendarController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void generateAvailableTimeSlots(List<WorkDay> workDays) {
    workDays.forEach((element) {
      if (element.dayID == selectedWeekday) {
        String startTimeString =
            "${DateFormat("yyyy-MM-dd").format(selectedDay)} ${element.startHour}:${element.startMin}:00";
        String endTimeString =
            "${DateFormat("yyyy-MM-dd").format(selectedDay)} ${element.endHour}:${element.endMin}:00";
        startTime = DateTime.parse(startTimeString);
        endTime = DateTime.parse(endTimeString);

        while (!startTime.isAtSameMomentAs(endTime)) {
          startTimes.add(
            startTime,
          );
          startTime = startTime.add(Duration(minutes: 30));
        }
        List<DateTime> toRemove = [];
        for (int i = 0; i < startTimes.length; i++) {
          reserved.forEach((element) {
            if (element.isAtSameMomentAs(startTimes[i])) {
              toRemove.add(element);
            }
          });
        }
        for (int i = 0; i < toRemove.length; i++) {
          startTimes.remove(toRemove[i]);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    doctorData = ModalRoute.of(context).settings.arguments;
    Size size = MediaQuery.of(context).size;
    final user = Provider.of<MyUser>(context);

    return SafeArea(
      child: FutureBuilder(
        future: DatabaseService(uid: user.uid).getClient(),
        builder: (context, client) {
          if (client.hasData) {
            Client clientData = client.data;
            if (clientData.numAppointments != 0) {
              return StreamBuilder<List<WorkDay>>(
                  stream: DatabaseService().getWorkDays(doctorData['docId']),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<WorkDay> workDays = snapshot.data;
                      workDays.forEach(
                        (element) {
                          if (!element.enabled) offDays.add(element.dayID);
                        },
                      );
                      return StreamBuilder<List<Appointment>>(
                        stream: DatabaseService()
                            .getDoctorAppointmentsForSelectedDay(
                                doctorData['docId'], dummyStartDate),
                        builder: (context, snapshot2) {
                          if (snapshot2.hasData) {
                            List<Appointment> appointments = snapshot2.data;
                            reserved = [];
                            appointments.forEach((element) {
                              reserved.add(element.startTime);
                            });
                            startTimes = [];
                            generateAvailableTimeSlots(workDays);
                          } else {
                            print('no data');
                          }

                          return Scaffold(
                            body: Container(
                              child: Column(
                                children: [
                                  TableCalendar(
                                    enabledDayPredicate: (DateTime dateTime) {
                                      if (offDays.contains(dateTime.weekday)) {
                                        return false;
                                      } else {
                                        return true;
                                      }
                                    },
                                    startDay: DateTime.now(),
                                    calendarController: _controller,
                                    startingDayOfWeek: StartingDayOfWeek.sunday,
                                    calendarStyle: CalendarStyle(
                                      weekdayStyle: dayStyle(FontWeight.bold),
                                      weekendStyle: dayStyle(FontWeight.bold),
                                      selectedColor: kPrimaryColor,
                                      todayColor: kPrimaryLightColor,
                                      outsideDaysVisible: false,
                                    ),
                                    daysOfWeekStyle: DaysOfWeekStyle(
                                      weekdayStyle: TextStyle(
                                        color: Color(0xff30384c),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                      weekendStyle: TextStyle(
                                        color: Color(0xff30384c),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    headerStyle: HeaderStyle(
                                      centerHeaderTitle: true,
                                      formatButtonVisible: false,
                                      titleTextStyle: TextStyle(
                                        color: Color(0xff30384c),
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      leftChevronIcon: Icon(
                                        Icons.chevron_left,
                                        color: Color(0xff30384c),
                                      ),
                                      rightChevronIcon: Icon(
                                        Icons.chevron_right,
                                        color: Color(0xff30384c),
                                      ),
                                    ),
                                    onDaySelected: (DateTime day, List events,
                                        List holidays) {
                                      setState(() {
                                        selectedDay = _controller.selectedDay;
                                        selectedWeekday =
                                            _controller.selectedDay.weekday;
                                        startTimes = [];
                                        dummyStartDate =
                                            DateFormat("yyyy-MM-dd")
                                                .format(selectedDay);

                                        generateAvailableTimeSlots(workDays);
                                      });
                                    },
                                  ),
                                  Expanded(
                                    child: Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.only(
                                          right: 30, left: 30, top: 30),
                                      decoration: BoxDecoration(
                                        color: kPrimaryColor,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(53),
                                            topRight: Radius.circular(53)),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: kPrimaryLightColor,
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              height: 40,
                                              width: 100,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Icon(
                                                    Icons.arrow_back,
                                                    color: Colors.white,
                                                  ),
                                                  Text(
                                                    'BACK',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 20),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Row(
                                            children: [
                                              CircleAvatar(
                                                backgroundImage: AssetImage(
                                                    'assets/images/doctorPortraitCenter.jpg'),
                                                radius:
                                                    (80 / 100 * size.width) *
                                                        0.15,
                                              ),
                                              SizedBox(
                                                width: size.width * 0.04,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Dr. ' +
                                                        doctorData['fName'] +
                                                        ' ' +
                                                        doctorData['lName'],
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 25),
                                                  ),
                                                  Text(
                                                    doctorData['profession'],
                                                    style: TextStyle(
                                                        color:
                                                            kPrimaryLightColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Text(
                                            'Choose Your Slot',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Container(
                                            height: 40,
                                            child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: startTimes.length,
                                              itemBuilder: (context, index) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      selectedTimeSlotIndex =
                                                          index;
                                                    });
                                                  },
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10,
                                                            vertical: 8),
                                                    margin: EdgeInsets.only(
                                                        left: 10),
                                                    child: Center(
                                                      child: Text(
                                                        '${DateFormat.Hm().format(startTimes[index])}',
                                                        style: TextStyle(
                                                          color: index ==
                                                                  selectedTimeSlotIndex
                                                              ? Colors.white
                                                              : kPrimaryColor,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              18),
                                                      color: index ==
                                                              selectedTimeSlotIndex
                                                          ? kPrimaryLightColor
                                                          : Colors.white,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Center(
                                            child: Container(
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                child: FlatButton(
                                                  onPressed: () async {
                                                    DatabaseService(
                                                            uid: user.uid)
                                                        .addAppointment(
                                                      startTime: startTimes[
                                                          selectedTimeSlotIndex],
                                                      doctorID:
                                                          doctorData['docId'],
                                                      doctorFName:
                                                          doctorData['fName'],
                                                      doctorLName:
                                                          doctorData['lName'],
                                                      doctorToken:
                                                          doctorData['token'],
                                                      clientFName:
                                                          clientData.fName,
                                                      clientLName:
                                                          clientData.lName,
                                                      clientPhoneNumber:
                                                          clientData
                                                              .phoneNumber,
                                                      clientGender:
                                                          clientData.gender,
                                                      branch:
                                                          doctorData['branch'],
                                                      clientPicURL:
                                                          clientData.picURL ??
                                                              '',
                                                      doctorPicURL: doctorData[
                                                              'picURL'] ??
                                                          '',
                                                    );
                                                    DatabaseService
                                                        .updateNumAppointments(
                                                            numAppointments:
                                                                clientData
                                                                        .numAppointments -
                                                                    1,
                                                            documentID:
                                                                clientData.uid);
                                                    AwesomeDialog(
                                                        context: context,
                                                        headerAnimationLoop:
                                                            false,
                                                        dialogType:
                                                            DialogType.SUCCES,
                                                        animType: AnimType
                                                            .BOTTOMSLIDE,
                                                        body: Center(
                                                          child: Text(
                                                            'Appointment booked successfully',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 20),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ),
                                                        title: '',
                                                        desc: '',
                                                        onDissmissCallback:
                                                            () {},
                                                        btnOkOnPress: () {})
                                                      ..show();
                                                  },
                                                  child: Text(
                                                    'BOOK',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w900),
                                                  ),
                                                  color: kPrimaryLightColor,
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 20,
                                                      horizontal: 30),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return Loading();
                    }
                  });
            } else {
              return Scaffold(
                backgroundColor: kPrimaryColor,
                body: Container(
                  child: Center(
                    child: Text(
                      'You have no sessions left.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            }
          } else {
            return Loading();
          }
        },
      ),
    );
  }
}
