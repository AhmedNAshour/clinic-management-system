class MessageModel {
  final String docID;
  final String sender;
  final String reciever;
  final String body;
  final DateTime time;
  MessageModel({
    this.docID,
    this.sender,
    this.reciever,
    this.body,
    this.time,
  });
}
