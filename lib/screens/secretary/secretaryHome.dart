import 'dart:io';
import 'package:clinic/components/lists_cards/appointments_list_secretary.dart';
import 'package:clinic/models/appointment.dart';
import 'package:clinic/models/user.dart';
import 'package:clinic/screens/secretary/changePassword.dart';
import 'package:clinic/screens/shared/loading.dart';
import 'package:clinic/services/database.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../components/lists_cards/clients_list.dart';
import '../../models/secretary.dart';
import '../../components/lists_cards/doctors_list_secretary_booking.dart';
import 'addDoctorSecretary.dart';
import '../../services/auth.dart';

class SecretaryHome extends StatefulWidget {
  @override
  _SecretaryHomeState createState() => _SecretaryHomeState();
}

class _SecretaryHomeState extends State<SecretaryHome> {
  String day = DateFormat("yyyy-MM-dd").format(DateTime.now());
  var textController = new TextEditingController();
  String search = DateFormat('dd-MM-yyyy').format(DateTime.now());
  bool showCancel = false;
  int selectedTab = 0;
  var todaysDate = DateTime.now();

  String email = '';
  String password = '';
  String fName = '';
  String lName = '';
  String phoneNumber = '';
  String error = '';
  int numAppointments = 0;
  int gender = 0;
  int age;
  bool loading = false;
  String curEmail;
  String curPassword;

  List<String> tabs = [
    'Appointments',
    'Clients',
    'Doctors',
  ];

  DateTime _selectedValue = DateTime.now();
  DatePickerController _controller = DatePickerController();
  File newProfilePic;

  //TODO: Change profile pic

  Future getImage() async {
    var tempImage = await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      newProfilePic = File(tempImage.path);
    });
  }

  uploadImage(String uid) async {
    final Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('profilePics/$uid.jpg');
    UploadTask task = firebaseStorageRef.putFile(newProfilePic);
    TaskSnapshot taskSnapshot = await task;
    taskSnapshot.ref.getDownloadURL().then(
          (value) => DatabaseService(uid: uid)
              .updateUserProfilePicture(value.toString(), 'secretary'),
        );
  }

  List<Widget> displayTab(int selectedTab, double screenHeight,
      double screenWidth, UserData user, Secretary secretary) {
    if (selectedTab == 0) {
      return appointmentsTab(screenHeight, screenWidth, user);
    } else if (selectedTab == 1) {
      return clientsTab(screenHeight, screenWidth, user);
    } else {
      return doctorsTab(screenHeight, screenWidth, user, secretary.branch);
    }
  }

  List<Widget> doctorsTab(
      double screenHeight, double screenWidth, UserData user, String branch) {
    return [
      Container(
        height: screenHeight * 0.3,
        width: double.infinity,
        color: kPrimaryColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.02),
              child: CircleAvatar(
                radius: screenWidth * 0.12,
                backgroundImage: user.picURL != ''
                    ? NetworkImage(user.picURL)
                    : AssetImage('assets/images/userPlaceholder.png'),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.02),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Welcome ${user.fName}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.07,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Heliopolis Branch',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.05,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      SizedBox(
        height: screenHeight * 0.08,
      ),
      Expanded(
        child: Container(
          width: screenWidth * 0.9,
          child: DoctorListSecretaryBooking('', branch, null),
        ),
      ),
    ];
  }

  List<Widget> clientsTab(
      double screenHeight, double screenWidth, UserData user) {
    return [
      Container(
        height: screenHeight * 0.3,
        width: double.infinity,
        color: kPrimaryColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.02),
              child: CircleAvatar(
                radius: screenWidth * 0.12,
                backgroundImage: user.picURL != ''
                    ? NetworkImage(user.picURL)
                    : AssetImage('assets/images/userPlaceholder.png'),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.02),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Welcome ${user.fName}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.07,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Heliopolis Branch',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.05,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      SizedBox(
        height: screenHeight * 0.08,
      ),
      Expanded(
        child: Container(
          width: screenWidth * 0.9,
          child: ClientList(''),
        ),
      ),
    ];
  }

  List<Widget> appointmentsTab(
      double screenHeight, double screenWidth, UserData user) {
    return [
      Container(
        height: screenHeight * 0.3,
        width: double.infinity,
        color: kPrimaryColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.02),
              child: CircleAvatar(
                radius: screenWidth * 0.12,
                backgroundImage: user.picURL != ''
                    ? NetworkImage(user.picURL)
                    : AssetImage('assets/images/userPlaceholder.png'),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.02),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Welcome ${user.fName}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.07,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Heliopolis Branch',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.05,
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      await AuthService().signOut();
                    },
                    child: Text(
                      'Sign out',
                      style: TextStyle(color: kPrimaryLightColor, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      SizedBox(
        height: screenHeight * 0.08,
      ),
      DatePicker(
        todaysDate,
        // DateTime(todaysDate.year, todaysDate.month - 1, todaysDate.day),
        width: 60,
        height: 80,
        controller: _controller,
        initialSelectedDate: DateTime.now(),
        selectionColor: kPrimaryColor,
        selectedTextColor: Colors.white,
        dateTextStyle: TextStyle(color: Color(0xFF707070)),
        dayTextStyle: TextStyle(color: Color(0xFF707070)),
        monthTextStyle: TextStyle(color: Color(0xFF707070)),
        onDateChange: (date) {
          // New date selected
          setState(() {
            _selectedValue = date;
            search = DateFormat('dd-MM-yyyy').format(_selectedValue);
            print(search);
          });
        },
      ),
      SizedBox(
        height: screenHeight * 0.04,
      ),
      Expanded(
        child: Container(
          width: screenWidth * 0.9,
          child: AppointmentsListSecretary(search),
        ),
      ),
    ];
  }

  Widget displayFloatingActionButton(
      int selectedTab, double screenWidth, double screenHeight, String branch) {
    if (selectedTab == 0) {
      return null;
    } else if (selectedTab == 1) {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: kPrimaryColor, width: 2),
          borderRadius: BorderRadius.circular(360),
        ),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/secretaryAddClientScreen');
          },
          backgroundColor: Colors.white,
          child: SvgPicture.asset(
            'assets/images/addClient.svg',
            color: kPrimaryColor,
          ),
        ),
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: kPrimaryColor, width: 2),
          borderRadius: BorderRadius.circular(360),
        ),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, AddDoctorSec.id, arguments: {
              'branch': branch,
            });
          },
          backgroundColor: Colors.white,
          child: SvgPicture.asset(
            'assets/images/Add-doctor.svg',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData>(context);
    final secretary = Provider.of<Secretary>(context);
    Size size = MediaQuery.of(context).size;
    double screenHeight = size.height;
    double screenWidth = size.width;
    return user != null && secretary != null
        ? Scaffold(
            backgroundColor: Color(0xFFF0F0F0),
            floatingActionButton: displayFloatingActionButton(
                selectedTab, screenWidth, screenHeight, secretary.branch),
            body: MultiProvider(
              providers: [
                StreamProvider<List<Appointment>>.value(
                    value: DatabaseService().appointments),
                // StreamProvider<List<Client>>.value(
                //     value: DatabaseService().clients),
              ],
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Column(
                    children: displayTab(selectedTab, screenHeight, screenWidth,
                        user, secretary),
                  ),
                  Positioned(
                    top: screenHeight * 0.245,
                    left: -5,
                    child: Container(
                      height: screenWidth * 0.2,
                      width: screenWidth * 0.2,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(45),
                            bottomRight: Radius.circular(45),
                            bottomLeft: Radius.circular(40),
                          )),
                    ),
                  ),
                  Positioned(
                    top: screenHeight * 0.27,
                    left: screenWidth * 0.055,
                    child: GestureDetector(
                      onTap: () {},
                      child: SvgPicture.asset(
                        'assets/images/search.svg',
                        color: kPrimaryColor,
                        height: screenWidth * 0.08,
                        width: screenWidth * 0.08,
                      ),
                    ),
                  ),
                  Positioned(
                    top: screenHeight * 0.245,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(screenWidth * 0.02),
                      height: screenWidth * 0.2,
                      width: screenWidth * 0.75,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(45),
                          bottomLeft: Radius.circular(45),
                        ),
                      ),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: tabs.length,
                        itemBuilder: (context, index) {
                          return Center(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedTab = index;
                                });
                              },
                              child: Padding(
                                padding: EdgeInsets.all(screenWidth * 0.02),
                                child: Text(
                                  tabs[index],
                                  style: TextStyle(
                                    color: selectedTab == index
                                        ? kPrimaryColor
                                        : Color(0xFF707070),
                                    fontSize: screenWidth * 0.06,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : Loading();
  }
}
