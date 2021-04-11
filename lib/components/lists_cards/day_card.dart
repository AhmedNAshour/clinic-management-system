import 'package:clinic/components/forms/rounded_button..dart';
import 'package:clinic/models/workDay.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:clinic/screens/shared/stringManipulation.dart';
import 'package:clinic/services/database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:time_range/time_range.dart';

class WorkdayCard extends StatefulWidget {
  const WorkdayCard({
    Key key,
    @required this.workDay,
    this.doctorID,
  }) : super(key: key);

  final String doctorID;
  final WorkDay workDay;

  @override
  _WorkdayCardState createState() => _WorkdayCardState();
}

class _WorkdayCardState extends State<WorkdayCard> {
  String startH = "";
  String startM = "";
  String endH = "";
  String endM = "";
  String workHours = "";
  DateTime dummyStart;
  DateTime dummyEnd;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    if (widget.workDay.enabled) {
      workHours =
          "${widget.workDay.startHour}:${widget.workDay.startMin} - ${widget.workDay.endHour}:${widget.workDay.endMin}";
    } else {
      workHours = "Not a work day";
    }
    return Container(
      margin: EdgeInsets.only(bottom: size.height * 0.02),
      padding: EdgeInsets.all(size.width * 0.01),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color(0xFFF0F0F0),
      ),
      child: SwitchListTile(
        tileColor: Color(0xFFF0F0F0),
        activeColor: kPrimaryColor,
        value: widget.workDay.enabled,
        title: Text(
          StringManipulation().convertToTitleCase(widget.workDay.docID),
          style:
              TextStyle(color: kPrimaryTextColor, fontSize: size.width * 0.06),
        ),
        subtitle: Text(
          '$workHours',
          style:
              TextStyle(color: kPrimaryTextColor, fontSize: size.width * 0.04),
        ),
        onChanged: (value) {
          setState(() {
            widget.workDay.enabled = value;
            if (widget.workDay.enabled) {
              workHours =
                  "${widget.workDay.startHour}:${widget.workDay.startMin} ~ ${widget.workDay.endHour}:${widget.workDay.endMin}";
              showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0)),
                  ),
                  builder: (context) {
                    return SingleChildScrollView(
                      child: StatefulBuilder(builder:
                          (BuildContext context, StateSetter insideState) {
                        return Container(
                          padding: EdgeInsets.only(
                              top: size.height * 0.02,
                              bottom: size.height * 0.04),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(
                                    left: size.width * 0.02,
                                    right: size.width * 0.02,
                                    bottom: size.height * 0.01),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Working Hours',
                                      style: TextStyle(
                                          fontSize: size.width * 0.05,
                                          color: kPrimaryTextColor),
                                    ),
                                    SizedBox(width: size.width * 0.2),
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
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                              TimeRange(
                                fromTitle: Text(
                                  'From',
                                  style: TextStyle(
                                      fontSize: size.width * 0.05,
                                      color: kPrimaryTextColor),
                                ),
                                toTitle: Text(
                                  'To',
                                  style: TextStyle(
                                      fontSize: size.width * 0.05,
                                      color: kPrimaryTextColor),
                                ),
                                titlePadding: size.width * 0.02,
                                textStyle: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: kPrimaryTextColor),
                                activeTextStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                                borderColor: kPrimaryLightColor,
                                backgroundColor: Colors.transparent,
                                activeBackgroundColor: kPrimaryColor,
                                //TODO: Set according to branch working hours
                                firstTime: TimeOfDay(hour: 0, minute: 00),
                                lastTime: TimeOfDay(hour: 23, minute: 00),
                                timeStep: 30,
                                timeBlock: 30,
                                onRangeCompleted: (range) => setState(
                                  () {
                                    dummyStart = DateTime(1969, 1, 1,
                                        range.start.hour, range.start.minute);

                                    dummyEnd = DateTime(1969, 1, 1,
                                        range.end.hour, range.end.minute);

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
                                  },
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.04,
                              ),
                              RoundedButton(
                                text: 'EDIT HOURS',
                                press: () async {
                                  await DatabaseService.updateWorkDayHours(
                                    startHour: startH,
                                    startMin: startM,
                                    endHour: endH,
                                    endMin: endM,
                                    documentID: widget.workDay.docID,
                                    doctorID: widget.doctorID,
                                  );
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        );
                      }),
                    );
                  });
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
    );
  }
}

// GestureDetector(
//       onTap: () {
//         widget.workDay.enabled
//             ? showModalBottomSheet(
//                 context: context,
//                 builder: (context) {
//                   return FractionallySizedBox(
//                     heightFactor: 0.5,
//                     child: DraggableScrollableSheet(
//                         initialChildSize: 1.0,
//                         maxChildSize: 1.0,
//                         minChildSize: 0.25,
//                         builder: (BuildContext context,
//                             ScrollController scrollController) {
//                           return SingleChildScrollView(
//                             child: Container(
//                               padding: EdgeInsets.symmetric(
//                                   horizontal: 20, vertical: 40),
//                               child: Column(
//                                 children: <Widget>[
//                                   Text(
//                                     'Edit ${widget.workDay.docID}',
//                                     style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 20,
//                                         color: kPrimaryColor),
//                                   ),
//                                   SizedBox(
//                                     height: 20,
//                                   ),
//                                   TimeRange(
//                                       fromTitle: Text(
//                                         'From',
//                                         style: TextStyle(
//                                             fontSize: 18, color: kPrimaryColor),
//                                       ),
//                                       toTitle: Text(
//                                         'To',
//                                         style: TextStyle(
//                                             fontSize: 18, color: kPrimaryColor),
//                                       ),
//                                       titlePadding: 20,
//                                       textStyle: TextStyle(
//                                           fontWeight: FontWeight.normal,
//                                           color: Colors.black87),
//                                       activeTextStyle: TextStyle(
//                                           fontWeight: FontWeight.bold,
//                                           color: Colors.white),
//                                       borderColor: kPrimaryColor,
//                                       backgroundColor: Colors.transparent,
//                                       activeBackgroundColor: kPrimaryColor,
//                                       firstTime: TimeOfDay(hour: 1, minute: 30),
//                                       lastTime: TimeOfDay(hour: 5, minute: 00),
//                                       timeStep: 30,
//                                       timeBlock: 30,
//                                       onRangeCompleted: (range) => setState(
//                                             () {
//                                               dummyStart = DateTime(
//                                                   1969,
//                                                   1,
//                                                   1,
//                                                   range.start.hour,
//                                                   range.start.minute);

//                                               dummyEnd = DateTime(
//                                                   1969,
//                                                   1,
//                                                   1,
//                                                   range.end.hour,
//                                                   range.end.minute);

//                                               startH = DateFormat.Hm()
//                                                   .format(dummyStart)
//                                                   .split(':')[0];

//                                               startM = DateFormat.Hm()
//                                                   .format(dummyStart)
//                                                   .split(':')[1];

//                                               endH = DateFormat.Hm()
//                                                   .format(dummyEnd)
//                                                   .split(':')[0];

//                                               endM = DateFormat.Hm()
//                                                   .format(dummyEnd)
//                                                   .split(':')[1];
//                                               print(startH);
//                                               print(startM);
//                                               print(endH);
//                                               print(endM);
//                                             },
//                                           )),
//                                   SizedBox(
//                                     height: 20,
//                                   ),
//                                   RoundedButton(
//                                     press: () {
//                                       DatabaseService.updateWorkDayHours(
//                                         startHour: startH,
//                                         startMin: startM,
//                                         endHour: endH,
//                                         endMin: endM,
//                                         documentID: widget.workDay.docID,
//                                         doctorID: widget.doctorID,
//                                       );
//                                     },
//                                     text: 'Edit hours',
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         }),
//                   );
//                 },
//                 isScrollControlled: true)
//             : null;
//       },
//       child: Container(
//         margin: EdgeInsets.only(bottom: 15),
//         padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
//         decoration: BoxDecoration(
//           color: Color(0xFFF0F0F0),
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             Expanded(
//               flex: 3,
//               child: Container(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       StringManipulation()
//                           .convertToTitleCase(widget.workDay.docID),
//                       style: TextStyle(
//                           color: kPrimaryTextColor,
//                           fontSize: size.width * 0.06),
//                     ),
//                     SizedBox(
//                       height: size.height * 0.01,
//                     ),
//                     Text(
//                       '$workHours',
//                       style: TextStyle(
//                           color: kPrimaryTextColor,
//                           fontSize: size.width * 0.04),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Container(
//               child: FlutterSwitch(
//                 width: size.width * 0.15,
//                 height: 55.0,
//                 valueFontSize: 15,
//                 toggleSize: 30,
//                 value: widget.workDay.enabled,
//                 borderRadius: 30.0,
//                 padding: 8.0,
//                 showOnOff: true,
//                 activeColor: kPrimaryColor,
//                 onToggle: (val) {
//                   setState(() {
//                     widget.workDay.enabled = val;
//                     if (widget.workDay.enabled) {
//                       workHours =
//                           "${widget.workDay.startHour}:${widget.workDay.startMin} ~ ${widget.workDay.endHour}:${widget.workDay.endMin}";
//                     } else {
//                       workHours = "Not a work day";
//                     }
//                     DatabaseService.updateWorkDayStatus(
//                         working: widget.workDay.enabled,
//                         doctorID: widget.doctorID,
//                         documentID: widget.workDay.docID);
//                   });
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
