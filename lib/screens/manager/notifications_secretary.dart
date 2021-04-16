import 'package:clinic/components/lists_cards/clients_list.dart';
import 'package:clinic/components/lists_cards/notifications_list.dart';
import 'package:clinic/models/client.dart';
import 'package:clinic/models/manager.dart';
import 'package:clinic/models/notification.dart';
import 'package:clinic/models/user.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:clinic/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationsSecretary extends StatefulWidget {
  static final id = 'NotificationsSecretary';
  @override
  _NotificationsSecretaryState createState() => _NotificationsSecretaryState();
}

class _NotificationsSecretaryState extends State<NotificationsSecretary> {
  int selectedType = 0;
  List<String> appointmentTypes = [
    'Booking & Cancellation',
    'Registration Requests',
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final user = Provider.of<AuthUser>(context);
    final manager = Provider.of<Manager>(context);

    return Column(
      children: [
        Container(
          // padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
          height: size.height * 0.1,
          width: double.infinity,
          color: kPrimaryColor,
          child: Center(
            child: Text(
              'Notifications',
              style: TextStyle(
                fontSize: size.width * 0.06,
                color: Colors.white,
              ),
            ),
          ),
        ),
        manager.isBoss
            ? Container(
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
                        // width: size.width * 0.35,
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
                            appointmentTypes[index],
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
              )
            : Container(),
        manager.isBoss
            ? Expanded(
                child: Container(
                  width: size.width * 0.9,
                  child: selectedType == 0
                      ? StreamProvider<List<NotificationModel>>.value(
                          value:
                              DatabaseService(uid: user.uid).getNotifications(
                            status: 1,
                          ),
                          child: NotificationsList(),
                        )
                      : StreamProvider<List<Client>>.value(
                          value: DatabaseService().getClients(
                              clientName: '', clientNumber: '', status: 2),
                          child: ClientList(
                            isSearch: 'no',
                          ),
                        ),
                ),
              )
            : StreamProvider<List<NotificationModel>>.value(
                value: DatabaseService(uid: user.uid).getNotifications(
                  status: 1,
                ),
                child: NotificationsList(),
              ),
      ],
    );
  }
}
