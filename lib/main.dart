import 'package:clinic/screens/admin/add_secretary.dart';
import 'package:clinic/screens/admin/branches.dart';
import 'package:clinic/screens/admin/appointments_admin.dart';
import 'package:clinic/screens/admin/map.dart';
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
import 'package:clinic/screens/secretary/notificationSettings.dart';
import 'package:clinic/screens/secretary/secretaryHome.dart';
import 'package:clinic/screens/secretary/secretary_navigation.dart';
import 'package:clinic/screens/shared/reset_password.dart';
import 'package:clinic/screens/shared/search_results/appointments_search_results.dart';
import 'package:clinic/screens/shared/search_results/clients_search_results.dart';
import 'package:clinic/screens/shared/search_results/doctors_search_results.dart';
import 'package:clinic/screens/shared/wrapper.dart';
import 'package:clinic/services/auth.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:clinic/screens/admin/addDoctorAdmin.dart';
import 'package:clinic/screens/secretary/changePassword.dart';
import './screens/admin/clientsAdmin.dart';
import './screens/admin/doctorsAdmin.dart';
import './screens/admin/managersAdmin.dart';
import './screens/admin/add_branch.dart';
import './screens/admin/notificationSettings_admin.dart';
import './screens/admin/appColor.dart';
import './screens/admin/appLogo.dart';
import 'models/user.dart';
import './screens/client/booking_step1_client.dart';
import './screens/client/booking_step2_client.dart';
import './screens/doctor/notificationSettings_doctor.dart';
import './langs/codegen_loader.g.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    EasyLocalization(
      path: 'assets/langs',
      supportedLocales: [
        Locale('en'),
        Locale('ar'),
      ],
      fallbackLocale: Locale('en'),
      assetLoader: CodegenLoader(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<MyUser>.value(
          value: AuthService().user,
          initialData: null,
        ),
        // ChangeNotifierProvider.value(
        //   value: DesignElements(),
        // ),
      ],
      child: MaterialApp(
        // locale: DevicePreview.of(context).locale,
        // builder: DevicePreview.appBuilder,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
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
          ClientsAdmin.id: (context) => ClientsAdmin(),
          '/doctorsScreenAdmin': (context) => DoctorsAdmin(),
          DoctorSchedule.id: (context) => DoctorSchedule(),
          ManagersAdmin.id: (context) => ManagersAdmin(),
          '/secretaryAddClientScreen': (context) => AddClient(),
          AddDoctorSec.id: (context) => AddDoctorSec(),
          '/adminAddDoctorScreen': (context) => AddDoctorAdmin(),
          '/bookingScreen': (context) => BookAppointment(),
          AddBranch.id: (context) => AddBranch(),
          MapSelect.id: (context) => MapSelect(),
          '/appointmentsScreenAdmin': (context) => AppointmentsAdmin(),
          '/appointmentsScreenSecretary': (context) => AppointmentsSecretary(),
          Branches.id: (context) => Branches(),
          '/secretaryNavigation': (context) => SecretaryNavigation(),
          '/addSecretaryScreen': (context) => AddSecretary(),
          BookingStep1.id: (context) => BookingStep1(),
          BookingStep2.id: (context) => BookingStep2(),
          BookingStep3.id: (context) => BookingStep3(),
          BookingStep1Client.id: (context) => BookingStep1Client(),
          BookingStep2Client.id: (context) => BookingStep2Client(),
          ResetPassword.id: (context) => ResetPassword(),
          ChangePassword.id: (context) => ChangePassword(),
          ChangeAppColor.id: (context) => ChangeAppColor(),
          ChangeAppLogo.id: (context) => ChangeAppLogo(),
          NotificationSettingsManager.id: (context) =>
              NotificationSettingsManager(),
          NotificationSettingsAdmin.id: (context) =>
              NotificationSettingsAdmin(),
          NotificationSettingsDoctor.id: (context) =>
              NotificationSettingsDoctor(),
          AppLanguage.id: (context) => AppLanguage(),
          AppointmentsSearchResults.id: (context) =>
              AppointmentsSearchResults(),
          ClientsSearchresults.id: (context) => ClientsSearchresults(),
          DoctorsSearchResults.id: (context) => DoctorsSearchResults(),
          DoctorsAdmin.id: (context) => DoctorsAdmin(),
        },
      ),
    );
  }
}
