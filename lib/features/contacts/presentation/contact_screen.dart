import 'package:convo/config/routes_manager/routes.dart';
import 'package:convo/features/chat/presentation/screens/chat_screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final List<Contact> _contacts = [];
  final List<Map<String, dynamic>> _matchedUsers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAndCompareContacts();
  }

  // دالة لتطبيع رقم الهاتف (إزالة المسافات والفواصل)
  String normalizePhoneNumber(String phoneNumber) {
    String normalized = phoneNumber.replaceAll(RegExp(r'[^\d+]'), ''); // إزالة أي رموز غير رقمية
    if (normalized.startsWith('20')) {
      normalized = normalized.substring(2); // إزالة كود الدولة المصري
    }
    return normalized;
  }

  // جلب الأرقام من الجهاز
  Future<void> fetchAndCompareContacts() async {
    bool granted = await FlutterContacts.requestPermission();
    if (!granted) {
      _showPermissionDeniedDialog();
      return;
    }

    // جلب الأرقام من جهاز المستخدم
    final deviceContacts =
    await FlutterContacts.getContacts(withProperties: true);

    // جلب الأرقام المسجلة في Firebase
    try {
      final usersSnapshot = await _firestore.collection('Users').get();
      final List<Map<String, dynamic>> firebaseUsers = usersSnapshot.docs
          .map((doc) => {
        'id': doc.id,
        'phoneNumber': doc.data()['phoneNumber'] ?? '',
        'name': doc.data()['name'] ?? '',
        'profilePic': doc.data()['profilePic'] ?? '',
        'email': doc.data()['email'] ?? '',
      })
          .toList();

      // مقارنة الأرقام بين جهات الاتصال في الجهاز و Firebase
      final List<Map<String, dynamic>> matchedUsers = [];

      for (final contact in deviceContacts) {
        for (final phone in contact.phones) {
          String normalizedPhoneNumber = normalizePhoneNumber(phone.number);

          // التحقق من وجود تطابق في Firebase
          final matchingUser = firebaseUsers.firstWhere(
                (user) =>
            normalizePhoneNumber(user['phoneNumber']) ==
                normalizedPhoneNumber,
            orElse: () => {},
          );

          if (matchingUser.isNotEmpty &&
              matchingUser['id'] != _auth.currentUser?.uid) {
            matchedUsers.add({
              'contact': contact,
              'userId': matchingUser['id'],
              'name': matchingUser['name'],
              'profilePic': matchingUser['profilePic'],
              'phone': matchingUser['phoneNumber'],
              'email': matchingUser['email'],
            });
            break; // لا حاجة للاستمرار في التحقق من الأرقام الأخرى لهذا الاتصال
          }
        }
      }

      // تحديث الواجهة بعد المقارنة
      setState(() {
        _contacts.clear();
        _contacts.addAll(deviceContacts);
        _matchedUsers.clear();
        _matchedUsers.addAll(matchedUsers);
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching users: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  // دالة لإظهار رسالة إذا تم رفض الصلاحيات
  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permission Required'),
        content: const Text(
          'Contacts permission is required to fetch contacts. '
              'Please enable it in settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  // التنقل إلى شاشة المحادثة مع المستخدم
  void _navigateToChatScreen(String userId, String name) {
    // تنفيذ التنقل إلى شاشة الدردشة مع المستخدم المحدد
    GoRouter.of(context).push(AppRoutes.chatRoute,extra:name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildContactsTitle(),
              _buildMatchedUsersList(),
            ],
          ),
        ),
      ),
    );
  }

  // بناء الـ AppBar
  AppBar _buildAppBar() {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.black,
      title: const Text(
        'Contacts',
        style: TextStyle(
            color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
      ),
      toolbarHeight: 100,
    );
  }

  // بناء عنوان جهات الاتصال
  Widget _buildContactsTitle() {
    return Padding(
      padding: const EdgeInsets.only(top: 25, left: 25, bottom: 15),
      child: Text(
        'My Contacts',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  // بناء قائمة المستخدمين المتطابقين
  Widget _buildMatchedUsersList() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: _isLoading
            ? const Center(
            child: CircularProgressIndicator(color: Colors.black))
            : _matchedUsers.isEmpty
            ? const Center(child: Text('No matched contacts'))
            : ListView.builder(
          itemCount: _matchedUsers.length,
          itemBuilder: (context, index) {
            final user = _matchedUsers[index];
            final contact = user['contact'] as Contact;
            final userId = user['userId'] as String;
            final displayName = user['name'] as String;
            final profilePic = user['profilePic'] as String;
            final phone = user['phone'] as String;
            final email = user['email'] as String;

            return ListTile(
              leading: profilePic.isNotEmpty
                  ? CircleAvatar(
                backgroundImage: NetworkImage(profilePic),
              )
                  : CircleAvatar(
                child: Text(displayName[0].toUpperCase()),
                backgroundColor: Colors.grey[300],
              ),
              title: Text(displayName),
              subtitle: Text('$phone\n$email'),
              onTap: () => _navigateToChatScreen(userId, displayName),
            );
          },
        ),
      ),
    );
  }
}
