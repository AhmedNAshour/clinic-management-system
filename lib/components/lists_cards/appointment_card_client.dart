import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:clinic/models/appointment.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:clinic/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class AppointmentCardClient extends StatelessWidget {
  const AppointmentCardClient({
    Key key,
    this.appointment,
  }) : super(key: key);

  final Appointment appointment;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: Container(
        height: 100,
        margin: EdgeInsets.only(bottom: 15),
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 15),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(28)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: AutoSizeText(
                        DateFormat("MMM").format(appointment.startTime),
                        style:
                            TextStyle(color: kPrimaryLightColor, fontSize: 30),
                        minFontSize: 15,
                      ),
                    ),
                    Expanded(
                      child: AutoSizeText(
                        DateFormat("d").format(appointment.startTime),
                        style:
                            TextStyle(color: kPrimaryLightColor, fontSize: 30),
                        minFontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 5, right: 5),
              width: 1,
              height: 60,
              color: kPrimaryLightColor,
            ),
            Expanded(
              flex: 3,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: AutoSizeText(
                        'Dr. ${appointment.doctorFName} ${appointment.doctorLName}',
                        style: TextStyle(color: kPrimaryColor, fontSize: 30),
                        minFontSize: 15,
                        maxLines: 2,
                      ),
                    ),
                    Expanded(
                      child: AutoSizeText(
                        DateFormat("Hm").format(appointment.startTime),
                        style:
                            TextStyle(color: kPrimaryLightColor, fontSize: 25),
                        minFontSize: 15,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      secondaryActions: <Widget>[
        SlideAction(
          child: Container(
            decoration: BoxDecoration(
                // shape: BoxShape.circle,
                color: Colors.red,
                borderRadius: BorderRadius.circular(28)),
            margin: EdgeInsets.only(bottom: 15),
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FaIcon(
                  FontAwesomeIcons.trashAlt,
                  size: 30,
                  color: Colors.white,
                ),
                SizedBox(
                  height: 5,
                ),
                AutoSizeText(
                  'CANCEL',
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
          ),
          onTap: () {
            AwesomeDialog(
              context: context,
              headerAnimationLoop: false,
              dialogType: DialogType.WARNING,
              animType: AnimType.BOTTOMSLIDE,
              title: "Cancel Appointment",
              desc: 'Are you sure you want to cancel this appointment ?',
              btnCancelOnPress: () {},
              btnOkOnPress: () async {
                print('Client id: ${appointment.clientID}');
                dynamic result;
                int old = await DatabaseService()
                    .getSpecificClientRemainingSessions(appointment.clientID);
                print('Old : $old');
                await DatabaseService().updateClientRemainingSessions(
                    numAppointments: old + 1, documentID: appointment.clientID);
                result = await DatabaseService()
                    .deleteAppointment(appointment.docID);

                if (result == null) {
                  AwesomeDialog(
                      context: context,
                      headerAnimationLoop: false,
                      dialogType: DialogType.ERROR,
                      animType: AnimType.BOTTOMSLIDE,
                      body: Align(
                        alignment: Alignment.center,
                        child: Center(
                          child: Text(
                            'COULD NOT CANCEL APPOINTMENT..',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      onDissmissCallback: () {},
                      btnOkOnPress: () {})
                    ..show();
                } else {
                  //Navigator.pop(context);
                  AwesomeDialog(
                      context: context,
                      headerAnimationLoop: false,
                      dialogType: DialogType.SUCCES,
                      animType: AnimType.BOTTOMSLIDE,
                      body: Center(
                        child: Text(
                          'Appointment Cancelled Successfully',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      onDissmissCallback: () {},
                      btnOkOnPress: () {})
                    ..show();
                }
              },
            )..show();
          },
        ),
      ],
    );
  }
}
