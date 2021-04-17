import 'dart:io';
import 'package:clinic/components/forms/secretary_search_appointments.dart';
import 'package:clinic/components/forms/secretary_search_clients.dart';
import 'package:clinic/components/forms/secretary_search_doctors.dart';
import 'package:clinic/components/lists_cards/appointments_list_secretary.dart';
import 'package:clinic/components/lists_cards/doctors_list.dart';
import 'package:clinic/models/appointment.dart';
import 'package:clinic/models/client.dart';
import 'package:clinic/models/doctor.dart';
import 'package:clinic/models/user.dart';
import 'package:clinic/screens/manager/booking_step1.dart';
import 'package:clinic/screens/shared/loading.dart';
import 'package:clinic/services/database.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../components/lists_cards/clients_list.dart';
import '../../models/manager.dart';
import 'addDoctorSecretary.dart';
import '../../services/auth.dart';
import 'addClient.dart';
import '../../models/customBottomSheets.dart';

class SecretaryHome extends StatefulWidget {
  @override
  _SecretaryHomeState createState() => _SecretaryHomeState();
}

class _SecretaryHomeState extends State<SecretaryHome> {
  var textController = new TextEditingController();
  String dateSearch = DateFormat("yyyy-MM-dd").format(DateTime.now());
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
  bool loading = false;
  String curEmail;
  String curPassword;
  String searchDoctorNameAppointment = '';
  String searchClientNameAppointment = '';
  String searchClientNumberAppointment = '';
  String searchDoctorName = '';
  String searchClientName = '';
  String searchClientNumber = '';
  var dateTextController = new TextEditingController();
  DateTime _selectedValue = DateTime.now();
  DatePickerController _controller = DatePickerController();
  File newProfilePic;
  List<String> tabs = [
    'Appointments',
    'Clients',
    'Doctors',
  ];

  changeDateSearch(newDate) {
    setState(() {
      dateSearch = newDate;
    });
  }

  changeDoctorNameSearchAppointments(newDoctorName) {
    setState(() {
      searchDoctorNameAppointment = newDoctorName;
    });
  }

  changeClientNameSearchAppointments(newClientName) {
    setState(() {
      searchClientNameAppointment = newClientName;
    });
  }

  changeClientNumberSearchAppointments(newClientNumber) {
    setState(() {
      searchClientNumberAppointment = newClientNumber;
    });
  }

  changeDoctorNameSearch(newDoctorName) {
    setState(() {
      searchDoctorName = newDoctorName;
    });
  }

  changeClientNameSearch(newClientName) {
    setState(() {
      searchClientName = newClientName;
    });
  }

  changeClientNumberSearch(newClientNumber) {
    setState(() {
      searchClientNumber = newClientNumber;
    });
  }

  Widget displayAppropriateSearchForm(int selectedTab) {
    if (selectedTab == 0) {
      return SearchAppointmentsForm(
        dateSearch: dateSearch,
        changeDateSearch: changeDateSearch,
        changeClientNameSearch: changeClientNameSearchAppointments,
        changeClientNumberSearch: changeClientNumberSearchAppointments,
        changeDoctorNameSearch: changeDoctorNameSearchAppointments,
        doctorNameSearch: searchDoctorNameAppointment,
        clientNameSearch: searchClientNameAppointment,
        clientNumberSearch: searchClientNumberAppointment,
      );
    } else if (selectedTab == 1) {
      return SearchClientsForm(
        changeClientNameSearch: changeClientNameSearch,
        changeClientNumberSearch: changeClientNumberSearch,
        clientNameSearch: searchClientName,
        clientNumberSearch: searchClientNumber,
        showSearchButton: 'yes',
      );
    } else {
      return SearchDoctorsForm(
        changeDoctorNameSearch: changeDoctorNameSearch,
        doctorNameSearch: searchDoctorName,
      );
    }
  }

  List<Widget> displayTab(int selectedTab, double screenHeight,
      double screenWidth, UserModel user, Manager secretary) {
    if (selectedTab == 0) {
      return appointmentsTab(screenHeight, screenWidth, user, secretary.branch);
    } else if (selectedTab == 1) {
      return clientsTab(screenHeight, screenWidth, user, secretary.branch);
    } else {
      return doctorsTab(
          screenHeight, screenWidth, user, secretary.branch, secretary.branch);
    }
  }

  List<Widget> doctorsTab(double screenHeight, double screenWidth,
      UserModel user, String branch, String branchName) {
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
                    '$branchName Branch',
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
          child: DoctorList(),
        ),
      ),
    ];
  }

  List<Widget> clientsTab(double screenHeight, double screenWidth,
      UserModel user, String branchName) {
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
                    '$branchName Branch',
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
          child: ClientList(
            isSearch: 'no',
          ),
        ),
      ),
    ];
  }

  List<Widget> appointmentsTab(double screenHeight, double screenWidth,
      UserModel user, String branchName) {
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
                    '$branchName Branch',
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
      DatePicker(
        todaysDate,
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
            dateSearch = DateFormat('yyyy-MM-dd').format(_selectedValue);
            dateTextController.text = dateSearch;
          });
        },
      ),
      SizedBox(
        height: screenHeight * 0.04,
      ),
      Expanded(
        child: Container(
          width: screenWidth * 0.9,
          child: AppointmentsListSecretary(
            isSearch: 'no',
          ),
        ),
      ),
    ];
  }

  Widget displayFloatingActionButton(int selectedTab, double screenWidth,
      double screenHeight, String branch, Size size) {
    if (selectedTab == 0) {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: kPrimaryColor, width: 2),
          borderRadius: BorderRadius.circular(360),
        ),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, BookingStep1.id);
          },
          backgroundColor: Colors.white,
          child: SvgPicture.asset(
            'assets/images/Add-Appointment.svg',
            color: kPrimaryColor,
          ),
        ),
      );
    } else if (selectedTab == 1) {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: kPrimaryColor, width: 2),
          borderRadius: BorderRadius.circular(360),
        ),
        child: FloatingActionButton(
          onPressed: () {
            CustomBottomSheets()
                .showCustomBottomSheet(size, AddClient(), context);
            // Navigator.pushNamed(context, '/secretaryAddClientScreen');
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
            // Navigator.pushNamed(context, AddDoctorSec.id, arguments: {
            //   'branch': branch,
            // });
            CustomBottomSheets().showCustomBottomSheet(
              size,
              AddDoctorSec(
                secretaryBranch: branch,
              ),
              context,
            );
          },
          backgroundColor: Colors.white,
          child: CircleAvatar(
            // radius: screenWidth * 0.04,
            backgroundColor: Colors.white,
            backgroundImage: AssetImage('assets/images/Add-doctor.png'),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);
    final secretary = Provider.of<Manager>(context);
    Size size = MediaQuery.of(context).size;
    double screenHeight = size.height;
    double screenWidth = size.width;
    return user != null && secretary != null
        ? Scaffold(
            // backgroundColor: Color(0xFFF0F0F0),
            floatingActionButton: displayFloatingActionButton(
                selectedTab, screenWidth, screenHeight, secretary.branch, size),
            body: MultiProvider(
              providers: [
                StreamProvider<List<Appointment>>.value(
                  value: DatabaseService().getAppointments(
                    day: dateSearch,
                    doctorName: searchDoctorNameAppointment,
                    clientName: searchClientNameAppointment,
                    clientNumber: searchClientNumberAppointment,
                    branch: secretary.branch,
                    status: 'active',
                  ),
                  initialData: [],
                ),
                StreamProvider<List<Doctor>>.value(
                  value: DatabaseService().getDoctors(
                    branch: secretary.branch,
                    doctorName: searchDoctorName,
                  ),
                  initialData: [],
                ),
                StreamProvider<List<Client>>.value(
                  value: DatabaseService().getClients(
                    clientName: searchClientName,
                    clientNumber: searchClientNumber,
                    status: 1,
                  ),
                  initialData: [],
                ),
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
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                                topRight: Radius.circular(20.0)),
                          ),
                          builder: (context) {
                            return FractionallySizedBox(
                              heightFactor: 0.9,
                              child: DraggableScrollableSheet(
                                initialChildSize: 1.0,
                                maxChildSize: 1.0,
                                minChildSize: 0.25,
                                builder: (BuildContext context,
                                    ScrollController scrollController) {
                                  return StatefulBuilder(builder:
                                      (BuildContext context,
                                          StateSetter insideState) {
                                    return Container(
                                      padding: EdgeInsets.symmetric(
                                        vertical: size.height * 0.02,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                            padding: EdgeInsets.only(
                                                left: size.width * 0.02,
                                                right: size.width * 0.02,
                                                bottom: size.height * 0.01),
                                            decoration: BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                  width: size.height * 0.001,
                                                  color: kPrimaryLightColor,
                                                ),
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  'Search',
                                                  style: TextStyle(
                                                      fontSize:
                                                          size.width * 0.05,
                                                      color: kPrimaryTextColor),
                                                ),
                                                SizedBox(
                                                    width: size.width * 0.28),
                                                IconButton(
                                                  icon: Icon(
                                                    Icons.close,
                                                    color: kPrimaryTextColor,
                                                    size: size.width * 0.085,
                                                  ),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                          // SizedBox(
                                          //   height: size.height * 0.02,
                                          // ),
                                          Center(
                                            child: Container(
                                              width: size.width * 0.9,
                                              height: size.height * 0.12,
                                              child: ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount: tabs.length,
                                                itemBuilder: (context, index) {
                                                  return GestureDetector(
                                                    onTap: () {
                                                      insideState(() {
                                                        selectedTab = index;
                                                      });
                                                      this.setState(() {
                                                        selectedTab = index;
                                                      });
                                                    },
                                                    child: Container(
                                                      width: size.width * 0.3,
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                        vertical:
                                                            size.height * 0.02,
                                                        horizontal:
                                                            size.width * 0.01,
                                                      ),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                        vertical:
                                                            size.height * 0.02,
                                                        horizontal:
                                                            size.width * 0.02,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color:
                                                            selectedTab == index
                                                                ? kPrimaryColor
                                                                : Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        border: Border.all(
                                                          color: selectedTab ==
                                                                  index
                                                              ? Colors
                                                                  .transparent
                                                              : kPrimaryLightColor,
                                                        ),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          tabs[index],
                                                          style: TextStyle(
                                                            color: selectedTab ==
                                                                    index
                                                                ? Colors.white
                                                                : kPrimaryLightColor,
                                                            // fontSize:
                                                            //     size.width * 0.04,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              child:
                                                  displayAppropriateSearchForm(
                                                      selectedTab),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  });
                                },
                              ),
                            );
                          },
                          isScrollControlled: true,
                        );
                      },
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
