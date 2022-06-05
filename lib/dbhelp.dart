import 'dart:io';

import 'package:dbtutorial/grocery.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'groceries.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE groceries(
        id INTEGER PRIMARY KEY,
        name TEXT
      )
      '''); 
  }

  Future<List<Grocery>> getGroceries() async{
   Database db = await instance.database;
   var groceries = await db.query('groceries',orderBy:'name');
   List<Grocery> grocerylist = groceries.isNotEmpty? groceries.map((c)=> Grocery.fromMap(c)).toList():[];
   return grocerylist;
  }

  Future<int> add(Grocery grocery) async{
    Database db = await instance.database;
    return await db.insert('groceries', grocery.toMap());
  }

  Future<int> remove(int id) async{
    Database db = await instance.database;
    return await db.delete('groceries',where: 'id = ?',whereArgs: [id]);
    // return await db.delete('groceries',where: 'id = $id',whereArgs: []); // yo duita vannu eutai ho
  }

  Future<int> update(Grocery grocery) async{
    Database db = await instance.database;
   var aa =await db.update('groceries',grocery.toMap(), where: 'id=?',whereArgs: [grocery.id]);
    print(aa);
    return aa;
  }
}