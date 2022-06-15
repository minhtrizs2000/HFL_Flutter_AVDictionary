import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final _databaseName = "dict_hh.db";
  static Future<dynamic> _database = DatabaseHelper.init();
  // make this a singleton class
  DatabaseHelper._initDatabase();
  static final DatabaseHelper instance = DatabaseHelper._initDatabase();

  // only have a single app-wide reference to the database

  get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

 _initDatabase() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "dict_hh.db");

    // Check if the database exists
    var exists = await databaseExists(path);

    if (!exists) {
      print("Creating new copy from asset");

      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      // Copy from asset
      ByteData data =
          await rootBundle.load(join("assets/database", _databaseName));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      print("Opening existing database");
    }
    // open the database
    _database = (await openDatabase(path, readOnly: false)) as Future;
    return _database;
  }

//another helper method to get the database.
//example of how to use this method:
  static init() async {
    Directory applicationDirectory = await getApplicationDocumentsDirectory();

    String dbPathEnglish = path.join(applicationDirectory.path, "dict_hh.db");

    bool dbExistsEnglish = await File(dbPathEnglish).exists();

    if (!dbExistsEnglish) {
      // Copy from asset
      ByteData data = await rootBundle.load(path.join("assets", "dict_hh.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(dbPathEnglish).writeAsBytes(bytes, flush: true);
    }

    return await openDatabase(dbPathEnglish);
  }

}
