import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class DatabaseHelper{
  static final _databaseName = "dietapp.db";
  static final _databaseVersion=1;
  static final foodTable="food";
  static final workoutTable="workout";
  static final bodyTable="body";
  static var weightTable="weight";

  DatabaseHelper._privateConstructor();

  static final instance=DatabaseHelper._privateConstructor();

  static Database _database;

  Future<Database> get database async{
    if(_database != null) return _database;
    _database=await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    var databasePath=await getDatabasesPath();
    String path=join(databasePath,_databaseName);
    return openDatabase(path,version:_databaseVersion,onCreate:_create,onUpgrade:_upgrade);
  }

  Future<void> _create(Database db,int version) async{
    await db.execute("""
      create table if not exists $foodTable(
        id integer primary key autoincrement,
        date integer default 0,
        type integer default 0,
        kcal integer default 0,
        time integer default 0,
        
        memo String,
        image String
      )
    """);
    await db.execute("""
      create table if not exists $workoutTable(
        id integer primary key autoincrement,
        date integer default 0,
        time integer default 0,
        kcal integer default 0,
        intense integer default 0,
        part integer default 0,
        
        name String,
        memo String
      )
    """);

    await db.execute("""
      create table if not exists $bodyTable(
        id integer primary key autoincrement,
        date integer default 0,
        image String,
        meme String
      )
    """);

    await db.execute("""
      create table if not exists $weightTable(
        data integer default 0,
        weight integer default 0,
        fat integer default 0,
        muscle integer default 0
      )
    """);
  }
  Future<void> _upgrade(Database db,int oldVersion,int newVersion) async {}
}