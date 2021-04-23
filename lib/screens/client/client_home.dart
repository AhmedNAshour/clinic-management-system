import 'package:clinic/components/lists_cards/appointments_list_client.dart';
import 'package:clinic/langs/locale_keys.g.dart';
import 'package:clinic/models/client.dart';
import 'package:clinic/models/user.dart';
import 'package:clinic/screens/shared/loading.dart';
import 'package:clinic/services/database.dart';
import 'package:flutter/material.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'booking_step1_client.dart';
import 'package:easy_localization/easy_localization.dart';

class ClientHome extends StatefulWidget {
  @override
  _ClientHomeState createState() => _ClientHomeState();
}

class _ClientHomeState extends State<ClientHome> {
  String branchId = '';
  var textController = new TextEditingController();
  String search = '';
  bool showCancel = false;
  int selectedType = 0;
  int status;
  String dateComparison;
  List<String> appointmentTypes = [
    'Upcoming',
    'Past',
    'Canceled',
  ];

  List<String> appointmentTypesAR = [
    'القادم',
    'السابق',
    'ملغى',
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double screenHeight = size.height;
    double screenWidth = size.width;
    final user = Provider.of<UserModel>(context);
    final client = Provider.of<Client>(context);

    int getStatus(int selectedType) {
      if (selectedType == 0 || selectedType == 1) status = 1;
      if (selectedType == 2) status = 0;
      return status;
    }

    return user != null && client != null
        ? Scaffold(
            body: Stack(
              children: [
                Positioned(
                  child: Container(
                    height: screenHeight * 0.18,
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.02,
                      vertical: screenHeight * 0.04),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(screenWidth * 0.02),
                            child: CircleAvatar(
                              radius: screenWidth * 0.10,
                              backgroundImage:
                                  user.picURL != '' && user.picURL != null
                                      ? NetworkImage(user.picURL)
                                      : AssetImage(
                                          'assets/images/userPlaceholder.png'),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(screenWidth * 0.02),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${LocaleKeys.welcome.tr()} ${user.fName}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: screenWidth * 0.07,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${client.numAppointments} ${LocaleKeys.appointmentsRemaining.tr()} ',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: screenWidth * 0.04,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: screenHeight * 0.02,
                      ),
                      Container(
                        height: size.height * 0.1,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: appointmentTypes.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedType = index;
                                });
                              },
                              child: Container(
                                width: size.width * 0.35,
                                height: size.height * 0.12,
                                margin: EdgeInsets.symmetric(
                                  vertical: size.height * 0.02,
                                  horizontal: size.width * 0.02,
                                ),
                                padding: EdgeInsets.symmetric(
                                  vertical: size.height * 0.01,
                                  horizontal: size.width * 0.02,
                                ),
                                decoration: BoxDecoration(
                                  color: selectedType == index
                                      ? kPrimaryColor
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: selectedType == index
                                        ? Colors.transparent
                                        : kPrimaryLightColor,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    context.locale.toString() == 'en'
                                        ? appointmentTypes[index]
                                        : appointmentTypesAR[index],
                                    style: TextStyle(
                                        color: selectedType == index
                                            ? Colors.white
                                            : kPrimaryLightColor,
                                        fontSize: size.width * 0.05),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Expanded(
                        child: Container(
                          width: size.width * 0.9,
                          child: StreamProvider.value(
                              value: DatabaseService().getAppointments(
                                status: getStatus(selectedType),
                                dateComparison: appointmentTypes[selectedType],
                                clientId: client.uid,
                              ),
                              child: AppointmentsListClient('yes')),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            floatingActionButton: Container(
              decoration: BoxDecoration(
                border: Border.all(color: kPrimaryColor, width: 2),
                borderRadius: BorderRadius.circular(360),
              ),
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.pushNamed(context, BookingStep1Client.id);
                },
                backgroundColor: Colors.white,
                child: SvgPicture.asset(
                  'assets/images/Add-Appointment.svg',
                  color: kPrimaryColor,
                ),
              ),
            ),
          )
        : Loading();
  }
}
