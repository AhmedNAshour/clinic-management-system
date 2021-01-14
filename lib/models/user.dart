class MyUser {
  final String uid;
  final String email;
  final String role;
  MyUser({this.uid, this.email, this.role});
}

class UserData {
  final String uid;
  final String fName;
  final String lName;
  final String phoneNumber;
  final String gender;
  final String role;
  final String password;
  final String email;

  UserData({
    this.email,
    this.password,
    this.uid,
    this.fName,
    this.lName,
    this.phoneNumber,
    this.role,
    this.gender,
  });
}
