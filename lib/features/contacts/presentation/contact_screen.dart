import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final List<Contact> _contacts = [];
  final List<Map<String, dynamic>> _appContacts = [];
  bool _isLoading = true;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    fetchAndSetContacts();
  }

  // تطبيع رقم الهاتف لإزالة المسافات والفواصل وكود الدولة
  String normalizePhoneNumber(String phoneNumber) {
    String normalized = phoneNumber.replaceAll(RegExp(r'[^\d+]'), ''); // إزالة أي رموز غير رقمية
    if (normalized.startsWith('20')) {
      normalized = normalized.substring(2); // إزالة كود الدولة المصري
    }
    return normalized;
  }

  Future<void> fetchAndSetContacts() async {
    bool granted = await FlutterContacts.requestPermission();
    if (!granted) {
      _showPermissionDeniedDialog();
      return;
    }

    // Get all device contacts
    final deviceContacts = await FlutterContacts.getContacts(withProperties: true);

    // Get all registered users from Firebase
    try {
      final usersSnapshot = await _firestore.collection('Users').get();
      final List<Map<String, dynamic>> firebaseUsers = usersSnapshot.docs
          .map((doc) => {
        'id': doc.id,
        'phoneNumber': doc.data()['phoneNumber'] ?? '',
        'name': doc.data()['name'] ?? '',
        'profilePic': doc.data()['profilePic'] ?? '',
      })
          .toList();

      // Filter contacts that are also app users
      final List<Map<String, dynamic>> appContacts = [];

      for (final contact in deviceContacts) {
        for (final phone in contact.phones) {
          // تطبيع رقم الهاتف من جهة الاتصال
          String normalizedPhoneNumber = normalizePhoneNumber(phone.number);

          // التحقق مما إذا كانت هذه الجهة موجودة في Firebase
          final matchingUser = firebaseUsers.firstWhere(
                (user) => normalizePhoneNumber(user['phoneNumber']) == normalizedPhoneNumber,
            orElse: () => {},
          );

          if (matchingUser.isNotEmpty && matchingUser['id'] != _auth.currentUser?.uid) {
            appContacts.add({
              'contact': contact,
              'userId': matchingUser['id'],
              'name': matchingUser['name'],
              'profilePic': matchingUser['profilePic'],
            });
            break; // Found a match for this contact, no need to check other phone numbers
          }
        }
      }

      setState(() {
        _contacts.clear();
        _contacts.addAll(deviceContacts);
        _appContacts.clear();
        _appContacts.addAll(appContacts);
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
    // Navigate to chat screen with the selected user
    // Implement this based on your app's chat screen navigation
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
              _buildContactsList(),
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
        style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
      ),
      toolbarHeight: 100,
    );
  }

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

  Widget _buildContactsList() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.black))
            : _appContacts.isEmpty
            ? const Center(child: Text('No contacts using this app'))
            : ListView.builder(
          itemCount: _appContacts.length,
          itemBuilder: (context, index) {
            final contactData = _appContacts[index];
            final contact = contactData['contact'] as Contact;
            final userId = contactData['userId'] as String;
            final displayName = contact.displayName;
            final firstLetter = displayName[0].toUpperCase();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (index == 0 ||
                    _appContacts[index - 1]['contact'].displayName[0].toUpperCase() != firstLetter)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      firstLetter,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                ListTile(
                  leading: contactData['profilePic'] != null && contactData['profilePic'].isNotEmpty
                      ? CircleAvatar(
                    backgroundImage: NetworkImage(contactData['profilePic']),
                  )
                      : CircleAvatar(
                    child: Text(displayName[0].toUpperCase()),
                    backgroundColor: Colors.grey[300],
                  ),
                  title: Text(displayName),
                  subtitle: Text(
                    contact.phones.isEmpty ? "No phone number" : '${contact.phones[0].number}',
                  ),
                  onTap: () => _navigateToChatScreen(userId, displayName),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
