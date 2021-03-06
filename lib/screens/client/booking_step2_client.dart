import 'package:clinic/components/forms/rounded_button..dart';
import 'package:clinic/langs/locale_keys.g.dart';
import 'package:clinic/models/appointment.dart';
import 'package:clinic/models/client.dart';
import 'package:clinic/models/doctor.dart';
import 'package:clinic/models/user.dart';
import 'package:clinic/models/workDay.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:clinic/screens/shared/loading.dart';
import 'package:clinic/services/database.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ndialog/ndialog.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:easy_localization/easy_localization.dart';

class BookingStep2Client extends StatefulWidget {
  static const id = 'bookingStep2Client';

  @override
  _BookingStep2ClientState createState() => _BookingStep2ClientState();
}

class _BookingStep2ClientState extends State<BookingStep2Client> {
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
  String error = '';

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

        while (!startTime.isAtSameMomentAs(endTime) &&
            startTime.isAfter(DateTime.now())) {
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
    Doctor doctor = data['doctor'];
    Size size = MediaQuery.of(context).size;
    final user = Provider.of<AuthUser>(context);
    HttpsCallable notifyManagersAboutBooking =
        FirebaseFunctions.instance.httpsCallable(
      'secretaryBookingTrigger',
    );

    return StreamBuilder<List<WorkDay>>(
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
              stream: DatabaseService()
                  .getAppointments(doctorId: doctor.uid, day: dummyStartDate),
              builder: (context, snapshot2) {
                if (snapshot2.hasData) {
                  List<Appointment> appointments = snapshot2.data;
                  reserved = [];
                  appointments.forEach((element) {
                    reserved.add(element.startTime);
                  });
                  startTimes = [];
                  generateAvailableTimeSlots(workDays);
                }
                return StreamBuilder(
                  stream: DatabaseService(uid: user.uid).client,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      Client client = snapshot.data;

                      return SafeArea(
                        child: Scaffold(
                          body: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: size.width * 0.04),
                                height: size.height * 0.1,
                                width: double.infinity,
                                color: kPrimaryColor,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    BackButton(
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: size.width * 0.1),
                                    Text(
                                      LocaleKeys.bookAppointment.tr(),
                                      style: TextStyle(
                                        fontSize: size.width * 0.06,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: size.height * 0.02),
                              Text(
                                LocaleKeys.selectTimeSlot.tr(),
                                style: TextStyle(
                                  color: kPrimaryTextColor,
                                  fontSize: size.width * 0.05,
                                ),
                              ),
                              SizedBox(height: size.height * 0.04),
                              TableCalendar(
                                enabledDayPredicate: (DateTime dateTime) {
                                  if (offDays.contains(dateTime.weekday)) {
                                    return false;
                                  } else {
                                    return true;
                                  }
                                },
                                headerVisible: false,
                                startDay: DateTime.now(),
                                calendarController: _controller,
                                startingDayOfWeek: StartingDayOfWeek.sunday,
                                calendarStyle: CalendarStyle(
                                  weekdayStyle: dayStyle(FontWeight.bold),
                                  weekendStyle: dayStyle(FontWeight.bold),
                                  selectedColor: kPrimaryColor,
                                  todayColor: Colors.red,
                                  outsideDaysVisible: false,
                                ),
                                initialCalendarFormat: CalendarFormat.week,
                                availableCalendarFormats: const {
                                  CalendarFormat.week: '',
                                  CalendarFormat.month: '',
                                },
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
                              SizedBox(height: size.height * 0.02),
                              Expanded(
                                child: Column(
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: size.width * 0.02),
                                        child: GridView.builder(
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            childAspectRatio: 4 / 1.3,
                                          ),
                                          itemCount: startTimes.length,
                                          itemBuilder: (context, index) {
                                            return Column(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      selectedTimeSlotIndex =
                                                          index;
                                                    });
                                                  },
                                                  child: Card(
                                                    // margin: EdgeInsets.symmetric(
                                                    //     horizontal: size.width * 0.04),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10), // if you need this
                                                      side: BorderSide(
                                                        color: index ==
                                                                selectedTimeSlotIndex
                                                            ? kPrimaryColor
                                                            : Colors.grey
                                                                .withOpacity(
                                                                    0.2),
                                                        width: 1,
                                                      ),
                                                    ),
                                                    child: Container(
                                                      height:
                                                          size.height * 0.07,
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10,
                                                              vertical: 8),
                                                      child: Center(
                                                        child: Text(
                                                          '${DateFormat.jm().format(startTimes[index])} - ${DateFormat.jm().format(startTimes[index].add(Duration(minutes: 30)))}',
                                                          style: TextStyle(
                                                            color:
                                                                kPrimaryTextColor,
                                                            fontSize:
                                                                size.width *
                                                                    0.04,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: size.height * 0.02),
                                    Text(
                                      error,
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontSize: size.width * 0.04),
                                    ),
                                    SizedBox(height: size.height * 0.02),
                                    RoundedButton(
                                      press: () async {
                                        if (selectedTimeSlotIndex != null) {
                                          await DatabaseService()
                                              .addAppointment(
                                            clientId: client.uid,
                                            startTime: startTimes[
                                                selectedTimeSlotIndex],
                                            doctorID: doctor.uid,
                                            doctorFName: doctor.fName,
                                            doctorLName: doctor.lName,
                                            clientFName: client.fName,
                                            clientLName: client.lName,
                                            clientPhoneNumber:
                                                client.countryDialCode +
                                                    client.phoneNumber,
                                            clientGender: client.gender,
                                            branch: doctor.branch,
                                            clientPicURL: client.picURL ?? '',
                                            doctorPicURL: doctor.picURL ?? '',
                                            status: 1,
                                          );
                                          await DatabaseService(uid: client.uid)
                                              .addAppointmentNotifications(
                                            forClient: false,
                                            appointment: Appointment(
                                              clientID: client.uid,
                                              startTime: startTimes[
                                                  selectedTimeSlotIndex],
                                              doctorID: doctor.uid,
                                              doctorFName: doctor.fName,
                                              doctorLName: doctor.lName,
                                              clientFName: client.fName,
                                              clientLName: client.lName,
                                              clientPhoneNumber:
                                                  client.countryDialCode +
                                                      client.phoneNumber,
                                              clientGender: client.gender,
                                              branch: doctor.branch,
                                              clientPicURL: client.picURL ?? '',
                                              doctorPicURL: doctor.picURL ?? '',
                                            ),
                                            status: 1,
                                            type: 1,
                                          );
                                          await DatabaseService.updateClientRemainingSessions(
                                              numAppointments:
                                                  client.numAppointments - 1,
                                              documentID: client.uid);

                                          await notifyManagersAboutBooking
                                              .call(<String, dynamic>{
                                            'branch': doctor.branch,
                                            'doctorName': doctor.fName +
                                                ' ' +
                                                doctor.lName,
                                          });

                                          Navigator.popUntil(context,
                                              ModalRoute.withName('/'));
                                          await NDialog(
                                            dialogStyle: DialogStyle(
                                              backgroundColor: kPrimaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            content: Container(
                                              height: size.height * 0.5,
                                              width: size.width * 0.8,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    FontAwesomeIcons
                                                        .checkCircle,
                                                    color: Colors.white,
                                                    size: size.height * 0.125,
                                                  ),
                                                  SizedBox(
                                                    height: size.height * 0.05,
                                                  ),
                                                  Text(
                                                    LocaleKeys.appointmentBooked
                                                        .tr(),
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize:
                                                          size.height * 0.04,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ).show(context);
                                        } else {
                                          setState(() {
                                            error = LocaleKeys
                                                .notifcationSettings
                                                .tr();
                                          });
                                        }
                                      },
                                      text: LocaleKeys.book.tr(),
                                    ),
                                    SizedBox(height: size.height * 0.02),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return Loading();
                    }
                  },
                );
              },
            );
          } else {
            return Loading();
          }
        });
  }
}
