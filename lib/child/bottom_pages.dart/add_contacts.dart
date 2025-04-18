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
        appBar: AppBar(
          elevation: 2,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          title: ShaderMask(
            shaderCallback:
                (bounds) => LinearGradient(
                  colors: [themecolor, Colors.orange],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
            blendMode: BlendMode.srcIn,
            child: const Text(
              'Trusted Contacts',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                letterSpacing: 1.1,
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
                          await showList();
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [themecolor, Colors.orange],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: themecolor.withOpacity(0.25),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
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
                          await showList();
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              Expanded(
                child:
                    count == 0
                        ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.contact_page,
                                size: 80,
                                color: Colors.grey[300],
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'No contacts added yet.',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        )
                        : ListView.builder(
                          itemCount: count,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              elevation: 4,
                              margin: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 2,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: themecolor,
                                  radius: 25,
                                  child: Text(
                                    contactsList[index].name[0].toUpperCase(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  contactsList[index].name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                    color: Colors.black87,
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 2.0),
                                  child: Text(
                                    contactsList[index].number,
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.call,
                                        color: Colors.green[700],
                                      ),
                                      onPressed: () {
                                        final phoneNumber =
                                            contactsList[index].number;
                                        launchUrl(
                                          Uri.parse('tel:$phoneNumber'),
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red[400],
                                      ),
                                      onPressed: () {
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

    await Future.delayed(const Duration(milliseconds: 300));
    List<TContact> newcontactsList = await _databasehelper.getContactList();
    setState(() {
      contactsList = newcontactsList;
      count = newcontactsList.length;
    });
  }
}
