import 'package:flutter/material.dart';

import 'time_slot_capsule.dart';

class TimeSlotsSlider extends StatelessWidget {
  const TimeSlotsSlider({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          TimeSlot(time: '10:00 am'),
          TimeSlot(time: '10:00 am'),
          TimeSlot(time: '10:00 am'),
          TimeSlot(time: '10:00 am'),
        ],
      ),
    );
  }
}
