import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:woman_safety_app/child/bottom_pages.dart/contact_pages.dart';
import 'package:woman_safety_app/components/primary_button.dart';
import 'package:woman_safety_app/constants/constants.dart';
import 'package:woman_safety_app/db/db_helper.dart';
import 'package:woman_safety_app/models/contacts.dart';

class AddContacts extends StatefulWidget {
  const AddContacts({super.key});

  @override
  State<AddContacts> createState() => _AddContactsState();
}

class _AddContactsState extends State<AddContacts> {
  final DbHelper _databasehelper = DbHelper();
  int count = 0;
  List<TContact> contactsList = [];

  Future<void> showList() async {
    try {
    await _databasehelper.getdb();
      List<TContact> contacts = await _databasehelper.getContactList();

      if (mounted) {
        setState(() {
          contactsList = contacts;
          count = contacts.length;
        });
      }
    } catch (e) {
      print("Error loading contacts: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    showList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: themecolor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ENTER YOUR TRUSTED CONTACTS',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: themecolor,
                      ),
                    ),
                    Icon(Icons.person_add, color: themecolor, size: 28),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: PrimaryButton(
                      title: 'Add Contact',
                      onPressed: () async {
                        final result = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ContactPages(),
                          ),
                        );
                        if (result == true) {
                          // Ensure database is updated and UI refreshes
                          await showList();
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: themecolor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: themecolor.withOpacity(0.4),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.add, color: Colors.white),
                      onPressed: () async {
                        final result = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ContactPages(),
                          ),
                        );
                        if (result == true) {
                          // Ensure database is updated and UI refreshes
                          await showList();
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child:
                    count == 0
                        ? Center(
                          child: Text(
                            'No contacts added yet.',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        )
                        : ListView.builder(
                          itemCount: count,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              elevation: 4,
                              margin: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 4,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: themecolor,
                                  child: Text(
                                    contactsList[index].name[0].toUpperCase(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                title: Text(
                                  contactsList[index].name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  contactsList[index].number,
                                  style: TextStyle(color: Colors.grey[700]),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.call,
                                        color: themecolor,
                                      ),
                                      onPressed: () {
                                        // Add call functionality here
                                        final phoneNumber =
                                            contactsList[index].number;
                                        // Use a package like url_launcher to make the call
                                        launchUrl(
                                          Uri.parse('tel:$phoneNumber'),
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: themecolor,
                                      ),
                                      onPressed: () {
                                        // Add delete functionality here
                                        deletecontacts(contactsList, index);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void deletecontacts(List<TContact> contactList, int index) async {
    int id = contactList[index].id;
    await _databasehelper.deletecontacts(id);
    // Remove the contact with a fade-out animation
    setState(() {
      contactsList.removeAt(index);
      count = contactsList.length;
    });

    Fluttertoast.showToast(
      msg: 'Contact deleted successfully',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: themecolor,
      textColor: Colors.white,
      fontSize: 16.0,
    );

    // Delay to allow the animation to complete before refreshing the list
    await Future.delayed(const Duration(milliseconds: 300));

    List<TContact> newcontactsList = await _databasehelper.getContactList();
    setState(() {
      contactsList = newcontactsList;
      count = newcontactsList.length;
    });
  }
}
