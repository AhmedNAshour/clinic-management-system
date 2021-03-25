import 'package:clinic/screens/admin/add_secretary.dart';
import 'package:clinic/screens/admin/branches.dart';
import 'package:clinic/screens/admin/clients_admin.dart';
import 'package:clinic/screens/admin/secretaries.dart';
import 'package:clinic/screens/admin/appointments_admin.dart';
import 'package:clinic/screens/client/book_appointment.dart';
import 'package:clinic/screens/client/client_home.dart';
import 'package:clinic/screens/secretary/addClient.dart';
import 'package:clinic/screens/secretary/addDoctorSecretary.dart';
import 'package:clinic/screens/secretary/appLanguage.dart';
import 'package:clinic/screens/secretary/appointments_secretary.dart';
import 'package:clinic/screens/secretary/booking_step1.dart';
import 'package:clinic/screens/secretary/booking_step2.dart';
import 'package:clinic/screens/secretary/booking_step3.dart';
import 'package:clinic/screens/secretary/clients.dart';
import 'package:clinic/screens/secretary/doctorSchedule.dart';
import 'package:clinic/screens/secretary/doctors_admin.dart';
import 'package:clinic/screens/secretary/notificationSettings.dart';
import 'package:clinic/screens/secretary/secretaryHome.dart';
import 'package:clinic/screens/secretary/secretary_navigation.dart';
import 'package:clinic/screens/shared/reset_password.dart';
import 'package:clinic/screens/shared/search_results/appointments_search_results.dart';
import 'package:clinic/screens/shared/search_results/clients_search_results.dart';
import 'package:clinic/screens/shared/search_results/doctors_search_results.dart';
import 'package:clinic/screens/shared/wrapper.dart';
import 'package:clinic/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:clinic/screens/admin/addDoctorAdmin.dart';
import 'package:clinic/screens/secretary/changePassword.dart';
import 'models/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<MyUser>.value(value: AuthService().user),
      ],
      child: MaterialApp(
        // locale: DevicePreview.of(context).locale,
        // builder: DevicePreview.appBuilder,
        theme: ThemeData(
          fontFamily: 'Roboto',
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => Wrapper(),
          '/clientHomeScreen': (context) => ClientHome(),
          '/secretaryHomeScreen': (context) => SecretaryHome(),
          '/clientsScreen': (context) => Clients(),
          '/clientsScreenAdmin': (context) => ClientsAdmin(),
          '/doctorsScreenAdmin': (context) => DoctorsAdmin(),
          DoctorSchedule.id: (context) => DoctorSchedule(),
          '/secretaryAddClientScreen': (context) => AddClient(),
          AddDoctorSec.id: (context) => AddDoctorSec(),
          '/adminAddDoctorScreen': (context) => AddDoctorAdmin(),
          '/bookingScreen': (context) => BookAppointment(),
          '/appointmentsScreenAdmin': (context) => AppointmentsAdmin(),
          '/appointmentsScreenSecretary': (context) => AppointmentsSecretary(),
          '/branchesScreen': (context) => Branches(),
          '/secretariesScreen': (context) => Secretaries(),
          '/secretaryNavigation': (context) => SecretaryNavigation(),
          '/addSecretaryScreen': (context) => AddSecretary(),
          BookingStep1.id: (context) => BookingStep1(),
          BookingStep2.id: (context) => BookingStep2(),
          BookingStep3.id: (context) => BookingStep3(),
          ResetPassword.id: (context) => ResetPassword(),
          ChangePassword.id: (context) => ChangePassword(),
          NotificationSettings.id: (context) => NotificationSettings(),
          AppLanguage.id: (context) => AppLanguage(),
          AppointmentsSearchResults.id: (context) =>
              AppointmentsSearchResults(),
          ClientsSearchresults.id: (context) => ClientsSearchresults(),
          DoctorsSearchResults.id: (context) => DoctorsSearchResults(),
        },
      ),
    );
  }
}
