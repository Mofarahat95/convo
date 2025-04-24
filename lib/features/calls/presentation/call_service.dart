import 'package:cloud_firestore/cloud_firestore.dart';
import 'call_model.dart';

class CallService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<Call?> getCallStream(String userId) {
    return _firestore.collection("calls").doc(userId).snapshots().map((doc) {
      if (doc.data() == null) return null;
      return Call.fromMap(doc.data()!);
    });
  }

  Future<void> makeCall(Call call) async {
    await _firestore.collection("calls").doc(call.callerId).set(call.toMap());
    await _firestore.collection("calls").doc(call.receiverId).set(call.toMap());
  }

  Future<void> endCall(String callerId, String receiverId) async {
    await _firestore.collection("calls").doc(callerId).delete();
    await _firestore.collection("calls").doc(receiverId).delete();
  }

}
