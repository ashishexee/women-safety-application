import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:woman_safety_app/models/contacts.dart';

class DbHelper {
  DbHelper._privateConstructor();
  static final DbHelper _instance = DbHelper._privateConstructor();

  factory DbHelper() {
    return _instance;
  }

  static DbHelper get instance => _instance;

  Database? _db;

  Future<Database> getdb() async {
    if (_db != null) {
      return _db!;
    } else {
      return opendb();
    }
  }

  String tablename = "contacts_table";
  String columnname_id = 'id';
  String columnname_name = 'name';
  String columnname_number = 'number';

  Future<Database> opendb() async {
    Directory appdir = await getApplicationDocumentsDirectory();
    String dbdir = join(appdir.path, 'contacts.db');
    return await openDatabase(
      dbdir,
      version: 1,
      onCreate: (db, version) {
        db.execute(
          "CREATE TABLE $tablename ($columnname_id INTEGER PRIMARY KEY AUTOINCREMENT, $columnname_name TEXT, $columnname_number TEXT)",
        );
      },
    );
  }

  Future<List<Map<String, dynamic>>> getallcontacts() async {
    Database db = await getdb();
    return await db.query(tablename, orderBy: '$columnname_id ASC');
  }

  Future<int> insertcontacts(TContact contact) async {
    Database db = await getdb();
    try {
      var results = await db.insert(tablename, contact.toMap());
      return results;
    } catch (e) {
      print('Error inserting contact: $e');
      return -1; // Or throw the exception
    }
  }

  Future<int> updatecontacts(TContact contact) async {
    Database db = await getdb();
    var results = db.update(
      tablename,
      contact.toMap(),
      where: '$columnname_id = ?',
      whereArgs: [contact.id],
    );
    return results;
  }

  Future<int> deletecontacts(int id) async {
    Database db = await getdb();
    int results = await db.delete(
      tablename,
      where: '$columnname_id = ?',
      whereArgs: [id],
    );
    return results;
  }

  Future<int> getcount() async {
    Database db = await getdb();
    List<Map<String, dynamic>> x = await db.rawQuery(
      'select count(*) from $tablename',
    );
    int results = Sqflite.firstIntValue(x)!;
    return results;
  }

  Future<List<TContact>> getContactList() async {
    var contactMapList =
        await getContactMapList(); // Get 'Map List' from database
    int count =
        contactMapList.length; // Count the number of map entries in db table
    List<TContact> contactList = <TContact>[];
    // For loop to create a 'Contact List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      contactList.add(TContact.fromMapObject(contactMapList[i]));
    }
    return contactList;
  }

  Future<List<Map<String, dynamic>>> getContactMapList() async {
    Database db = await getdb();
    List<Map<String, dynamic>> result = await db.rawQuery(
      'SELECT * FROM $tablename order by $columnname_id ASC',
    );

    // or
    // var result = await db.query(contactTable, orderBy: '$colId ASC');
    return result;
  }
}
// the data recieved from the database is in form of 
// List<Map<String,dynamic>>