import 'package:firebase_database/firebase_database.dart';
import 'package:service_admin/api/utils.dart';

class ContactModel {
  final int contactId;
  final String name;
  final String number;

  ContactModel(this.contactId, this.name, this.number);

  factory ContactModel.fromSnapshot(DataSnapshot snapshot) {
    final keyData = snapshot.key!.split("_-_");
    return ContactModel(
      int.parse(keyData[1]),
      keyData[0].decode(),
      keyData[2].decode(),
    );
  }
}
