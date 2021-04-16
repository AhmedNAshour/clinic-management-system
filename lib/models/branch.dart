class Branch {
  final String docID;
  final String name;
  final String address;
  final String countryDialCode;

  final String countryCode;
  final String phoneNumber;
  final String managerID;
  final double longitude;
  final double latitude;
  final int status;
  Branch({
    this.managerID,
    this.status,
    this.docID,
    this.name,
    this.address,
    this.countryDialCode,
    this.countryCode,
    this.phoneNumber,
    this.longitude,
    this.latitude,
  });
}
