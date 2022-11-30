import 'package:firebase_database/firebase_database.dart';

class MessageModel {
  final int messageId;
  final int timestamp;
  final int type;
  final String from;
  final String message;

  MessageModel(this.messageId, this.timestamp, this.type, this.from, this.message);

  factory MessageModel.fromSnapshot(DataSnapshot snapshot) {
    final arr = snapshot.value.toString().split("_-_");
    return MessageModel(
      int.parse(arr[0]),
      int.parse(snapshot.key!),
      int.parse(arr[1]),
      arr[2],
      arr[3],
    );
  }
}
