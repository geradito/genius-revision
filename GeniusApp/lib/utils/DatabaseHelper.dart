import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:dnlbook/models/UserModel.dart';


class DatabaseHelper{

  static DatabaseHelper _databaseHelper;
  static Database _database;

  String userTable = "user_table";
  String colId = "id";
  String colName = "name";
  String colLevel = "level";
  String colPoints = "points";

  DatabaseHelper._createInstance();

  factory DatabaseHelper(){
    if(_databaseHelper ==null){
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async{
    if(_database ==null){
      _database = await initializeDatabase();
    }
    return _database;
  }
  Future<Database> initializeDatabase()async{
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'genius.db';

    var geniusDatabase = openDatabase(path, version: 1, onCreate: _createDb);
    return geniusDatabase;
  }

  void _createDb(Database db, int version) async{
    await db.execute('CREATE TABLE $userTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colName TEXT, '
        '$colLevel INTEGER, $colPoints TEXT)');
  }

  Future<List<Map<String, dynamic>>> getUserMapList()async{
      Database db = await this.database;

      // var result = await db.rawQuery('SELECT * FROM $userTable');
      var result = await db.query(userTable);
      return result;
   }

  Future<int> insertUser(User user) async{
    Database db =  await this.database;
    var result = db.insert(userTable, user.toMap());
    return result;
  }

// Get the 'Map List' [ List<Map> ] and convert it to 'Note List' [ List<Note> ]
  Future<List<User>> getUserList() async {

    var userMapList = await getUserMapList(); // Get 'Map List' from database
    int count = userMapList.length;         // Count the number of map entries in db table

    List<User> userList = List<User>();
    // For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      userList.add(User.fromMapObject(userMapList[i]));
    }

    return userList;
  }
}