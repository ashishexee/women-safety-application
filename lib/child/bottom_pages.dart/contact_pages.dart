import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:woman_safety_app/constants/constants.dart';
import 'package:woman_safety_app/db/db_helper.dart';
import 'package:woman_safety_app/models/contacts.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.red, // Change this to your desired theme color
        scaffoldBackgroundColor: Colors.teal.shade50,
        appBarTheme: const AppBarTheme(
          backgroundColor: themecolor,
          foregroundColor: Colors.white,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: themecolor,
        ),
      ),
      home: const ContactPages(),
    );
  }
}

class ContactPages extends StatefulWidget {
  const ContactPages({super.key});

  @override
  State<ContactPages> createState() => _ContactPagesState();
}

class _ContactPagesState extends State<ContactPages> {
  List<Contact> _contacts = [];
  List<Contact> _filteredContacts = [];
  bool _isLoading = false;
  final TextEditingController _searchController = TextEditingController();
  final DbHelper _databasehelper = DbHelper();
  @override
  void initState() {
    super.initState();
    _fetchContacts();
    _searchController.addListener(_filterContacts);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Filter contacts based on search query (name or phone)
  void _filterContacts() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredContacts = _contacts;
      } else {
        _filteredContacts =
            _contacts.where((contact) {
              final nameMatch = contact.displayName.toLowerCase().contains(
                query,
              );
              final phoneMatch = contact.phones.any(
                (phone) => phone.number.toLowerCase().contains(query),
              );
              return nameMatch || phoneMatch;
            }).toList();
      }
    });
  }

  Future<void> _fetchContacts() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final status = await Permission.contacts.request();
      if (status == PermissionStatus.granted) {
        final contacts = await FlutterContacts.getContacts(
          withProperties: true,
        );

        // Deduplicate contacts by displayName and merge phone numbers
        Map<String, Contact> contactMap = {};
        for (var contact in contacts) {
          // Use displayName as a key; consider trimming or lowercasing if needed
          final key = contact.displayName;
          if (contactMap.containsKey(key)) {
            // Merge phone numbers without duplicates
            Contact existing = contactMap[key]!;
            for (var phone in contact.phones) {
              if (!existing.phones.any((p) => p.number == phone.number)) {
                existing.phones.add(phone);
              }
            }
          } else {
            contactMap[key] = contact;
          }
        }
        final uniquecontacts = contactMap.values.toList();
        setState(() {
          _contacts = uniquecontacts;
          _filteredContacts = uniquecontacts;
        });
      } else {
        _showPermissionDeniedDialog();
      }
    } catch (e) {
      _showErrorDialog('Error fetching contacts: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Permission Required'),
            content: const Text(
              'Contacts permission is required to fetch contacts.\nPlease enable it in settings.',
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

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Error'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ShaderMask(
          shaderCallback:
              (bounds) => LinearGradient(
                colors: [Colors.blue, Colors.purple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds),
          child: const Text(
            'Contacts',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 24,
              letterSpacing: 1.2,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 2,
        actions: [
          IconButton(
            onPressed: _isLoading ? null : _fetchContacts,
            icon:
                _isLoading
                    ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.blue,
                        strokeWidth: 2,
                      ),
                    )
                    : const Icon(Icons.refresh, color: Colors.blue),
            tooltip: 'Refresh',
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Material(
              elevation: 2,
              borderRadius: BorderRadius.circular(12),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search contacts...',
                  prefixIcon: const Icon(Icons.search, color: Colors.blue),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  suffixIcon:
                      _searchController.text.isNotEmpty
                          ? IconButton(
                            icon: const Icon(Icons.clear, color: Colors.grey),
                            onPressed: () {
                              _searchController.clear();
                              _filterContacts();
                            },
                          )
                          : null,
                ),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child:
            _isLoading
                ? const Center(child: CircularProgressIndicator.adaptive())
                : _filteredContacts.isEmpty
                ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.contact_page, size: 80, color: Colors.grey[300]),
                    const SizedBox(height: 16),
                    const Text(
                      'No contacts found',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                )
                : ListView.builder(
                  itemCount: _filteredContacts.length,
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 8,
                  ),
                  itemBuilder: (context, index) {
                    Contact contact = _filteredContacts[index];
                    final List<Phone> phones = contact.phones;
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 4,
                      ),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 16,
                        ),
                        leading: CircleAvatar(
                          radius: 26,
                          backgroundColor: Colors.blue.shade100,
                          child: Icon(
                            Icons.person,
                            color: Colors.blue.shade700,
                            size: 28,
                          ),
                        ),
                        title: Text(
                          contact.displayName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: Colors.black87,
                            letterSpacing: 0.5,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            phones.isNotEmpty
                                ? phones[0].number
                                : 'No phone number',
                            style: TextStyle(
                              color:
                                  phones.isNotEmpty
                                      ? Colors.grey[700]
                                      : Colors.redAccent,
                              fontWeight:
                                  phones.isNotEmpty
                                      ? FontWeight.w500
                                      : FontWeight.w400,
                            ),
                          ),
                        ),
                        trailing: Icon(
                          Icons.chevron_right,
                          color: Colors.grey[400],
                        ),
                        onTap: () {
                          if (contact.phones.isNotEmpty) {
                            final String phonenumber =
                                contact.phones.elementAt(0).number;
                            final String contactname = contact.displayName;
                            _addcontacts(TContact(phonenumber, contactname));
                          } else {
                            Fluttertoast.showToast(
                              msg:
                                  'Oops! This contact does not have a phone number.',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.redAccent,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          }
                          Navigator.of(context).pop(true);
                        },
                      ),
                    );
                  },
                ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isLoading ? null : _fetchContacts,
        icon: const Icon(Icons.refresh),
        label: const Text('Refresh'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
    );
  }

  void _addcontacts(TContact newContact) async {
    int results = await _databasehelper.insertcontacts(newContact);
    if (results != 0) {
      Fluttertoast.showToast(
        msg: 'Contact successfully added',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: themecolor,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
      Fluttertoast.showToast(
        msg: 'Failed to add contact',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }
}
