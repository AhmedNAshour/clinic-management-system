import 'package:clinic/screens/admin/add_secretary.dart';
import 'package:clinic/screens/admin/branches.dart';
import 'package:clinic/screens/admin/appointments_admin.dart';
import 'package:clinic/screens/admin/map.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import './screens/admin/mapEdit.dart';
import 'package:clinic/screens/client/client_home.dart';
import 'package:clinic/screens/manager/addClient.dart';
import 'package:clinic/screens/manager/addDoctorSecretary.dart';
import 'package:clinic/screens/manager/appointments_secretary.dart';
import 'package:clinic/screens/manager/booking_step1.dart';
import 'package:clinic/screens/manager/booking_step2.dart';
import 'package:clinic/screens/manager/booking_step3.dart';
import 'package:clinic/screens/manager/doctorSchedule.dart';
import 'package:clinic/screens/manager/secretaryHome.dart';
import 'package:clinic/screens/manager/secretary_navigation.dart';
import 'package:clinic/screens/shared/login.dart';
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
import './screens/admin/clientsAdmin.dart';
import './screens/admin/doctorsAdmin.dart';
import './screens/admin/managersAdmin.dart';
import './screens/admin/add_branch.dart';
import 'models/user.dart';
import 'screens/admin/edit_branch.dart';
import './screens/client/booking_step1_client.dart';
import './screens/client/booking_step2_client.dart';
import './langs/codegen_loader.g.dart';
import './screens/shared/chat_room.dart';
import 'package:device_preview/device_preview.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
  print(message.data);
  flutterLocalNotificationsPlugin.show(
      message.data.hashCode,
      message.data['title'],
      message.data['body'],
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channel.description,
        ),
      ));
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  runApp(
    EasyLocalization(
      path: 'assets/langs',
      supportedLocales: [
        Locale('en'),
        Locale('ar'),
      ],
      fallbackLocale: Locale('en'),
      assetLoader: CodegenLoader(),
      child: DevicePreview(
        builder: (context) => MyApp(),
        enabled: !kReleaseMode,
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  //  var initialzationSettingsAndroid =

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    var initialzationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: initialzationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                icon: android?.smallIcon,
              ),
            ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiProvider(
      providers: [
        StreamProvider<AuthUser>.value(
          value: AuthService().user,
          initialData: null,
        ),
      ],
      child: MaterialApp(
        locale: DevicePreview.locale(context), // Add the locale here
        builder: DevicePreview.appBuilder,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        // locale: context.locale,
        theme: ThemeData(
          fontFamily: 'Roboto',
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => Wrapper(),
          Login.id: (context) => Login(),
          '/clientHomeScreen': (context) => ClientHome(),
          '/secretaryHomeScreen': (context) => SecretaryHome(),
          ClientsAdmin.id: (context) => ClientsAdmin(),
          '/doctorsScreenAdmin': (context) => DoctorsAdmin(),
          DoctorSchedule.id: (context) => DoctorSchedule(),
          ManagersAdmin.id: (context) => ManagersAdmin(),
          '/secretaryAddClientScreen': (context) => AddClient(),
          AddDoctorSec.id: (context) => AddDoctorSec(),
          '/adminAddDoctorScreen': (context) => AddDoctorAdmin(),
          AddBranch.id: (context) => AddBranch(),
          EditBranch.id: (context) => EditBranch(),
          MapSelect.id: (context) => MapSelect(),
          MapEdit.id: (context) => MapEdit(),
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
          ChatRoom.id: (context) => ChatRoom(),
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
