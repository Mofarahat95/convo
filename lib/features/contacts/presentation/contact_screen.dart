import 'package:convo/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  @override
  void initState() {
    getContactPhones();
    super.initState();
  }

  final List<Contact> _contacts = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Contacts',
          style: quicksand24(),
        ),
        toolbarHeight: 100,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Expanded(
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 50),
                        _contacts.isEmpty
                            ? const Center(
                                child: Text('No contacts'),
                              )
                            : ListView.builder(
                                itemCount: _contacts.length,
                                itemBuilder: (context, index) {
                                  Contact contact = _contacts[index];
                                  final List<Phone> phones = contact.phones;
                                  return ListTile(
                                    leading: const CircleAvatar(
                                      child: Icon(Icons.person),
                                    ),
                                    title: Text(contact.displayName),
                                    subtitle: Text(
                                      phones.isEmpty
                                          ? "No phone number"
                                          : '${phones[0].label} ${phones[0].number}',
                                    ),
                                  );
                                },
                              ),
                      ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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


  Future<List<String>> getContactPhones() async {
    List<String> numbers = [];

    // طلب صلاحية الوصول
    bool granted = await FlutterContacts.requestPermission();
    if (!granted) return numbers;

    // جلب الكونتكتس
    final contacts = await FlutterContacts.getContacts(withProperties: true);

    for (var contact in contacts) {
      for (var phone in contact.phones) {
        // تنظيف الرقم من المسافات + كود الدولة
        String cleaned = phone.number.replaceAll(RegExp(r'\s+|\+2|\+'), '');
        numbers.add(cleaned);
      }
    }

    return numbers;
  }


/*Future<void> _fetchContacts() async {
    try {
      final PermissionStatus permissionStatus =
          await Permission.contacts.request();

      if (permissionStatus == PermissionStatus.granted) {
        final contacts =
            await FlutterContacts.getContacts(withProperties: true);
        setState(() {
          _contacts.clear();
          _contacts.addAll(contacts);
        });
      } else {
        _showPermissionDeniedDialog();
      }
    } on Exception catch (e) {}
  }
}*/
}
