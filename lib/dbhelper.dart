import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class Databasehelper {
  static final _databasename = "appdb.db";
  static final _databaseversion = 1;
  static final table = "usertable";

  static final columnId = 'id';
  static final columnEmail = "email";
  static final columnpassword = "password";

  static Database? _database;

  Databasehelper._privateConstructor();

  static final Databasehelper instance = Databasehelper._privateConstructor();


  Future<Database?> get database async {
    if (_database == null) {
      _database = await _initiateDatabase();
    }
    else {
      return _database;
    }
  }

  _initiateDatabase() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, _databasename);
    return await openDatabase(
        path, version: _databaseversion, onCreate: _oncreate);
  }

  Future _oncreate(Database db, int version) async {
    await db.execute(
        '''
      CREATE TABLE $table(
      $columnId INTEGER PRIMARY KEY,
      $columnEmail TEXT NOT NULL,
      $columnpassword INTEGER NOT NULL
      )
      
      '''
    );
  }

  Future<int> insert(Map<String, dynamic> row) async{
    Database? db = await instance.database;
    return await db!.insert(table, row);
  }

  Future<List<Map<String,dynamic>>> queryall() async {
    Database? db = await instance.database;
    return await db!.query(table);
  }

  Future<List<Map<String,dynamic>>> queryspecific(email,password) async {
    Database? db = await instance.database;
    var res =  await db!.query(table, where: "email = ? and password = ?", whereArgs: [email,password]);
    return res;
  }

}