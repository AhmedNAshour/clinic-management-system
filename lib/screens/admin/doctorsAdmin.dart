import 'package:clinic/components/lists_cards/doctors_list.dart';
import 'package:clinic/models/customBottomSheets.dart';
import 'package:clinic/models/doctor.dart';
import 'package:clinic/models/user.dart';
import 'package:clinic/screens/admin/addDoctorAdmin.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:clinic/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../components/forms/admin_search_doctors.dart';

class DoctorsAdmin extends StatefulWidget {
  static final id = 'DoctorsAdmin';
  @override
  _DoctorsAdminState createState() => _DoctorsAdminState();
}

class _DoctorsAdminState extends State<DoctorsAdmin> {
  String searchDoctorName = '';

  changeDoctorNameSearch(newDoctorName) {
    setState(() {
      searchDoctorName = newDoctorName;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final user = Provider.of<MyUser>(context);

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.only(right: size.width * 0.04),
              height: size.height * 0.1,
              width: double.infinity,
              color: kPrimaryColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BackButton(
                    color: Colors.white,
                  ),
                  SizedBox(width: size.width * 0.2),
                  Text(
                    'Doctors',
                    style: TextStyle(
                      fontSize: size.width * 0.06,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: size.width * 0.2),
                  GestureDetector(
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
                                                    fontSize: size.width * 0.05,
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
                                        Expanded(
                                          child: Container(
                                            child: SearchDoctorsFormAdmin(
                                              changeDoctorNameSearch:
                                                  changeDoctorNameSearch,
                                              doctorNameSearch:
                                                  searchDoctorName,
                                            ),
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
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: size.height * 0.03,
            ),
            Expanded(
              child: Container(
                child: MultiProvider(
                  providers: [
                    StreamProvider<List<Doctor>>.value(
                      value: DatabaseService()
                          .getDoctorsBySearch('', searchDoctorName),
                      initialData: [],
                    ),
                    StreamProvider<UserData>.value(
                      value: DatabaseService(uid: user.uid).userData,
                      initialData: null,
                    ),
                  ],
                  child: DoctorList(
                    isSearch: 'yes',
                  ),
                ),
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
              CustomBottomSheets()
                  .showCustomBottomSheet(size, AddDoctorAdmin(), context);
              // Navigator.pushNamed(context, '/secretaryAddClientScreen');
            },
            backgroundColor: Colors.white,
            child: SvgPicture.asset(
              'assets/images/addClient.svg',
              color: kPrimaryColor,
            ),
          ),
        ),
      ),
    );
  }
}
