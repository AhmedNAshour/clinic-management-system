import 'package:clinic/components/lists_cards/day_card.dart';
import 'package:clinic/models/workDay.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorkDaysList extends StatefulWidget {
  const WorkDaysList({
    Key key,
    @required this.doctorID,
  }) : super(key: key);

  final String doctorID;
  @override
  _WorkDaysListState createState() => _WorkDaysListState();
}

class _WorkDaysListState extends State<WorkDaysList> {
  @override
  Widget build(BuildContext context) {
    final workDays = Provider.of<List<WorkDay>>(context) ?? [];
    return ListView.builder(
      itemCount: workDays.length,
      itemBuilder: (context, index) {
        return DayCard(workDay: workDays[index], doctorID: widget.doctorID);
      },
    );
  }
}
