import 'package:clinic/models/client.dart';
import 'package:clinic/models/user.dart';
import 'package:clinic/screens/client/client_home.dart';
import 'package:clinic/services/database.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'chat_client.dart';
import 'notifications_client.dart';
import 'profile_client.dart';

class ClientNavigation extends StatefulWidget {
  @override
  _ClientNavigationState createState() => _ClientNavigationState();
}

class _ClientNavigationState extends State<ClientNavigation> {
  int _currentIndex = 0;
  List<Widget> screens = [
    ClientHome(),
    ChatClient(),
    NotificationsClient(),
    ProfileClient(),
  ];
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser>(context);
    Size size = MediaQuery.maybeOf(context).size;
    return MultiProvider(
      providers: [
        StreamProvider<Client>.value(
          value: DatabaseService(uid: user.uid).client,
        ),
      ],
      child: SafeArea(
        child: Scaffold(
          body: screens[_currentIndex],
          bottomNavigationBar: CurvedNavigationBar(
            backgroundColor: Colors.transparent,
            animationDuration: Duration(milliseconds: 300),
            height: 60,
            index: 0,
            items: [
              SvgPicture.asset(
                'assets/images/appointments.svg',
                color: kPrimaryColor,
                height: size.width * 0.07,
                width: size.width * 0.07,
              ),
              SvgPicture.asset(
                'assets/images/message.svg',
                color: kPrimaryColor,
                height: size.width * 0.07,
                width: size.width * 0.07,
              ),
              SvgPicture.asset(
                'assets/images/notification.svg',
                color: kPrimaryColor,
                height: size.width * 0.07,
                width: size.width * 0.07,
              ),
              SvgPicture.asset(
                'assets/images/account.svg',
                color: kPrimaryColor,
                height: size.width * 0.07,
                width: size.width * 0.07,
              ),
            ],
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
