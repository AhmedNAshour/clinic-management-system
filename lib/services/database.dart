import 'package:clinic/models/appointment.dart';
import 'package:clinic/models/branch.dart';
import 'package:clinic/models/client.dart';
import 'package:clinic/models/doctor.dart';
import 'package:clinic/models/note.dart';
import 'package:clinic/models/secretary.dart';
import 'package:clinic/models/user.dart';
import 'package:clinic/models/workDay.dart';
import 'package:clinic/models/notification.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
  final CollectionReference clientsCollection =
      FirebaseFirestore.instance.collection('clients');
  final CollectionReference doctorsCollection =
      FirebaseFirestore.instance.collection('doctors');
  final CollectionReference secretariesCollection =
      FirebaseFirestore.instance.collection('secretaries');
  final CollectionReference appointmentsCollection =
      FirebaseFirestore.instance.collection('appointments');
  final CollectionReference notesCollection =
      FirebaseFirestore.instance.collection('notes');
  final CollectionReference branchesCollection =
      FirebaseFirestore.instance.collection('branches');
  final CollectionReference notificationsCollection =
      FirebaseFirestore.instance.collection('notifications');

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    Map data = snapshot.data();
    return UserData(
      uid: uid,
      fName: data['fName'] ?? '',
      lName: data['lName'] ?? '',
      gender: data['gender'] ?? '',
      role: data['role'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      password: data['password'] ?? '',
      email: data['email'] ?? '',
      picURL: data['picURL'] ?? '',
      status: data['status'] ?? 1,
      language: data['lang'] ?? 'en',
      token: data['token'] ?? '',
      bookingNotifs: data['bookingNotifs'] ?? true,
      cancellingNotifs: data['cancellingNotifs'] ?? true,
    );
  }

  Secretary _secretaryFromSnapshot(DocumentSnapshot snapshot) {
    Map data = snapshot.data();
    return Secretary(
      uid: uid,
      fName: data['fName'],
      lName: data['lName'],
      gender: data['gender'],
      phoneNumber: data['phoneNumber'],
      picURL: data['picURL'],
      token: data['token'],
      branch: data['branch'],
      branchName: data['branchName'],
      status: data['status'] ?? 1,
    );
  }

  Stream<Secretary> get secretary {
    return secretariesCollection
        .doc(uid)
        .snapshots()
        .map(_secretaryFromSnapshot);
  }

  Client _clientFromSnapshot(DocumentSnapshot snapshot) {
    Map data = snapshot.data();
    return Client(
      uid: uid,
      fName: data['fName'] ?? '',
      lName: data['lName'] ?? '',
      gender: data['gender'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      picURL: data['picURL'] ?? '',
      numAppointments: data['numAppointments'] ?? 0,
      age: data['age'] ?? 0,
      status: data['status'] ?? 1,
    );
  }

  Stream<Client> get client {
    return clientsCollection.doc(uid).snapshots().map(_clientFromSnapshot);
  }

  Doctor _doctorFromSnapshot(DocumentSnapshot snapshot) {
    Map data = snapshot.data();
    return Doctor(
      uid: uid,
      fName: data['fName'] ?? '',
      lName: data['lName'] ?? '',
      gender: data['gender'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      picURL: data['picURL'] ?? '',
      branch: data['branch'] ?? '',
      proffesion: data['profession'] ?? '',
      about: data['about'] ?? '',
      status: data['status'] ?? 1,
    );
  }

  Stream<Doctor> get doctor {
    return doctorsCollection.doc(uid).snapshots().map(_doctorFromSnapshot);
  }

  Stream<UserData> get userData {
    return usersCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

  // create or update user
  Future updateUserData(
    String fName,
    String lName,
    String phoneNumber,
    String gender,
    String role,
    String password,
    String email,
    String picURL,
    int status,
  ) async {
    return await usersCollection.doc(uid).set({
      'fName': fName,
      'lName': lName,
      'phoneNumber': phoneNumber,
      'gender': gender,
      'role': role,
      'password': password,
      'email': email,
      'picURL': picURL,
      'status': status,
    });
  }

  static Future disableUser({
    int status,
    String documentID,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(documentID)
          .update({
        'status': status,
      });
      return 1;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  static Future updateManagerStatus({
    int status,
    String documentID,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(documentID)
          .update({
        'status': status,
      });
      return 1;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future updateUserProfilePicture(String picURL, role) async {
    await usersCollection.doc(uid).update({
      'picURL': picURL,
    });
    if (role == 'secretary') {
      await secretariesCollection.doc(uid).update({
        'picURL': picURL,
      });
    } else if (role == 'client') {
      await clientsCollection.doc(uid).update({
        'picURL': picURL,
      });
    } else if (role == 'doctor') {
      await doctorsCollection.doc(uid).update({
        'picURL': picURL,
      });
    }
  }

  Future editToken(String token, role) async {
    if (role == 'doctor') {
      return await doctorsCollection.doc(uid).set({
        'token': token,
      });
    } else if (role == 'client') {
      return await clientsCollection.doc(uid).set({
        'token': token,
      });
    } else if (role == 'secretary') {
      return await secretariesCollection.doc(uid).set({
        'token': token,
      });
    }
  }

  Future updateSecretaryData({
    String fName,
    String lName,
    String phoneNumber,
    String gender,
    String branchId,
    String branchName,
    String picURL,
    int status,
  }) async {
    return await secretariesCollection.doc(uid).set({
      'fName': fName,
      'lName': lName,
      'phoneNumber': phoneNumber,
      'gender': gender,
      'branch': branchId,
      'branchName': branchName,
      'picURL': picURL,
      'status': 1,
    });
  }

  Future updateDoctorData({
    String fName,
    lName,
    phoneNumber,
    gender,
    about,
    profession,
    branch,
    picURL,
    int status,
  }) async {
    return await doctorsCollection.doc(uid).set({
      'fName': fName,
      'lName': lName,
      'phoneNumber': phoneNumber,
      'gender': gender,
      'about': about,
      'profession': profession,
      'branch': branch,
      'status': 1,
      'picURL': picURL,
    });
  }

  Future addBranch({
    String branchName,
    String phoneNumber,
    String address,
    double longitude,
    double latitude,
  }) async {
    return await branchesCollection.doc(branchName).set({
      'name': branchName,
      'phoneNumber': phoneNumber,
      'address': address,
      'logitude': longitude,
      'latitude': latitude,
    });
  }

  List<Branch> _branchesListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Branch(
        name: doc.data()['name'] ?? '',
        address: doc.data()['address'] ?? '',
        phoneNumber: doc.data()['phoneNumber'] ?? '',
        longitude: doc.data()['longitude'] ?? 0,
        latitude: doc.data()['latitude'] ?? 0,
        docID: doc.id,
      );
    }).toList();
  }

  Stream<List<Branch>> get branches {
    return branchesCollection.snapshots().map(_branchesListFromSnapshot);
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
        doctorPicURL: doc.data()['doctorPicURL'] ?? '',
        clientPicURL: doc.data()['clientPicURL'] ?? '',
      );
    }).toList();
  }

  Stream<List<Appointment>> getDoctorAppointmentsForSelectedDay(
      String doctorID, day) {
    return appointmentsCollection
        .where('doctorID', isEqualTo: doctorID)
        .where('day', isEqualTo: day)
        .snapshots()
        .map(_appointmentsListFromSnapshot);
  }

  Stream<List<Doctor>> getDoctorsByBranch(branch) {
    return doctorsCollection
        .where('branch', isEqualTo: branch)
        .snapshots()
        .map(_doctorsListFromSnapshot);
  }

  Stream<List<Client>> getClientsBySearch(
      String clientName, String clientNumber, int status) {
    Query query = FirebaseFirestore.instance.collection('clients');
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

  Stream<List<Doctor>> getDoctorsBySearch(
      String secretaryBranch, String doctorName) {
    Query query = FirebaseFirestore.instance.collection('doctors');
    if (doctorName != '') {
      query = query.where(
        'fName',
        isEqualTo: doctorName,
      );
    }
    if (secretaryBranch != '')
      query = query.where('branch', isEqualTo: secretaryBranch);
    return query.snapshots().map(_doctorsListFromSnapshot);
  }

  Stream<List<Appointment>> getAppointmentsBySearch({
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
    Query query = FirebaseFirestore.instance.collection('appointments');
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

  Stream<List<Appointment>> getAppointmentsForSelectedDay(String day) {
    return appointmentsCollection
        .where('day', isEqualTo: day)
        .snapshots()
        .map(_appointmentsListFromSnapshot);
  }

  Stream<List<Appointment>> getAppointmentsForClient() {
    return appointmentsCollection
        .where('clientID', isEqualTo: uid)
        .snapshots()
        .map(_appointmentsListFromSnapshot);
  }

  Stream<List<Appointment>> get appointments {
    return appointmentsCollection
        .snapshots()
        .map(_appointmentsListFromSnapshot);
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
    DateTime startTime,
    String doctorID,
    String clientID,
    String clientFName,
    String clientLName,
    String clientPicURL,
    String doctorPicURL,
    String doctorFName,
    String doctorLName,
    String branch,
    int status,
    int type,
  }) async {
    if (type == 0) {
      await FirebaseFirestore.instance
          .collection("users/" + clientID + "/notifications")
          .doc()
          .set({
        'startTime': startTime,
        'endTime': startTime.add(Duration(minutes: 30)),
        'clientID': clientID,
        'doctorID': doctorID,
        'day': DateFormat("yyyy-MM-dd").format(startTime),
        'clientFName': clientFName,
        'clientLName': clientLName,
        'doctorFName': doctorFName,
        'doctorLName': doctorLName,
        'branch': branch,
        'clientPicURL': clientPicURL,
        'doctorPicURL': doctorPicURL,
        'status': status,
        'type': type,
      });
    }
    await FirebaseFirestore.instance
        .collection("users/" + doctorID + "/notifications")
        .doc()
        .set({
      'startTime': startTime,
      'endTime': startTime.add(Duration(minutes: 30)),
      'clientID': clientID,
      'doctorID': doctorID,
      'day': DateFormat("yyyy-MM-dd").format(startTime),
      'clientFName': clientFName,
      'clientLName': clientLName,
      'doctorFName': doctorFName,
      'doctorLName': doctorLName,
      'branch': branch,
      'clientPicURL': clientPicURL,
      'status': status,
      'type': type,
    });
    Query query = FirebaseFirestore.instance.collection('secretaries');
    Future<QuerySnapshot> managers =
        query.where('branch', isEqualTo: branch).get();
    List<Secretary> secretaries =
        await managers.then((value) => value.docs.map((doc) {
              return Secretary(
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

    for (int i = 0; i < secretaries.length; i++) {
      await FirebaseFirestore.instance
          .collection("users/" + secretaries[i].uid + "/notifications")
          .doc()
          .set({
        'startTime': startTime,
        'endTime': startTime.add(Duration(minutes: 30)),
        'clientID': clientID,
        'doctorID': doctorID,
        'day': DateFormat("yyyy-MM-dd").format(startTime),
        'clientFName': clientFName,
        'clientLName': clientLName,
        'doctorFName': doctorFName,
        'doctorLName': doctorLName,
        'branch': branch,
        'clientPicURL': clientPicURL,
        'status': status,
        'type': type,
      });
    }
  }

  List<MyNotification> _notificationsListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return MyNotification(
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

  Stream<List<MyNotification>> getNotificationsBySearch({int status}) {
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

  Stream<List<Note>> get notes {
    return appointmentsCollection.snapshots().map(_notesListFromSnapshot);
  }

  // get doctors stream
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
      await FirebaseFirestore.instance
          .collection("appointments")
          .doc(appointmentID)
          .update({
        'note': note,
      });
      return 1;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future addNote({
    // DateTime submissionTime,
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

  Future addAppointmentSecretary({
    DateTime startTime,
    String doctorID,
    String clientFName,
    String clientLName,
    String clientPhoneNumber,
    String clientGender,
    String doctorFName,
    String doctorLName,
    String clientID,
  }) async {
    return await appointmentsCollection.doc().set({
      'startTime': startTime,
      'endTime': startTime.add(Duration(minutes: 30)),
      'clientID': clientID,
      'doctorID': doctorID,
      'day': DateFormat("yyyy-MM-dd").format(startTime),
      'clientFName': clientFName,
      'clientLName': clientLName,
      'clientGender': clientGender,
      'clientPhoneNumber': clientPhoneNumber,
      'doctorFName': doctorFName,
      'doctorLName': doctorLName,
      'status': 'pending',
    });
  }

  Future updateDoctorWorkDays() async {
    workDaysList.forEach((element) {
      FirebaseFirestore.instance
          .collection("doctors/" + uid + "/workDays")
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

  Future updateClientData({
    String fName,
    String lName,
    String phoneNumber,
    String gender,
    String email,
    int numAppointments,
    int age,
    int status,
  }) async {
    return await clientsCollection.doc(uid).set({
      'fName': fName,
      'lName': lName,
      'phoneNumber': phoneNumber,
      'gender': gender,
      'numAppointments': numAppointments,
      'age': age,
      'email': email,
      'status': status,
    });
  }

  // clients list from snapshot
  List<Client> _clientListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Client(
        fName: doc.data()['fName'] ?? '',
        lName: doc.data()['lName'] ?? '',
        phoneNumber: doc.data()['phoneNumber'] ?? '',
        numAppointments: doc.data()['numAppointments'] ?? 0,
        gender: doc.data()['gender'] ?? '',
        age: doc.data()['age'] ?? '',
        uid: doc.id,
        picURL: doc.data()['picURL'] ?? '',
        email: doc.data()['email'] ?? '',
        status: doc.data()['status'] ?? 1,
      );
    }).toList();
  }

  // get clients stream
  Stream<List<Client>> get clients {
    return clientsCollection.snapshots().map(_clientListFromSnapshot);
  }

  // Secretaries list from snapshot
  List<Secretary> _secretariesListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Secretary(
        fName: doc.data()['fName'] ?? '',
        lName: doc.data()['lName'] ?? '',
        phoneNumber: doc.data()['phoneNumber'] ?? '',
        gender: doc.data()['gender'] ?? '',
        branch: doc.data()['branch'] ?? '',
        uid: doc.id,
        picURL: doc.data()['picURL'] ?? '',
        status: doc.data()['status'] ?? 1,
      );
    }).toList();
  }

  // get secretaries stream
  Stream<List<Secretary>> get secretaries {
    return secretariesCollection.snapshots().map(_secretariesListFromSnapshot);
  }

  Stream<List<Secretary>> getManagersBySearch(
      String managerName, String managerNumber) {
    Query query = FirebaseFirestore.instance.collection('secretaries');
    if (managerName != '') {
      query = query.where(
        'fName',
        isEqualTo: managerName,
      );
    }
    if (managerNumber != '') {
      query = query.where('phoneNumber', isEqualTo: managerNumber);
    }
    return query.snapshots().map(_secretariesListFromSnapshot);
  }

  // doctors list from snapshot
  List<Doctor> _doctorsListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Doctor(
        uid: doc.id,
        fName: doc.data()['fName'] ?? '',
        lName: doc.data()['lName'] ?? '',
        phoneNumber: doc.data()['phoneNumber'] ?? '',
        about: doc.data()['about'] ?? '',
        proffesion: doc.data()['profession'] ?? '',
        level: doc.data()['about'] ?? 'level',
        branch: doc.data()['branch'] ?? '',
        gender: doc.data()['gender'] ?? '',
        token: doc.data()['token'] ?? '',
        status: doc.data()['status'] ?? 1,
        picURL: doc.data()['picURL'] ?? '',
      );
    }).toList();
  }

  // get doctors stream
  Stream<List<Doctor>> get doctors {
    return doctorsCollection.snapshots().map(_doctorsListFromSnapshot);
  }

  // get doctors stream
  Stream<List<Doctor>> getDoctorsBybranch(String branch) {
    return doctorsCollection
        .where('branch', isEqualTo: branch)
        .snapshots()
        .map(_doctorsListFromSnapshot);
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
        .collection("doctors/" + doctorID + "/workDays")
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
          .collection("doctors/" + doctorID + "/workDays")
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
          .collection("doctors/" + doctorID + "/workDays")
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

  Future updateDoctorStatus({
    int working,
    String doctorID,
  }) async {
    try {
      await doctorsCollection.doc(doctorID).update({
        'status': working,
      });
      return 1;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future updateClientRemainingSessions({
    int numAppointments,
    String documentID,
  }) async {
    try {
      await clientsCollection.doc(documentID).update({
        'numAppointments': numAppointments,
      });
      return 1;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  static Future updateNumAppointments({
    int numAppointments,
    String documentID,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection("clients")
          .doc(documentID)
          .update({
        'numAppointments': numAppointments,
      });
      return 1;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // get user role
  Future setToken(String role) async {
    FirebaseMessaging _messaging = FirebaseMessaging.instance;
    String deviceToken = await _messaging.getToken();
    await usersCollection.doc(uid).update({
      'token': deviceToken,
    });
    if (role == 'doctor') {
      await doctorsCollection.doc(uid).update({
        'token': deviceToken,
      });
    } else if (role == 'client') {
      await clientsCollection.doc(uid).update({
        'token': deviceToken,
      });
    } else if (role == 'secretary') {
      await secretariesCollection.doc(uid).update({
        'token': deviceToken,
      });
    }
  }

  // get user role
  Future<int> getSpecificClientRemainingSessions(String id) async {
    DocumentSnapshot s = await clientsCollection.doc(id).get();
    return s.data()['numAppointments'];
  }

  // get user role
  Future<int> getClientRemainingSessions() async {
    DocumentSnapshot s = await clientsCollection.doc(uid).get();
    return s.data()['numAppointments'];
  }

  Future<String> getSecretaryBranch() async {
    DocumentSnapshot s = await secretariesCollection.doc(uid).get();
    return s.data()['branch'];
  }

  // get user role
  Future<int> getClientEmail() async {
    DocumentSnapshot s = await usersCollection.doc(uid).get();
    return s.data()['email'];
  }

  Future<Client> getClient() async {
    DocumentSnapshot s = await clientsCollection.doc(uid).get();
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

  Future cancelAppointment(String id) async {
    try {
      await appointmentsCollection.doc(id).update({
        'status': 'canceled',
      });
      return 1;
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

  Future updateUserStatus(String role, int status) async {
    try {
      await usersCollection.doc(uid).update({
        'status': status,
      });
      if (role == 'client') {
        await clientsCollection.doc(uid).update({
          'status': status,
          //ADD FUCNTION THAT CANCELS ALL CLIENT APPOINTMENTS IN ADMIN SDK
        });
      } else if (role == 'secretary') {
        await secretariesCollection.doc(uid).update({
          'status': status,
        });
      } else {
        await doctorsCollection.doc(uid).update({
          'status': status,
        });
        //ADD FUCNTION THAT CANCELS ALL DOCTOR APPOINTMENTS IN ADMIN SDK

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

  // Future getImage() async {
  //   var tempImage = await ImagePicker().getImage(source: ImageSource.gallery);
  //   setState(() {
  //     newProfilePic = File(tempImage.path);
  //   });
  // }

  // uploadImage(String uid) async {
  //   final Reference firebaseStorageRef =
  //       FirebaseStorage.instance.ref().child('profilePics/$uid.jpg');
  //   UploadTask task = firebaseStorageRef.putFile(newProfilePic);
  //   TaskSnapshot taskSnapshot = await task;
  //   taskSnapshot.ref.getDownloadURL().then(
  //         (value) => DatabaseService(uid: uid)
  //             .updateUserProfilePicture(value.toString(), 'secretary'),
  //       );
  // }
}
