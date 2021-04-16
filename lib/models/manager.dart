import 'package:clinic/models/user.dart';

class Manager extends UserModel {
  final String branch;
  final bool isBoss;

  Manager({
    this.branch,
    this.isBoss,
    String uid,
    String fName,
    String lName,
    String countryDialCode,
    String countryCode,
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
