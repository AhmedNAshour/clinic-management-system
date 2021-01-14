import 'package:auto_size_text/auto_size_text.dart';
import 'package:clinic/components/forms/rounded_button..dart';
import 'package:clinic/models/workDay.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:clinic/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:intl/intl.dart';
import 'package:time_range/time_range.dart';

class DayCard extends StatefulWidget {
  const DayCard({
    Key key,
    @required this.workDay,
    this.doctorID,
  }) : super(key: key);

  final String doctorID;
  final WorkDay workDay;

  @override
  _DayCardState createState() => _DayCardState();
}

class _DayCardState extends State<DayCard> {
  String startH = "";
  String startM = "";
  String endH = "";
  String endM = "";
  String workHours = "";
  DateTime dummyStart;
  DateTime dummyEnd;
  @override
  Widget build(BuildContext context) {
    if (widget.workDay.enabled) {
      workHours =
          "${widget.workDay.startHour}:${widget.workDay.startMin} ~ ${widget.workDay.endHour}:${widget.workDay.endMin}";
    } else {
      workHours = "Not a work day";
    }
    return GestureDetector(
      onTap: () {
        widget.workDay.enabled
            ? showModalBottomSheet(
                context: context,
                builder: (context) {
                  return FractionallySizedBox(
                    heightFactor: 0.5,
                    child: DraggableScrollableSheet(
                        initialChildSize: 1.0,
                        maxChildSize: 1.0,
                        minChildSize: 0.25,
                        builder: (BuildContext context,
                            ScrollController scrollController) {
                          return SingleChildScrollView(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 40),
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    'Edit ${widget.workDay.docID}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: kPrimaryColor),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  TimeRange(
                                      fromTitle: Text(
                                        'From',
                                        style: TextStyle(
                                            fontSize: 18, color: kPrimaryColor),
                                      ),
                                      toTitle: Text(
                                        'To',
                                        style: TextStyle(
                                            fontSize: 18, color: kPrimaryColor),
                                      ),
                                      titlePadding: 20,
                                      textStyle: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black87),
                                      activeTextStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                      borderColor: kPrimaryColor,
                                      backgroundColor: Colors.transparent,
                                      activeBackgroundColor: kPrimaryColor,
                                      firstTime: TimeOfDay(hour: 1, minute: 30),
                                      lastTime: TimeOfDay(hour: 5, minute: 00),
                                      timeStep: 30,
                                      timeBlock: 30,
                                      onRangeCompleted: (range) => setState(
                                            () {
                                              dummyStart = DateTime(
                                                  1969,
                                                  1,
                                                  1,
                                                  range.start.hour,
                                                  range.start.minute);

                                              dummyEnd = DateTime(
                                                  1969,
                                                  1,
                                                  1,
                                                  range.end.hour,
                                                  range.end.minute);

                                              startH = DateFormat.Hm()
                                                  .format(dummyStart)
                                                  .split(':')[0];

                                              startM = DateFormat.Hm()
                                                  .format(dummyStart)
                                                  .split(':')[1];

                                              endH = DateFormat.Hm()
                                                  .format(dummyEnd)
                                                  .split(':')[0];

                                              endM = DateFormat.Hm()
                                                  .format(dummyEnd)
                                                  .split(':')[1];
                                              print(startH);
                                              print(startM);
                                              print(endH);
                                              print(endM);
                                            },
                                          )),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  RoundedButton(
                                    press: () {
                                      DatabaseService.updateWorkDayHours(
                                        startHour: startH,
                                        startMin: startM,
                                        endHour: endH,
                                        endMin: endM,
                                        documentID: widget.workDay.docID,
                                        doctorID: widget.doctorID,
                                      );
                                    },
                                    text: 'Edit hours',
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  );
                },
                isScrollControlled: true)
            : null;
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 15),
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText(
                      (widget.workDay.docID).toUpperCase(),
                      style: TextStyle(color: kPrimaryLightColor, fontSize: 30),
                      minFontSize: 25,
                      maxLines: 1,
                    ),
                    AutoSizeText(
                      'Work hours: $workHours',
                      style: TextStyle(color: kPrimaryColor, fontSize: 20),
                      minFontSize: 15,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                child: FlutterSwitch(
                  width: 125.0,
                  height: 55.0,
                  valueFontSize: 15,
                  toggleSize: 30,
                  value: widget.workDay.enabled,
                  borderRadius: 30.0,
                  padding: 8.0,
                  showOnOff: true,
                  activeText: 'on',
                  activeColor: kPrimaryLightColor,
                  inactiveText: 'off',
                  onToggle: (val) {
                    setState(() {
                      widget.workDay.enabled = val;
                      if (widget.workDay.enabled) {
                        workHours =
                            "${widget.workDay.startHour}:${widget.workDay.startMin} ~ ${widget.workDay.endHour}:${widget.workDay.endMin}";
                      } else {
                        workHours = "Not a work day";
                      }
                      DatabaseService.updateWorkDayStatus(
                          working: widget.workDay.enabled,
                          doctorID: widget.doctorID,
                          documentID: widget.workDay.docID);
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
