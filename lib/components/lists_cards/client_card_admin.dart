import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:clinic/models/client.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:clinic/services/database.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ClientCardAdmin extends StatelessWidget {
  const ClientCardAdmin({
    Key key,
    @required this.client,
  }) : super(key: key);

  final Client client;

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
        onTap: () {
          Navigator.pushNamed(context, '/clientInfoScreen', arguments: {
            'fName': client.fName,
            'lName': client.lName,
            'age': client.age,
            'gender': client.gender,
            'numAppointments': client.numAppointments,
            'phoneNumber': client.phoneNumber,
            'uid': client.uid,
          });
        },
        child: Container(
          padding: EdgeInsets.all(25),
          margin: EdgeInsets.only(bottom: 10),
          width: size.width * 0.8,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28), color: Colors.white),
          child: Row(
            children: [
              // CircleAvatar(
              //   backgroundImage:
              //       AssetImage('assets/images/doctorPortraitCenter.jpg'),
              //   radius: (80 / 100 * size.width) * 0.1,
              // ),
              // SizedBox(
              //   width: size.width * 0.04,
              // ),
              Expanded(
                flex: 3,
                child: AutoSizeText(
                  client.gender == 'male'
                      ? 'Mr. ${client.fName} ${client.lName}'
                      : 'Mrs. ${client.fName} ${client.lName}',
                  style: TextStyle(color: kPrimaryColor, fontSize: 20),
                  minFontSize: 15,
                  maxLines: 1,
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: Container(
                    child: IconButton(
                      icon: FaIcon(
                        FontAwesomeIcons.mobileAlt,
                        size: 30,
                        color: kPrimaryColor,
                      ),
                      onPressed: () {
                        launch("tel://${client.phoneNumber}");
                      },
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
                print('Client id: ${client.uid}');
                dynamic result =
                    await deleteUserFunction.call(<String, dynamic>{
                  'uid': client.uid,
                });

                DatabaseService().deleteUser(client.uid, 'client');

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
