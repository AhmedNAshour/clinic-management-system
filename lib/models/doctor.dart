import 'package:clinic/models/user.dart';

class Doctor extends UserModel {
  final String about;
  final String proffesion;
  final String branch;

  Doctor({
    this.about,
    this.proffesion,
    this.branch,
    String uid,
    String fName,
    String lName,
    String countryCode,
    String countryDialCode,
    String phoneNumber,
    String gender,
    int age,
    String role,
    String password,
    String email,
    String picURL,
    String language,
    String token,
    bool cancellingNotifs,
    bool bookingNotifs,
    int status,
  }) : super(
          uid: uid,
          fName: fName,
          lName: lName,
          countryDialCode: countryDialCode,
          countryCode: countryCode,
          phoneNumber: phoneNumber,
          gender: gender,
          age: age,
          role: role,
          password: password,
          email: email,
          picURL: picURL,
          language: language,
          token: token,
          cancellingNotifs: cancellingNotifs,
          bookingNotifs: bookingNotifs,
          status: status,
        );
}
