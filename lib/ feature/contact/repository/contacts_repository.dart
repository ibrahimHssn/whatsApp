import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsappchat/common/models/user_model.dart';

final contactsRepositoryProvider = Provider((ref) {
  return ContactsRepository(firestore: FirebaseFirestore.instance);
});

class ContactsRepository {
  final FirebaseFirestore firestore;

  ContactsRepository({required this.firestore});

  Future<List<List<UserModel>>> getAllContacts() async {
    List<UserModel> firebaseContacts = [];
    List<UserModel> phoneContacts = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        final userCollection = await firestore.collection('users').get();
        final allContactsInThePhone =
        await FlutterContacts.getContacts(withProperties: true);

        for (var contact in allContactsInThePhone) {
          bool isContactFound = false;
          for (var firebaseContactData in userCollection.docs) {
            var firebaseContact =
            UserModel.fromMap(firebaseContactData.data());
            if (contact.phones.isNotEmpty &&
                contact.phones[0].number.replaceAll('', '') ==
                    firebaseContact.phoneNumber) {
              firebaseContacts.add(firebaseContact);
              isContactFound = true;
              break;
            }
          }
          if (!isContactFound) {
            phoneContacts.add(UserModel(
                userName: contact.displayName,
                uid: '',
                profileImageUrl: '',
                active: false,
                lastSeen: 0,
                phoneNumber: contact.phones.isNotEmpty
                    ? contact.phones[0].number.replaceAll('', '')
                    : '',
                groupId: []));
          }
        }
      }
    } catch (e) {
      log(e.toString());
    }
    return [firebaseContacts, phoneContacts];
  }
}
