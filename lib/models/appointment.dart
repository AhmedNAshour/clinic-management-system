class Appointment {
  final DateTime startTime;
  final DateTime endTime;
  final String doctorID;
  final String clientID;
  final String day;
  final String clientFName;
  final String clientLName;
  final String clientPhoneNumber;
  final String clientGender;
  final String doctorFName;
  final String doctorLName;
  final String docID;

  Appointment({
    this.docID,
    this.startTime,
    this.endTime,
    this.doctorID,
    this.clientID,
    this.day,
    this.clientFName,
    this.clientLName,
    this.clientPhoneNumber,
    this.clientGender,
    this.doctorFName,
    this.doctorLName,
  });
}
