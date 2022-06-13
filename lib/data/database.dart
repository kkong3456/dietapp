import 'package:dietapp/data/data.dart';
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
    return openDatabase(path,version:_databaseVersion,onCreate:_onCreate,onUpgrade:_onUpgrade);
  }

  Future<void> _onCreate(Database db,int version) async{
    await db.execute("""
      create table if not exists $foodTable(
        id integer primary key autoincrement,
        date integer default 0,
        type integer default 0,
        meal integer default 0,
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
  Future<void> _onUpgrade(Database db,int oldVersion,int newVersion) async {}

  //데이터 추가,변경,검색,삭제
  Future<int> insertFood(Food food) async {
    Database db=await instance.database;

    if(food.id!=null){  //생성
      final _map=food.toMap();
      return await db.insert(foodTable,_map);
    }else{  //변경
      final _map=food.toMap();
      return await db.update(foodTable, _map,where:"id=?",whereArgs:[food.id]);
    }
  }

  Future<List<Food>> queryFoodByDate(int date) async {
    Database db=await instance.database;
    List<Food> foods=[];
    final query=await db.query(foodTable,where:"date=?",whereArgs:[date]);

    for(final q in query) {
      foods.add(Food.fromDB(q));
    }
    return foods;
  }

  Future<List<Food>> queryAllFood() async{
    Database db=await instance.database;
    List<Food> foods=[];
    final query=await db.query(foodTable);

    for(final q in query){
      foods.add(Food.fromDB(q));
    }
    return foods;
  }

  Future<int> insertWorkout(Workout workout) async {
    Database db=await instance.database;

    if(workout.id!=null){  //생성
      final _map=workout.toMap();
      return await db.insert(workoutTable,_map);
    }else{  //변경
      final _map=workout.toMap();
      return await db.update(workoutTable, _map,where:"id=?",whereArgs:[workout.id]);
    }
  }

  Future<List<Workout>> queryWorkoutByDate(int date) async {
    Database db=await instance.database;
    List<Workout> workouts=[];
    final query=await db.query(workoutTable,where:"date=?",whereArgs:[date]);

    for(final q in query) {
      workouts.add(Workout.fromDB(q));
    }
    return workouts;
  }

  Future<List<Workout>> queryAllWorkout() async{
    Database db=await instance.database;
    List<Workout> workouts=[];
    final query=await db.query(workoutTable);

    for(final q in query){
      workouts.add(Workout.fromDB(q));
    }
    return workouts;
  }

  Future<int> insertEyeBody(EyeBody body) async {
    Database db=await instance.database;

    if(body.id!=null){  //생성
      final _map=body.toMap();
      return await db.insert(bodyTable,_map);
    }else{  //변경
      final _map=body.toMap();
      return await db.update(bodyTable, _map,where:"id=?",whereArgs:[body.id]);
    }
  }

  Future<List<EyeBody>> queryEyeBodyByDate(int date) async {
    Database db=await instance.database;
    List<EyeBody> bodies=[];
    final query=await db.query(bodyTable,where:"date=?",whereArgs:[date]);

    for(final q in query) {
      bodies.add(EyeBody.fromDB(q));
    }
    return bodies;
  }

  Future<List<EyeBody>> queryAllEyeBody() async{
    Database db=await instance.database;
    List<EyeBody> bodies=[];
    final query=await db.query(bodyTable);

    for(final q in query){
      bodies.add(EyeBody.fromDB(q));
    }
    return bodies;
  }


  Future<int> insertWeight(Weight weight) async {
    Database db=await instance.database;

    List<Weight> _d=await queryWeightByDate(weight.date);

    if(_d.isEmpty){  //생성
      final _map=weight.toMap();
      return await db.insert(weightTable,_map);
    }else{  //변경
      final _map=weight.toMap();
      return await db.update(weightTable, _map,where:"date=?",whereArgs:[weight.date]);
    }
  }

  Future<List<Weight>> queryWeightByDate(int date) async {
    Database db=await instance.database;
    List<Weight> weights=[];
    final query=await db.query(weightTable,where:"date=?",whereArgs:[date]);

    for(final q in query) {
      weights.add(Weight.fromDB(q));
    }
    return weights;
  }

  Future<List<Weight>> queryAllWeight() async{
    Database db=await instance.database;
    List<Weight> weights=[];
    final query=await db.query(weightTable);

    for(final q in query){
      weights.add(Weight.fromDB(q));
    }
    return weights;
  }
}