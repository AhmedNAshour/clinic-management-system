class AuthUser {
  final String uid;
  final String email;
  final String role;
  final String picURL;
  AuthUser({this.uid, this.email, this.role, this.picURL});
}

class UserModel {
  final String uid;
  final String fName;
  final String lName;
  final String countryCode;
  final String countryDialCode;
  final String phoneNumber;
  final String gender;
  final int age;
  final String role;
  final String password;
  final String email;
  final String picURL;
  final String language;
  final String token;
  final bool cancellingNotifs;
  final bool bookingNotifs;
  final int status;

  UserModel({
    this.countryDialCode,
    this.age,
    this.countryCode,
    this.cancellingNotifs,
    this.bookingNotifs,
    this.token,
    this.language,
    this.status,
    this.email,
    this.password,
    this.uid,
    this.fName,
    this.lName,
    this.phoneNumber,
    this.role,
    this.gender,
    this.picURL,
  });
}
