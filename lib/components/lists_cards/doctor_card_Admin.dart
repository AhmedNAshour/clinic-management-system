import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:clinic/models/doctor.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:clinic/services/database.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DoctorCardAdmin extends StatelessWidget {
  const DoctorCardAdmin({
    Key key,
    @required this.doctor,
  }) : super(key: key);

  final Doctor doctor;

  @override
  Widget build(BuildContext context) {
    HttpsCallable deleteUserFunction = FirebaseFunctions.instance.httpsCallable(
      'deleteUser',
    );
    Size size = MediaQuery.of(context).size;
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: GestureDetector(
        onTap: () {},
        child: Container(
          height: 100,
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.only(bottom: 10),
          width: size.width * 0.8,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(11), color: Colors.white),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage:
                    AssetImage('assets/images/doctorPortraitCenter.jpg'),
                radius: (80 / 100 * size.width) * 0.1,
              ),
              SizedBox(
                width: size.width * 0.04,
              ),
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctor.fName + ' ' + doctor.lName,
                        style: TextStyle(
                            color: kPrimaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
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
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/doctorScheduleScreen',
                        arguments: {
                          'docId': doctor.uid,
                          'fName': doctor.fName,
                          'lName': doctor.lName,
                          'profession': doctor.proffesion,
                        });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    margin: EdgeInsets.only(left: 10),
                    child: Center(
                      child: AutoSizeText(
                        'EDIT',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                        minFontSize: 15,
                        maxLines: 1,
                      ),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: kPrimaryLightColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
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
                  'REMOVE',
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
              title: "Remove Client",
              desc: 'Are you sure you want to remove this client ?',
              btnCancelOnPress: () {},
              btnOkOnPress: () async {
                print('Client id: ${doctor.uid}');
                dynamic result =
                    await deleteUserFunction.call(<String, dynamic>{
                  'uid': doctor.uid,
                });

                DatabaseService().deleteUser(doctor.uid, 'doctor');

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
                            'COULD NOT REMOVE CLIENT..',
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
                          'Client Removed Successfully',
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
