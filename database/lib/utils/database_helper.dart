
import '../models/user.dart';

import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper{


  final String tabelUser = "UserTbale";
  final String columnId = "id";
  final String userName = "username";
  final String password = "password";

  static final DatabaseHelper _instance = new DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  static Database _db;
  Future<Database> get db async{

    if(_db != null){
      return _db;

    }
_db = await initDb();
  }


  DatabaseHelper.internal();

  initDb() async {

    Directory documentDirectory = await getApplicationDocumentsDirectory();
  String path = join(documentDirectory.path,"maindb.db");
  var ourDb = await openDatabase(path,version: 1,onCreate: _onCreate);
return ourDb;

  }




  void _onCreate(Database db, int version) async{


    await db.execute(
      "CREATE TABLE $tabelUser($columnId INTEGER PRIMARY KEY, $userName TEXT, $password TEXT"

    );
  }

  //CRUD - CREATE, READ, UPDATE, DELETE

//Insertion

Future<int> saveUser(User user) async{
    var dbClient = await _db;
    int res = await dbClient.insert("$tabelUser", user.toMap());
    return res;

}

Future<List> getAllUsers() async{
    var dbClient = await db;
    var result = await dbClient.rawQuery(

      "SELECT * FROM $tabelUser"
    );
    return result.toList();
}

Future<int> getCount() async{
    var dbClient = await db;
    return Sqflite.firstIntValue(
      await dbClient.rawQuery(
        "SELECT COUNT(*) FROM $tabelUser"
      )
    );
}


Future<User> getUser(int id)async{
    var dbClient = await db;
    var result = await dbClient.rawQuery(

      "SELECT * FROM $tabelUser WHERE $columnId = $id"

    );
    if(result.length ==0) return null;
   return new User.fromMap(result.first);
}


Future<int> deleteUser(int id) async{
    var dbClient = await db;
    return await dbClient.delete(tabelUser,where: "$columnId = ?",whereArgs: [id]);
}



Future<int> updateUser(User user)async{
    var dbClient = await db;
    return await dbClient.update(tabelUser,
    user.toMap(),where: "$columnId =?",whereArgs: [user.id]
    );

}


Future close() async{
    var dbClient = await db;
    return dbClient.close();

}

}


