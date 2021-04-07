class Note {
  final String submissionTime;
  final String doctorID;
  final String clientID;
  final String clientFName;
  final String clientLName;
  final String doctorFName;
  final String doctorLName;
  final String doctorPicUrl;
  final String body;
  final String doctorProfession;
  Note({
    this.doctorProfession,
    this.body,
    this.doctorPicUrl,
    this.submissionTime,
    this.doctorID,
    this.clientID,
    this.clientFName,
    this.clientLName,
    this.doctorFName,
    this.doctorLName,
  });
}
