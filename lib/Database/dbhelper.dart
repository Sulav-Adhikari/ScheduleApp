
import 'dart:async';
import 'package:path/path.dart';
import 'package:scheduleapp/Models/Notes.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io'as io;
class DBHelper{

  static Database? _db;

  static Future<Database?> get db async{
    if(_db != null){
      return _db;
    }
    _db = await initDatabase();

    return _db;
  }

  static initDatabase() async{
    io.Directory documentDirectory=await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path,'notes.db');
    var db = await openDatabase(path,version: 1,onCreate: _onCreate);
    return db;
  }

  static _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE notes(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    note TEXT NOT NULL,
    date STRING,
    time STRING)
    ''');
  }

  Future<int> insert(Notes notes)async {
    var dbClient = await db;
    return await dbClient!.insert('notes', notes.toMap());

  }
}