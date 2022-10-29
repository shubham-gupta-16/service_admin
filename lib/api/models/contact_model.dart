import 'package:firebase_database/firebase_database.dart';
import 'package:service_admin/api/utils.dart';

import 'volume_model.dart';

class ContactModel {
  final int contactId;
  final String name;
  final String number;

  ContactModel(this.contactId, this.name, this.number);

  factory ContactModel.fromSnapshot(DataSnapshot snapshot) {
    final keyData = snapshot.key!.split("_-_");
    return ContactModel(
      int.parse(keyData[0]),
      keyData[1].decode(),
      keyData[2].decode(),
    );
  }
}
