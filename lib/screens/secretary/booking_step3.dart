import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:clinic/models/appointment.dart';
import 'package:clinic/models/client.dart';
import 'package:clinic/models/doctor.dart';
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

class BookingStep3 extends StatefulWidget {
  @override
  _BookingStep3State createState() => _BookingStep3State();
}

class _BookingStep3State extends State<BookingStep3> {
  CalendarController _controller;
  TextStyle dayStyle(FontWeight fontWeight) {
    return TextStyle(color: Color(0xff30384c), fontWeight: FontWeight.bold);
  }

  Map data = {};

  int _currentIndex = 0;
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
    data = ModalRoute.of(context).settings.arguments;
    Doctor doctor = Doctor(
      fName: data['doctorFName'],
      lName: data['doctorLName'],
      proffesion: data['doctorProfession'],
      uid: data['doctorUID'],
    );

    Client client = Client(
      fName: data['clientFName'],
      lName: data['clientLName'],
      uid: data['clientUID'],
      numAppointments: data['clientNumAppointments'],
      phoneNumber: data['clientPhoneNumber'],
      gender: data['clientGender'],
    );
    Size size = MediaQuery.of(context).size;
    final user = Provider.of<MyUser>(context);

    return SafeArea(
      child: StreamBuilder<List<WorkDay>>(
          stream: DatabaseService().getWorkDays(doctor.uid),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<WorkDay> workDays = snapshot.data;
              workDays.forEach(
                (element) {
                  if (!element.enabled) offDays.add(element.dayID);
                },
              );
              return StreamBuilder<List<Appointment>>(
                stream: DatabaseService().getDoctorAppointmentsForSelectedDay(
                    doctor.uid, dummyStartDate),
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
                            onDaySelected:
                                (DateTime day, List events, List holidays) {
                              setState(() {
                                selectedDay = _controller.selectedDay;
                                selectedWeekday =
                                    _controller.selectedDay.weekday;
                                startTimes = [];
                                dummyStartDate = DateFormat("yyyy-MM-dd")
                                    .format(selectedDay);

                                generateAvailableTimeSlots(workDays);
                              });
                            },
                          ),
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              padding:
                                  EdgeInsets.only(right: 30, left: 30, top: 30),
                              decoration: BoxDecoration(
                                color: kPrimaryColor,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(53),
                                    topRight: Radius.circular(53)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: kPrimaryLightColor,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      height: 40,
                                      width: 100,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(
                                            Icons.arrow_back,
                                            color: Colors.white,
                                          ),
                                          Text(
                                            'BACK',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
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
                                        radius: (80 / 100 * size.width) * 0.15,
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
                                                doctor.fName +
                                                ' ' +
                                                doctor.lName,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 25),
                                          ),
                                          Text(
                                            doctor.proffesion,
                                            style: TextStyle(
                                                color: kPrimaryLightColor,
                                                fontWeight: FontWeight.bold,
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
                                              selectedTimeSlotIndex = index;
                                            });
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 8),
                                            margin: EdgeInsets.only(left: 10),
                                            child: Center(
                                              child: Text(
                                                '${DateFormat.Hm().format(startTimes[index])}',
                                                style: TextStyle(
                                                  color: index ==
                                                          selectedTimeSlotIndex
                                                      ? Colors.white
                                                      : kPrimaryColor,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                              color:
                                                  index == selectedTimeSlotIndex
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
                                  Align(
                                    alignment: Alignment.center,
                                    child: AutoSizeText(
                                      'Book for ${client.fName} ${client.lName}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                      ),
                                      minFontSize: 15,
                                      maxLines: 1,
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Container(
                                        width: 150,
                                        margin: EdgeInsets.all(10),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          child: FlatButton(
                                            onPressed: () async {
                                              DatabaseService(uid: user.uid)
                                                  .addAppointmentSecretary(
                                                      startTime: startTimes[
                                                          selectedTimeSlotIndex],
                                                      doctorID: doctor.uid,
                                                      doctorFName: doctor.fName,
                                                      doctorLName: doctor.lName,
                                                      clientFName: client.fName,
                                                      clientLName: client.lName,
                                                      clientPhoneNumber:
                                                          client.phoneNumber,
                                                      clientGender:
                                                          client.gender,
                                                      clientID: client.uid);
                                              DatabaseService
                                                  .updateNumAppointments(
                                                      numAppointments: client
                                                              .numAppointments -
                                                          1,
                                                      documentID: client.uid);
                                              AwesomeDialog(
                                                  context: context,
                                                  headerAnimationLoop: false,
                                                  dialogType: DialogType.SUCCES,
                                                  animType:
                                                      AnimType.BOTTOMSLIDE,
                                                  body: Center(
                                                    child: Text(
                                                      'Appointment booked successfully',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                  title: '',
                                                  desc: '',
                                                  onDissmissCallback: () {
                                                    Navigator.popUntil(
                                                        context,
                                                        ModalRoute.withName(
                                                            '/'));
                                                  },
                                                  btnOkOnPress: () {
                                                    Navigator.popUntil(
                                                        context,
                                                        ModalRoute.withName(
                                                            '/'));
                                                  })
                                                ..show();
                                            },
                                            child: Text(
                                              'BOOK',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w900),
                                            ),
                                            color: kPrimaryLightColor,
                                            padding: EdgeInsets.symmetric(
                                                vertical: 20, horizontal: 30),
                                          ),
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
          }),
    );
  }
}
