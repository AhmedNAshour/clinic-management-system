class WorkDay {
  String startHour;
  String endHour;
  String startMin;
  String endMin;
  String docID;
  bool enabled;
  int dayID;

  WorkDay({
    this.docID,
    this.startHour,
    this.endHour,
    this.startMin,
    this.endMin,
    this.enabled,
    this.dayID,
  });
}
