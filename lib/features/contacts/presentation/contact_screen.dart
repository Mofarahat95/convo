import 'package:convo/config/routes_manager/routes.dart';
import 'package:convo/features/auth/signup/user_model.dart';
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

  String normalizePhoneNumber(String phoneNumber) {
    String normalized = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
    if (normalized.startsWith('+20')) {
      normalized = normalized.substring(3);
    } else if (normalized.startsWith('0020')) {
      normalized = normalized.substring(4);
    } else if (normalized.startsWith('20')) {
      normalized = normalized.substring(2);
    }
    if (!normalized.startsWith('0')) {
      normalized = '0$normalized';
    }
    return normalized;
  }

  Future<void> fetchAndCompareContacts() async {
    bool granted = await FlutterContacts.requestPermission();
    if (!granted) {
      _showPermissionDeniedDialog();
      return;
    }

    final deviceContacts =
        await FlutterContacts.getContacts(withProperties: true);

    try {
      final usersSnapshot = await _firestore.collection('Users').get();
      final List<Map<String, dynamic>> firebaseUsers = usersSnapshot.docs
          .map((doc) => {
                'id': doc.id,
                'phoneNumber': doc.data()['phonenumber'] ?? '', // ← هنا التعديل
                'name': doc.data()['name'] ?? '',
                'profilePic': doc.data()['profilePic'] ?? '',
                'email': doc.data()['email'] ?? '',
              })
          .toList();

      final List<Map<String, dynamic>> matchedUsers = [];

      for (final contact in deviceContacts) {
        for (final phone in contact.phones) {
          String normalizedPhoneNumber = normalizePhoneNumber(phone.number);

          if (normalizedPhoneNumber ==
              normalizePhoneNumber(_auth.currentUser?.phoneNumber ?? '')) {
            print("🚫 Skipped own number: $normalizedPhoneNumber");
            continue;
          }

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

            print(
                '✅ Matched: ${matchingUser['name']} ↔ $normalizedPhoneNumber');
            break;
          } else {
            print('❌ No Match: $normalizedPhoneNumber with any Firebase user');
          }
        }
      }

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

  void _navigateToChatScreen(String userId, String name) {
    GoRouter.of(context).push(AppRoutes.chatRoute, extra: name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
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

  Widget _buildContactsTitle() {
    return const Padding(
      padding: EdgeInsets.only(top: 25, left: 25, bottom: 15),
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
            // Take one from the matched users as map
            final result = _matchedUsers[index];

            // Extract only user-related fields to avoid passing unnecessary keys
            Map<String, dynamic> userJson = {
              'id': result['userId'],
              'name': result['name'],
              'profilePic': result['profilePic'],
              'phonenumber': result['phone'],
              'email': result['email'],
            };

            // Convert the map to user model object
            UserModel user = UserModel.fromJson(userJson);

            return ListTile(
              leading: user.profilePic.isNotEmpty
                  ? CircleAvatar(
                backgroundImage: NetworkImage(user.profilePic),
              )
                  : CircleAvatar(
                child: Text(user.name[0].toUpperCase()),
                backgroundColor: Colors.grey[300],
              ),
              title: Text(user.name),
              subtitle: Text('${user.phone}'),
              onTap: () {
                GoRouter.of(context)
                    .push(AppRoutes.chatRoute, extra: user);
                print("${user.phone}");
              },
            );
          },
        ),
      ),
    );
  }

}
