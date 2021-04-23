import 'package:clinic/components/lists_cards/doctors_list.dart';
import 'package:clinic/langs/locale_keys.g.dart';
import 'package:clinic/models/doctor.dart';
import 'package:clinic/models/user.dart';
import 'package:clinic/screens/shared/constants.dart';
import 'package:clinic/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class BookingStep1Client extends StatefulWidget {
  static const id = 'bookingStep1Client';

  @override
  _BookingStep1ClientState createState() => _BookingStep1ClientState();
}

class _BookingStep1ClientState extends State<BookingStep1Client> {
  var textController = new TextEditingController();
  String search = '';
  bool showCancel = false;
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthUser>(context);
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
                height: size.height * 0.1,
                width: double.infinity,
                color: kPrimaryColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    BackButton(
                      color: Colors.white,
                    ),
                    SizedBox(width: size.width * 0.1),
                    Text(
                      LocaleKeys.bookAppointment.tr(),
                      style: TextStyle(
                        fontSize: size.width * 0.06,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: size.height * 0.02),
              Text(
                LocaleKeys.selectDoctor.tr(),
                style: TextStyle(
                  color: kPrimaryTextColor,
                  fontSize: size.width * 0.05,
                ),
              ),
              SizedBox(height: size.height * 0.1),
              Container(
                height: size.height * 0.7,
                child: MultiProvider(
                  providers: [
                    StreamProvider<List<Doctor>>.value(
                      value: DatabaseService()
                          .getDoctors(branch: '', doctorName: ''),
                    ),
                    StreamProvider<UserModel>.value(
                      value: DatabaseService(uid: user.uid).userData,
                    ),
                  ],
                  child: DoctorList.booking(
                    client: null,
                    isClientBooking: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
