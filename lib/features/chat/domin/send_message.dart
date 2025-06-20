import 'package:cloud_firestore/cloud_firestore.dart';

void sendMessage(String messageText) {
  FirebaseFirestore.instance.collection('chats')
      .doc('OhQx8Cj386Gl8CAJSLM5')
      .collection('messages')
      .add({
    'senderId': 'ghyk2SQeK72S3qo0xoQb',
    'receiverId': 'rGJvoy4bHjAf7f2oSotE',
    'message': messageText,
    'timestamp': FieldValue.serverTimestamp(),
  });
}
