import 'package:clinic/models/customBottomSheets.dart';
import 'package:clinic/models/manager.dart';
import 'package:clinic/models/user.dart';
import 'package:clinic/screens/shared/chat_room.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:clinic/screens/shared/stringManipulation.dart';
import 'package:clinic/services/database.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../screens/admin/manager_info.dart';
import '../../screens/admin/edit_secretary.dart';
import '../../screens/admin/disable_user.dart';

class SecretaryCard extends StatelessWidget {
  const SecretaryCard({
    Key key,
    @required this.manager,
  }) : super(key: key);

  final Manager manager;

  @override
  Widget build(BuildContext context) {
    HttpsCallable deleteUserFunction = FirebaseFunctions.instance.httpsCallable(
      'deleteUser',
    );
    Size size = MediaQuery.of(context).size;
    double screenHeight = size.height;
    double screenWidth = size.width;
    return GestureDetector(
      onTap: () {
        CustomBottomSheets().showDynamicCustomBottomSheet(
            size, ManagerProfileAdmin(manager), context);
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          width: screenWidth * 0.9,
          padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.02, vertical: screenHeight * 0.02),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: screenWidth * 0.11,
                backgroundImage: manager.picURL != ''
                    ? NetworkImage(manager.picURL)
                    : AssetImage('assets/images/userPlaceholder.png'),
              ),
              SizedBox(
                width: screenWidth * 0.02,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      StringManipulation.limitLength(
                          '${manager.fName} ${manager.lName}', 25),
                      style: TextStyle(
                        color: kPrimaryTextColor,
                        fontSize: screenWidth * 0.05,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.01,
                    ),
                    // Text(
                    //   manager.branchName,
                    //   style: TextStyle(
                    //     color: kPrimaryLightColor,
                    //     fontSize: screenWidth * 0.04,
                    //   ),
                    // ),
                    SizedBox(
                      height: screenHeight * 0.02,
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            launch(
                                "tel://${manager.countryDialCode}${manager.phoneNumber}");
                          },
                          child: Icon(
                            Icons.phone_android_rounded,
                            color: kPrimaryColor,
                          ),
                        ),
                        SizedBox(
                          width: screenWidth * 0.01,
                        ),
                        Text(
                          'Call',
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: screenWidth * 0.045,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.02,
                          ),
                          width: screenWidth * 0.005,
                          height: screenHeight * 0.02,
                          color: kPrimaryTextColor,
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.chat_bubble_outline_rounded,
                          ),
                          color: kPrimaryColor,
                          onPressed: () {
                            Navigator.pushNamed(context, ChatRoom.id,
                                arguments: {
                                  'otherUser': UserModel(
                                    fName: manager.fName,
                                    lName: manager.lName,
                                    uid: manager.uid,
                                    picURL: manager.picURL,
                                    role: 'secretary',
                                  ),
                                });
                          },
                        ),
                        SizedBox(
                          width: screenWidth * 0.01,
                        ),
                        Text(
                          'Message',
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: screenWidth * 0.045,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      CustomBottomSheets().showCustomBottomSheet(
                        size,
                        EditSecretary(
                          manager: manager,
                        ),
                        context,
                      );
                    },
                    child: Icon(
                      FontAwesomeIcons.userEdit,
                      color: kPrimaryColor,
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  manager.status == 1
                      ? GestureDetector(
                          onTap: () async {
                            CustomBottomSheets().showDynamicCustomBottomSheet(
                                size,
                                DisableUser(UserModel(
                                  fName: manager.fName,
                                  lName: manager.lName,
                                  uid: manager.uid,
                                  role: 'secretary',
                                )),
                                context);
                          },
                          child: Icon(
                            Icons.cancel,
                            color: Color(0xFFB5020B),
                            size: size.width * 0.075,
                          ),
                        )
                      : GestureDetector(
                          onTap: () async {
                            var result = await DatabaseService(uid: manager.uid)
                                .updateUserStatus('secretary', 1);
                            if (result == 0) print('DIDNT WORK');
                          },
                          child: Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: size.width * 0.075,
                          ),
                        ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
