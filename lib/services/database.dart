import 'dart:io';

import 'package:clinic/models/appointment.dart';
import 'package:clinic/models/branch.dart';
import 'package:clinic/models/client.dart';
import 'package:clinic/models/doctor.dart';
import 'package:clinic/models/note.dart';
import 'package:clinic/models/manager.dart';
import 'package:clinic/models/user.dart';
import 'package:clinic/models/workDay.dart';
import 'package:clinic/models/chat.dart';
import 'package:clinic/models/message.dart';
import 'package:clinic/models/notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  List workDaysList = [
    {'name': 'monday', 'id': 1},
    {'name': 'tuesday', 'id': 2},
    {'name': 'wednesday', 'id': 3},
    {'name': 'thursday', 'id': 4},
    {'name': 'friday', 'id': 5},
    {'name': 'saturday', 'id': 6},
    {'name': 'sunday', 'id': 7},
  ];
  // collection references
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference appointmentsCollection =
      FirebaseFirestore.instance.collection('appointments');
  final CollectionReference notesCollection =
      FirebaseFirestore.instance.collection('notes');
  final CollectionReference branchesCollection =
      FirebaseFirestore.instance.collection('branches');
  final CollectionReference notificationsCollection =
      FirebaseFirestore.instance.collection('notifications');
  final CollectionReference chatsCollection =
      FirebaseFirestore.instance.collection('chats');

  UserModel _userDataFromSnapshot(DocumentSnapshot snapshot) {
    Map data = snapshot.data();
    return UserModel(
      uid: uid,
      fName: data['fName'] ?? '',
      lName: data['lName'] ?? '',
      gender: data['gender'] ?? '',
      role: data['role'] ?? '',
      countryCode: data['countryCode'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      email: data['email'] ?? '',
      picURL: data['picURL'] ?? '',
      status: data['status'] ?? 1,
      language: data['lang'] ?? 'en',
      token: data['token'] ?? '',
      bookingNotifs: data['bookingNotifs'] ?? true,
      cancellingNotifs: data['cancellingNotifs'] ?? true,
    );
  }

  Stream<UserModel> get userData {
    return usersCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

  Manager _managerFromSnapshot(DocumentSnapshot snapshot) {
    Map data = snapshot.data();
    return Manager(
      branch: data['branch'],
      uid: uid,
      fName: data['fName'] ?? '',
      lName: data['lName'] ?? '',
      gender: data['gender'] ?? '',
      role: data['role'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      countryCode: data['countryCode'] ?? '',
      countryDialCode: data['countryDialCode'] ?? '',
      email: data['email'] ?? '',
      picURL: data['picURL'] ?? '',
      status: data['status'] ?? 1,
      language: data['lang'] ?? 'en',
      // token: data['token'] ?? '',
      bookingNotifs: data['bookingNotifs'] ?? true,
      cancellingNotifs: data['cancellingNotifs'] ?? true,
      isBoss: data['isBoss'] ?? true,
    );
  }

  Stream<Manager> get manager {
    return usersCollection.doc(uid).snapshots().map(_managerFromSnapshot);
  }

  Client _clientFromSnapshot(DocumentSnapshot snapshot) {
    Map data = snapshot.data();
    return Client(
      numAppointments: data['numAppointments'] ?? 0,
      uid: uid,
      fName: data['fName'] ?? '',
      lName: data['lName'] ?? '',
      gender: data['gender'] ?? '',
      role: data['role'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      countryCode: data['countryCode'] ?? '',
      countryDialCode: data['countryDialCode'] ?? '',

      email: data['email'] ?? '',
      picURL: data['picURL'] ?? '',
      status: data['status'] ?? 1,
      language: data['lang'] ?? 'en',
      // token: data['token'] ?? '',
      bookingNotifs: data['bookingNotifs'] ?? true,
      cancellingNotifs: data['cancellingNotifs'] ?? true,
    );
  }

  Stream<Client> get client {
    return usersCollection.doc(uid).snapshots().map(_clientFromSnapshot);
  }

  Doctor _doctorFromSnapshot(DocumentSnapshot snapshot) {
    Map data = snapshot.data();
    return Doctor(
      branch: data['branch'] ?? '',
      proffesion: data['profession'] ?? '',
      about: data['about'] ?? '',
      uid: uid,
      fName: data['fName'] ?? '',
      lName: data['lName'] ?? '',
      gender: data['gender'] ?? '',
      role: data['role'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      countryCode: data['countryCode'] ?? '',
      countryDialCode: data['countryDialCode'] ?? '',
      email: data['email'] ?? '',
      picURL: data['picURL'] ?? '',
      status: data['status'] ?? 1,
      language: data['lang'] ?? 'en',
      // token: data['token'] ?? '',
      bookingNotifs: data['bookingNotifs'] ?? true,
      cancellingNotifs: data['cancellingNotifs'] ?? true,
    );
  }

  Stream<Doctor> get doctor {
    return usersCollection.doc(uid).snapshots().map(_doctorFromSnapshot);
  }

  Future updateUserProfilePicture(String picURL) async {
    await usersCollection.doc(uid).update({
      'picURL': picURL,
    });
  }

  Future updateManagerData({
    String branchID,
    String fName,
    String lName,
    String countryDialCode,
    String countryCode,
    String phoneNumber,
    String gender,
    String role,
    String password,
    String email,
    String picURL,
    bool isBoss,
    int status,
  }) async {
    return await usersCollection.doc(uid).set({
      'branch': branchID,
      'fName': fName,
      'lName': lName,
      'countryDialCode': countryDialCode,
      'countryCode': countryCode,
      'phoneNumber': phoneNumber,
      'gender': gender,
      'role': role,
      'email': email,
      'picURL': picURL,
      'status': status,
      'isBoss': isBoss,
      'lang': 'en',
      'bookingNotifs': true,
      'cancellingNotifs': true,
    });
  }

  Future updateDoctorData({
    String about,
    String profession,
    String branchID,
    String fName,
    String lName,
    String countryDialCode,
    String countryCode,
    String phoneNumber,
    String gender,
    String role,
    String password,
    String email,
    String picURL,
    int status,
  }) async {
    return await usersCollection.doc(uid).set({
      'about': about,
      'profession': profession,
      'branch': branchID,
      'fName': fName,
      'lName': lName,
      'countryDialCode': countryDialCode,
      'countryCode': countryCode,
      'phoneNumber': phoneNumber,
      'gender': gender,
      'role': role,
      'email': email,
      'picURL': picURL,
      'status': status,
      'lang': 'en',
      'bookingNotifs': true,
      'cancellingNotifs': true,
    });
  }

  Future updateClientData({
    int numAppointments,
    int age,
    String fName,
    String lName,
    String countryDialCode,
    String countryCode,
    String phoneNumber,
    String gender,
    String role,
    String password,
    String email,
    String picURL,
    int status,
  }) async {
    return await usersCollection.doc(uid).set({
      'numAppointments': numAppointments,
      'age': age,
      'fName': fName,
      'lName': lName,
      'countryDialCode': countryDialCode,
      'countryCode': countryCode,
      'phoneNumber': phoneNumber,
      'gender': gender,
      'role': role,
      'email': email,
      'picURL': picURL,
      'status': status,
      'lang': 'en',
      'bookingNotifs': true,
      'cancellingNotifs': true,
    });
  }

  Future updateBranchData({
    String branchName,
    String countryDialCode,
    String countryCode,
    String phoneNumber,
    String address,
    String managerID,
    double longitude,
    double latitude,
    int status,
  }) async {
    return await branchesCollection.doc(branchName).set({
      'name': branchName,
      'countryDialCode': countryDialCode,
      'countryCode': countryCode,
      'phoneNumber': phoneNumber,
      'address': address,
      'longitude': longitude,
      'latitude': latitude,
      'manager': managerID,
      'status': 1,
    });
  }

  Future updateBranchManager({
    String branchName,
    String oldManager,
    String newManager,
  }) async {
    await usersCollection.doc(oldManager).update({
      'isBoss': false,
    });
    await usersCollection.doc(newManager).update({
      'isBoss': true,
    });
  }

  Future editBranchData({
    String oldName,
    String branchName,
    String countryDialCode,
    String countryCode,
    String phoneNumber,
    String address,
    String managerID,
    double longitude,
    double latitude,
    int status,
  }) async {
    if (oldName != branchName) {
      await branchesCollection.doc(oldName).delete();
      await branchesCollection.doc(branchName).set({
        'name': branchName,
        'countryCode': countryCode,
        'countryDialCode': countryDialCode,
        'phoneNumber': phoneNumber,
        'address': address,
        'longitude': longitude,
        'latitude': latitude,
        'manager': managerID,
        'status': 1,
      });
      Query appointmentsQuery = appointmentsCollection;
      Future<QuerySnapshot> appointments =
          appointmentsQuery.where('branch', isEqualTo: oldName).get();
      List<Appointment> appointmentsList =
          await appointments.then((value) => value.docs.map((doc) {
                return Appointment(docID: doc.id);
              }).toList());

      for (int i = 0; i < appointmentsList.length; i++) {
        await appointmentsCollection.doc(appointmentsList[i].docID).update({
          'branch': branchName,
        });
      }

      Query doctorsQuery = usersCollection
          .where('role', isEqualTo: 'doctor')
          .where('branch', isEqualTo: oldName);
      Future<QuerySnapshot> doctors = doctorsQuery.get();
      List<Doctor> doctorsList =
          await doctors.then((value) => value.docs.map((doc) {
                return Doctor(uid: doc.id);
              }).toList());

      for (int i = 0; i < doctorsList.length; i++) {
        await usersCollection.doc(doctorsList[i].uid).update({
          'branch': branchName,
        });
      }

      Query managersQuery = usersCollection
          .where('role', isEqualTo: 'manager')
          .where('branch', isEqualTo: oldName);
      Future<QuerySnapshot> managers = managersQuery.get();
      List<Manager> managersList =
          await managers.then((value) => value.docs.map((doc) {
                return Manager(uid: doc.id);
              }).toList());

      for (int i = 0; i < managersList.length; i++) {
        await usersCollection.doc(managersList[i].uid).update({
          'branch': branchName,
        });
      }
    } else {
      await branchesCollection.doc(oldName).update({
        'countryCode': countryCode,
        'phoneNumber': phoneNumber,
        'address': address,
        'longitude': longitude,
        'latitude': latitude,
        'manager': managerID,
        'status': 1,
      });
    }
  }

  List<Branch> _branchesListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Branch(
        name: doc.data()['name'] ?? '',
        managerID: doc.data()['manager'] ?? '',
        address: doc.data()['address'] ?? '',
        countryCode: doc.data()['countryCode'] ?? '',
        countryDialCode: doc['countryDialCode'] ?? '',
        phoneNumber: doc.data()['phoneNumber'] ?? '',
        longitude: doc.data()['longitude'] ?? 0,
        latitude: doc.data()['latitude'] ?? 0,
        status: doc.data()['status'] ?? 1,
        docID: doc.id,
      );
    }).toList();
  }

  Stream<List<Branch>> getBranches({int status}) {
    Query query = branchesCollection;

    if (status != null) {
      query = query.where('status', isEqualTo: status);
    }
    return query.snapshots().map(_branchesListFromSnapshot);
  }

  List<MessageModel> _messagesFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return MessageModel(
        body: doc.data()['message'] ?? '',
        sender: doc.data()['sender'] ?? '',
        reciever: doc.data()['reciever'] ?? '',
        time: DateTime.parse(doc.data()['time'].toDate().toString()) ?? '',
        docID: doc.id,
      );
    }).toList();
  }

  Stream<List<MessageModel>> getMessages(String chatID) {
    return FirebaseFirestore.instance
        .collection("chats/" + chatID + "/messages")
        .orderBy('time')
        .snapshots()
        .map(_messagesFromSnapshot);
  }

  Future<MessageModel> getMessage(String chatID) async {
    var query = await FirebaseFirestore.instance
        .collection("chats/" + chatID + "/messages")
        .orderBy('time')
        .get();
    List<MessageModel> messages = query.docs.map((doc) {
      return MessageModel(
        sender: doc.data()['sender'] ?? '',
        reciever: doc.data()['reciever'] ?? '',
        docID: doc.id,
        time: DateTime.parse(doc.data()['time'].toDate().toString()) ?? '',
        body: doc.data()['message'] ?? '',
      );
    }).toList();
    return messages.last;
  }

  List<ChatModel> _chatsListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return ChatModel(
        user1ID: doc.data()['user1'] ?? '',
        user2ID: doc.data()['user2'] ?? '',
        docID: doc.id,
      );
    }).toList();
  }

  Stream<List<ChatModel>> getChats(bool user1) {
    if (user1) {
      return FirebaseFirestore.instance
          .collection('chats')
          .where('user1', isEqualTo: uid)
          .snapshots()
          .map(_chatsListFromSnapshot);
    } else {
      return FirebaseFirestore.instance
          .collection('chats')
          .where('user2', isEqualTo: uid)
          .snapshots()
          .map(_chatsListFromSnapshot);
    }
  }

  Future<int> getChatsLength() async {
    Future<QuerySnapshot> query =
        chatsCollection.where('user1', isEqualTo: uid).get();
    int size = await query.then((value) => value.docs.length);
    return size;
  }

  List<Appointment> _appointmentsListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Appointment(
        startTime:
            DateTime.parse(doc.data()['startTime'].toDate().toString()) ??
                '' ??
                '',
        endTime:
            DateTime.parse(doc.data()['endTime'].toDate().toString()) ?? '',
        clientID: doc.data()['clientID'] ?? '',
        doctorID: doc.data()['doctorID'] ?? '',
        day: doc.data()['day'] ?? '',
        clientFName: doc.data()['clientFName'] ?? '',
        clientLName: doc.data()['clientLName'] ?? '',
        clientGender: doc.data()['clientGender'] ?? '',
        clientPhoneNumber: doc.data()['clientPhoneNumber'] ?? '',
        doctorFName: doc.data()['doctorFName'] ?? '',
        doctorLName: doc.data()['doctorLName'] ?? '',
        status: doc.data()['status'] ?? '',
        docID: doc.id,
        branch: doc.data()['branch'] ?? '',
        doctorPicURL: doc.data()['doctorPicURL'] ?? '',
        clientPicURL: doc.data()['clientPicURL'] ?? '',
      );
    }).toList();
  }

  //TODO: Replace with getAppointments() with sufficient searching parameters
  Stream<List<Appointment>> getDoctorAppointmentsForSelectedDay(
      {String doctorID, day}) {
    return appointmentsCollection
        .where('doctorID', isEqualTo: doctorID)
        .where('day', isEqualTo: day)
        .snapshots()
        .map(_appointmentsListFromSnapshot);
  }

  Stream<List<Client>> getClients(
      {String clientName, String clientNumber, int status}) {
    Query query = usersCollection.where('role', isEqualTo: 'client');
    if (clientName != '') {
      query = query.where(
        'fName',
        isEqualTo: clientName,
      );
    }
    if (clientNumber != '') {
      query = query.where('phoneNumber', isEqualTo: clientNumber);
    }
    if (status != null) {
      query = query.where('status', isEqualTo: status);
    }
    return query.snapshots().map(_clientListFromSnapshot);
  }

  Stream<List<Doctor>> getDoctors({String branch, String doctorName}) {
    Query query = usersCollection.where('role', isEqualTo: 'doctor');
    if (doctorName != '') {
      query = query.where(
        'fName',
        isEqualTo: doctorName,
      );
    }
    if (branch != '') query = query.where('branch', isEqualTo: branch);
    return query.snapshots().map(_doctorsListFromSnapshot);
  }

  Stream<List<Appointment>> getAppointments({
    String day,
    String doctorName,
    String doctorId,
    String clientName,
    String clientNumber,
    String clientId,
    String branch,
    String status,
    String dateComparison,
  }) {
    Query query = appointmentsCollection;
    if (day != '') {
      query = query.where('day', isEqualTo: day);
    }
    if (doctorName != '') {
      query = query.where('doctorFName', isEqualTo: doctorName);
    }
    if (clientName != '') {
      query = query.where('clientFName', isEqualTo: clientName);
    }
    if (clientNumber != '') {
      query = query.where('clientPhoneNumber', isEqualTo: clientName);
    }
    if (clientId != '') {
      query = query.where('clientID', isEqualTo: clientId);
    }
    if (doctorId != '') {
      query = query.where('doctorID', isEqualTo: doctorId);
    }
    if (branch != '') {
      query = query.where('branch', isEqualTo: branch);
    }
    if (status != '') {
      query = query.where('status', isEqualTo: status);
    }
    if (dateComparison == 'Today') {
      query = query.where('day',
          isEqualTo: DateFormat("yyyy-MM-dd").format(DateTime.now()));
    } else if (dateComparison == 'Upcoming') {
      query = query.where('startTime', isGreaterThan: DateTime.now());
    } else if (dateComparison == 'Past') {
      query = query.where('startTime', isLessThan: DateTime.now());
    }

    return query.snapshots().map(_appointmentsListFromSnapshot);
  }

  Future addAppointment({
    DateTime startTime,
    String doctorID,
    String clientId,
    String clientFName,
    String clientLName,
    String clientPhoneNumber,
    String clientGender,
    String clientPicURL,
    String doctorPicURL,
    String doctorFName,
    String doctorLName,
    String doctorToken,
    String branch,
    String status,
  }) async {
    return await appointmentsCollection.doc().set({
      'startTime': startTime,
      'endTime': startTime.add(Duration(minutes: 30)),
      'clientID': clientId,
      'doctorID': doctorID,
      'day': DateFormat("yyyy-MM-dd").format(startTime),
      'clientFName': clientFName,
      'clientLName': clientLName,
      'clientGender': clientGender,
      'clientPhoneNumber': clientPhoneNumber,
      'doctorFName': doctorFName,
      'doctorLName': doctorLName,
      'doctorToken': doctorToken,
      'branch': branch,
      'clientPicURL': clientPicURL,
      'doctorPicURL': doctorPicURL,
      'status': 'active'
    });
  }

  Future addAppointmentNotifications({
    bool forClient,
    Appointment appointment,
    int status,
    int type,
  }) async {
    if (forClient) {
      await FirebaseFirestore.instance
          .collection("users/" + appointment.clientID + "/notifications")
          .doc()
          .set({
        'startTime': appointment.startTime,
        'endTime': appointment.startTime.add(Duration(minutes: 30)),
        'clientID': appointment.clientID,
        'doctorID': appointment.doctorID,
        'day': DateFormat("yyyy-MM-dd").format(appointment.startTime),
        'clientFName': appointment.clientFName,
        'clientLName': appointment.clientLName,
        'doctorFName': appointment.doctorFName,
        'doctorLName': appointment.doctorLName,
        'branch': appointment.branch,
        'clientPicURL': appointment.clientPicURL ?? '',
        'doctorPicURL': appointment.doctorPicURL,
        'status': status,
        'type': type,
      });
    } else {
      Query query = usersCollection.where('role', isEqualTo: 'manager');
      Future<QuerySnapshot> managers =
          query.where('branch', isEqualTo: appointment.branch).get();
      List<Manager> managersList =
          await managers.then((value) => value.docs.map((doc) {
                return Manager(
                  fName: doc.data()['fName'] ?? '',
                  lName: doc.data()['lName'] ?? '',
                  phoneNumber: doc.data()['phoneNumber'] ?? '',
                  gender: doc.data()['gender'] ?? '',
                  branch: doc.data()['branch'] ?? '',
                  uid: doc.id,
                  picURL: doc.data()['picURL'] ?? '',
                  status: doc.data()['status'] ?? 1,
                );
              }).toList());

      for (int i = 0; i < managersList.length; i++) {
        await FirebaseFirestore.instance
            .collection("users/" + managersList[i].uid + "/notifications")
            .doc()
            .set({
          'startTime': appointment.startTime,
          'endTime': appointment.startTime.add(Duration(minutes: 30)),
          'clientID': appointment.clientID,
          'doctorID': appointment.doctorID,
          'day': DateFormat("yyyy-MM-dd").format(appointment.startTime),
          'clientFName': appointment.clientFName,
          'clientLName': appointment.clientLName,
          'doctorFName': appointment.doctorFName,
          'doctorLName': appointment.doctorLName,
          'branch': appointment.branch,
          'clientPicURL': appointment.clientPicURL,
          'status': status,
          'type': type,
        });
      }
    }

    await FirebaseFirestore.instance
        .collection("users/" + appointment.doctorID + "/notifications")
        .doc()
        .set({
      'startTime': appointment.startTime,
      'endTime': appointment.startTime.add(Duration(minutes: 30)),
      'clientID': appointment.clientID,
      'doctorID': appointment.doctorID,
      'day': DateFormat("yyyy-MM-dd").format(appointment.startTime),
      'clientFName': appointment.clientFName,
      'clientLName': appointment.clientLName,
      'doctorFName': appointment.doctorFName,
      'doctorLName': appointment.doctorLName,
      'branch': appointment.branch,
      'clientPicURL': appointment.clientPicURL,
      'status': status,
      'type': type,
    });
  }

  List<NotificationModel> _notificationsListFromSnapshot(
      QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return NotificationModel(
        startTime:
            DateTime.parse(doc.data()['startTime'].toDate().toString()) ??
                '' ??
                '',
        endTime:
            DateTime.parse(doc.data()['endTime'].toDate().toString()) ?? '',
        clientID: doc.data()['clientID'] ?? '',
        doctorID: doc.data()['doctorID'] ?? '',
        day: doc.data()['day'] ?? '',
        clientFName: doc.data()['clientFName'] ?? '',
        clientLName: doc.data()['clientLName'] ?? '',
        clientGender: doc.data()['clientGender'] ?? '',
        clientPhoneNumber: doc.data()['clientPhoneNumber'] ?? '',
        doctorFName: doc.data()['doctorFName'] ?? '',
        doctorLName: doc.data()['doctorLName'] ?? '',
        status: doc.data()['status'] ?? 1,
        type: doc.data()['type'] ?? 1,
        docID: doc.id,
        doctorPicURL: doc.data()['doctorPicURL'] ?? '',
        clientPicURL: doc.data()['clientPicURL'] ?? '',
      );
    }).toList();
  }

  Stream<List<NotificationModel>> getNotifications({int status}) {
    Query query = FirebaseFirestore.instance
        .collection("users/" + uid + "/notifications");
    if (status != null) {
      query = query.where(
        'status',
        isEqualTo: status,
      );
    }

    return query.snapshots().map(_notificationsListFromSnapshot);
  }

  Future updateNotificationStatus({int status, String docID}) async {
    try {
      await FirebaseFirestore.instance
          .collection("users/" + uid + "/notifications")
          .doc(docID)
          .update({
        'status': status,
      });
      return 1;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  List<Note> _notesListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Note(
        submissionTime: doc.data()['submissionTime'] ?? '',
        clientID: doc.data()['clientID'] ?? '',
        doctorID: doc.data()['doctorID'] ?? '',
        clientFName: doc.data()['clientFName'] ?? '',
        clientLName: doc.data()['clientLName'] ?? '',
        doctorFName: doc.data()['doctorFName'] ?? '',
        doctorLName: doc.data()['doctorLName'] ?? '',
        doctorPicUrl: doc.data()['doctorPicUrl'] ?? '',
        doctorProfession: doc.data()['doctorProfession'] ?? '',
        body: doc.data()['body'] ?? '',
      );
    }).toList();
  }

//TODO: Merge both functions into getNotes()
  Stream<List<Note>> getClientNotes(String clientId) {
    return notesCollection
        .where('clientID', isEqualTo: clientId)
        .snapshots()
        .map(_notesListFromSnapshot);
  }

  Stream<List<Note>> getDoctorNotes(String doctorID) {
    return notesCollection
        .where('doctorID', isEqualTo: doctorID)
        .snapshots()
        .map(_notesListFromSnapshot);
  }

  static Future updateAppointmentNote({
    String note,
    String appointmentID,
  }) async {
    try {
      await DatabaseService().appointmentsCollection.doc(appointmentID).update({
        'note': note,
      });
      return 1;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future addNote({
    String day,
    String doctorID,
    String clientID,
    String doctorFName,
    String clientFName,
    String doctorLName,
    String clientLName,
    String doctorProfession,
    String body,
    String doctorPicUrl,
  }) async {
    return await notesCollection.doc().set({
      'submissionTime': DateFormat("yyyy-MM-dd").format(DateTime.now()),
      'clientID': clientID,
      'doctorID': doctorID,
      'clientFName': clientFName,
      'doctorFName': doctorFName,
      'clientLName': clientLName,
      'doctorLName': doctorLName,
      'body': body,
      'doctorPicUrl': doctorPicUrl,
      'doctorProfession': doctorProfession,
    });
  }

  Future updateDoctorWorkDays() async {
    workDaysList.forEach((element) {
      FirebaseFirestore.instance
          .collection("users/" + uid + "/workDays")
          .doc(element['name'])
          .set({
        'working': false,
        'startHour': '00',
        'startMin': '00',
        'endHour': '00',
        'endMin': '00',
        'dayID': element['id'],
      });
    });
  }

  // clients list from snapshot
  List<Client> _clientListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Client(
        numAppointments: doc.data()['numAppointments'] ?? 0,
        age: doc.data()['age'] ?? 0,
        uid: doc.id,
        fName: doc['fName'] ?? '',
        lName: doc['lName'] ?? '',
        gender: doc['gender'] ?? '',
        role: doc['role'] ?? '',
        countryDialCode: doc['countryDialCode'] ?? '',
        countryCode: doc['countryCode'] ?? '',
        phoneNumber: doc['phoneNumber'] ?? '',
        email: doc['email'] ?? '',
        picURL: doc['picURL'] ?? '',
        status: doc['status'] ?? 1,
        language: doc['lang'] ?? 'en',
        // token: doc['token'] ?? '',
        bookingNotifs: doc['bookingNotifs'] ?? true,
        cancellingNotifs: doc['cancellingNotifs'] ?? true,
      );
    }).toList();
  }

  // Secretaries list from snapshot
  List<Manager> _managersListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Manager(
        isBoss: doc['isBoss'] ?? true,
        branch: doc['branch'] ?? '',
        uid: doc.id,
        fName: doc['fName'] ?? '',
        lName: doc['lName'] ?? '',
        gender: doc['gender'] ?? '',
        role: doc['role'] ?? '',
        countryCode: doc['countryCode'] ?? '',
        countryDialCode: doc['countryDialCode'] ?? '',
        phoneNumber: doc['phoneNumber'] ?? '',
        email: doc['email'] ?? '',
        picURL: doc['picURL'] ?? '',
        status: doc['status'] ?? 1,
        language: doc['lang'] ?? 'en',
        // token: doc['token'] ?? '',
        bookingNotifs: doc['bookingNotifs'] ?? true,
        cancellingNotifs: doc['cancellingNotifs'] ?? true,
      );
    }).toList();
  }

  List<Doctor> _doctorsListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Doctor(
        about: doc.data()['about'] ?? '',
        proffesion: doc.data()['profession'] ?? '',
        uid: doc.id,
        fName: doc['fName'] ?? '',
        lName: doc['lName'] ?? '',
        gender: doc['gender'] ?? '',
        role: doc['role'] ?? '',
        countryCode: doc['countryCode'] ?? '',
        countryDialCode: doc['countryDialCode'] ?? '',
        branch: doc['branch'] ?? '',
        phoneNumber: doc['phoneNumber'] ?? '',
        email: doc['email'] ?? '',
        picURL: doc['picURL'] ?? '',
        status: doc['status'] ?? 1,
        language: doc['lang'] ?? 'en',
        // token: doc['token'] ?? '',
        bookingNotifs: doc['bookingNotifs'] ?? true,
        cancellingNotifs: doc['cancellingNotifs'] ?? true,
      );
    }).toList();
  }

  Stream<List<Manager>> getManagers(
      {String managerName, String managerNumber, String branch}) {
    Query query = usersCollection.where('role', isEqualTo: 'manager');
    if (managerName != '') {
      query = query.where(
        'fName',
        isEqualTo: managerName,
      );
    }
    if (managerNumber != '') {
      query = query.where('phoneNumber', isEqualTo: managerNumber);
    }

    if (branch != '') {
      query = query.where('branch', isEqualTo: branch);
    }

    return query.snapshots().map(_managersListFromSnapshot);
  }

  // workDays list from snapshot
  List<WorkDay> _workDaysListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return WorkDay(
          docID: doc.id,
          startHour: doc.data()['startHour'] ?? '',
          endHour: doc.data()['endHour'] ?? '',
          startMin: doc.data()['startMin'] ?? '',
          endMin: doc.data()['endMin'] ?? '',
          enabled: doc.data()['working'] ?? false,
          dayID: doc.data()['dayID'] ?? '0');
    }).toList();
  }

  // get workDays stream
  Stream<List<WorkDay>> getWorkDays(String doctorID) {
    return FirebaseFirestore.instance
        .collection("users/" + doctorID + "/workDays")
        .snapshots()
        .map(_workDaysListFromSnapshot);
  }

  static Future updateWorkDayHours({
    String doctorID,
    startHour,
    startMin,
    endHour,
    endMin,
    documentID,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection("users/" + doctorID + "/workDays")
          .doc(documentID)
          .update({
        'working': true,
        'startHour': startHour,
        'startMin': startMin,
        'endHour': endHour,
        'endMin': endMin,
      });
      return 1;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  static Future updateWorkDayStatus({
    bool working,
    String doctorID,
    documentID,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection("users/" + doctorID + "/workDays")
          .doc(documentID)
          .update({
        'working': working,
      });
      return 1;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  static Future updateClientRemainingSessions({
    int numAppointments,
    String documentID,
  }) async {
    try {
      await DatabaseService().usersCollection.doc(documentID).update({
        'numAppointments': numAppointments,
      });
      return 1;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future setToken(String role) async {
    FirebaseMessaging _messaging = FirebaseMessaging.instance;
    String deviceToken = await _messaging.getToken();
    await usersCollection.doc(uid).update({
      'token': deviceToken,
    });
  }

  // get user role
  Future<int> getSpecificClientRemainingSessions(String id) async {
    DocumentSnapshot s = await usersCollection.doc(id).get();
    return s.data()['numAppointments'];
  }

  Future<String> getManagerBranch() async {
    DocumentSnapshot s = await usersCollection.doc(uid).get();
    return s.data()['branch'];
  }

  Future<Client> getClient() async {
    DocumentSnapshot s = await usersCollection.doc(uid).get();
    Client client = Client(
      fName: s.data()['fName'],
      lName: s.data()['lName'],
      phoneNumber: s.data()['phoneNumber'],
      gender: s.data()['gender'],
      uid: uid,
      numAppointments: s.data()['numAppointments'],
      age: s.data()['age'],
    );
    return client;
  }

  Future<Manager> getManager() async {
    DocumentSnapshot s = await usersCollection.doc(uid).get();
    Manager manager = Manager(
      fName: s.data()['fName'],
      lName: s.data()['lName'],
      phoneNumber: s.data()['phoneNumber'],
      gender: s.data()['gender'],
      uid: uid,
      branch: s.data()['branch'],
      picURL: s.data()['picURL'],
    );
    return manager;
  }

  Future<Appointment> getAppointment(String id) async {
    DocumentSnapshot doc = await appointmentsCollection.doc(id).get();
    Appointment appointment = Appointment(
      startTime: DateTime.parse(doc.data()['startTime'].toDate().toString()) ??
          '' ??
          '',
      endTime: DateTime.parse(doc.data()['endTime'].toDate().toString()) ?? '',
      clientID: doc.data()['clientID'] ?? '',
      doctorID: doc.data()['doctorID'] ?? '',
      day: doc.data()['day'] ?? '',
      clientFName: doc.data()['clientFName'] ?? '',
      clientLName: doc.data()['clientLName'] ?? '',
      clientGender: doc.data()['clientGender'] ?? '',
      clientPhoneNumber: doc.data()['clientPhoneNumber'] ?? '',
      doctorFName: doc.data()['doctorFName'] ?? '',
      doctorLName: doc.data()['doctorLName'] ?? '',
      status: doc.data()['status'] ?? '',
      docID: doc.id,
      doctorPicURL: doc.data()['doctorPicURL'] ?? '',
      clientPicURL: doc.data()['clientPicURL'] ?? '',
    );

    return appointment;
  }

  Future<String> getChat(String user1, String user2) async {
    Query query = chatsCollection
        .where('user1', isEqualTo: user1)
        .where('user2', isEqualTo: user2);
    Query query2 = chatsCollection
        .where('user2', isEqualTo: user1)
        .where('user1', isEqualTo: user2);

    Future<QuerySnapshot> chats = query.get();
    List<ChatModel> chatsList =
        await chats.then((value) => value.docs.map((doc) {
              return ChatModel(
                docID: doc.id,
                user1ID: doc.data()['user1'],
                user2ID: doc.data()['user2'],
              );
            }).toList());
    Future<QuerySnapshot> chats2 = query2.get();
    List<ChatModel> chatsList2 =
        await chats2.then((value) => value.docs.map((doc) {
              return ChatModel(
                docID: doc.id,
                user1ID: doc.data()['user1'],
                user2ID: doc.data()['user2'],
              );
            }).toList());
    if (chatsList.length != 0) {
      return chatsList.first.docID;
    } else {
      if (chatsList2.length != 0) {
        return chatsList2.first.docID;
      }
      String chatID = chatsCollection.doc().id;
      await chatsCollection.doc(chatID).set({
        'user1': user1,
        'user2': user2,
      });
      return chatID;
    }
  }

  Future sendMessage({
    String user1,
    String user2,
    String message,
    String existingChatID,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection("chats/" + existingChatID + "/messages")
          .doc()
          .set({
        'sender': user1,
        'reciever': user2,
        'message': message,
        'time': FieldValue.serverTimestamp(),
      });
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future updateAppointmentStatus({
    String id,
    String status,
  }) async {
    try {
      await appointmentsCollection.doc(id).update({
        'status': status,
      });
      return 1;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future updateBranchStatus({
    String id,
    int status,
  }) async {
    try {
      await branchesCollection.doc(id).update({
        'status': status,
      });
      if (status == 0) {
        Query appointmentsQuery = appointmentsCollection;
        Future<QuerySnapshot> appointments =
            appointmentsQuery.where('branch', isEqualTo: id).get();
        List<Appointment> appointmentsList =
            await appointments.then((value) => value.docs.map((doc) {
                  return Appointment(docID: doc.id);
                }).toList());

        for (int i = 0; i < appointmentsList.length; i++) {
          await appointmentsCollection.doc(appointmentsList[i].docID).update({
            'status': 0,
          });
        }

        Query doctorsQuery = usersCollection
            .where('role', isEqualTo: 'doctor')
            .where('branch', isEqualTo: id);
        Future<QuerySnapshot> doctors = doctorsQuery.get();
        List<Doctor> doctorsList =
            await doctors.then((value) => value.docs.map((doc) {
                  return Doctor(uid: doc.id);
                }).toList());

        for (int i = 0; i < doctorsList.length; i++) {
          await usersCollection.doc(doctorsList[i].uid).update({
            'status': 0,
          });
          await usersCollection.doc(doctorsList[i].uid).update({
            'status': status,
          });
        }

        Query managersQuery = usersCollection
            .where('role', isEqualTo: 'manager')
            .where('branch', isEqualTo: id);
        Future<QuerySnapshot> managers = managersQuery.get();
        List<Manager> managersList =
            await managers.then((value) => value.docs.map((doc) {
                  return Manager(uid: doc.id);
                }).toList());

        for (int i = 0; i < managersList.length; i++) {
          await usersCollection.doc(managersList[i].uid).update({
            'status': 0,
          });
          await usersCollection.doc(managersList[i].uid).update({
            'status': status,
          });
        }
      }
      return 1;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future updateUserStatus(String role, int status) async {
    try {
      await usersCollection.doc(uid).update({
        'status': status,
      });
      if (role == 'client') {
        if (status == 0) {
          Query query = appointmentsCollection;
          Future<QuerySnapshot> appointments =
              query.where('clientID', isEqualTo: uid).get();
          List<Appointment> appointmentsList =
              await appointments.then((value) => value.docs.map((doc) {
                    return Appointment(docID: doc.id);
                  }).toList());

          for (int i = 0; i < appointmentsList.length; i++) {
            await appointmentsCollection.doc(appointmentsList[i].docID).update({
              'status': 0,
            });
          }
        }
      } else if (role == 'doctor') {
        if (status == 0) {
          Query query = appointmentsCollection;
          Future<QuerySnapshot> appointments =
              query.where('doctorID', isEqualTo: uid).get();
          List<Appointment> appointmentsList =
              await appointments.then((value) => value.docs.map((doc) {
                    return Appointment(docID: doc.id);
                  }).toList());

          for (int i = 0; i < appointmentsList.length; i++) {
            await appointmentsCollection.doc(appointmentsList[i].docID).update({
              'status': 0,
            });
          }
        }
      }
      return 1;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future updateUserLang(String lang) async {
    try {
      await usersCollection.doc(uid).update({
        'lang': lang,
      });
      return 1;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future updateNotificationsSettings(String type, bool value) async {
    try {
      if (type == 'cancellingNotifs') {
        await usersCollection.doc(uid).update({
          'cancellingNotifs': value,
        });
      } else {
        await usersCollection.doc(uid).update({
          'bookingNotifs': value,
        });
      }
      return 1;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future<String> uploadImage(File newProfilePic) async {
    if (newProfilePic != null) {
      final Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child('profilePics/$uid.jpg');
      UploadTask task = firebaseStorageRef.putFile(newProfilePic);
      TaskSnapshot taskSnapshot = await task;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } else {
      return '';
    }
  }
}
