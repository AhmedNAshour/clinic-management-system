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
  final String branch;
  final String status;
  final String doctorPicURL;
  final String clientPicURL;

  Appointment({
    this.clientPicURL,
    this.doctorPicURL,
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
    this.branch,
    this.status,
  });
}
