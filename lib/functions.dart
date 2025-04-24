import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> syncUserContacts(String currentUserId) async {
  List<String> phoneNumbers = await getContactPhones();
  List<String> matchedUserIds = [];

  final usersSnapshot = await FirebaseFirestore.instance.collection('Users').get();

  for (var doc in usersSnapshot.docs) {
    String dbPhone = doc.data()['phone'].toString().replaceAll(RegExp(r'\s+|\+2|\+'), '');
    if (phoneNumbers.contains(dbPhone)) {
      matchedUserIds.add(doc.id); // ده هو UID في Firebase
    }
  }

  // خزّن الكونتكتس اللي اتطابقوا
  if (matchedUserIds.isNotEmpty) {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUserId)
        .collection('contacts')
        .add({'users': matchedUserIds});
  }
}
import 'package:flutter_contacts/flutter_contacts.dart';

Future<List<String>> getContactPhones() async {
  List<String> numbers = [];

  if (await requestContactPermission()) {
    bool granted = await FlutterContacts.requestPermission();
    if (granted) {
      final contacts = await FlutterContacts.getContacts(withProperties: true);
      for (var contact in contacts) {
        for (var phone in contact.phones) {
          String cleaned = phone.number.replaceAll(RegExp(r'\s+|\+2|\+'), '');
          numbers.add(cleaned);
        }
      }
    }
  }
  return numbers;
}
