import 'package:flutter_mistake_app/Mistake.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class MistakeDatabase {
  static final MistakeDatabase instance = MistakeDatabase._init();

  static Database? _database;

  MistakeDatabase._init();

  //upon calling database of the class MistakeDatabase, check whether there is an existing database, if not then create a new one
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('mistakes.db');
    return _database!;
  }

  // initializes database
  Future<Database> _initDB(String filePath) async {
    //android
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  // used to create database table 
  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';

    await db.execute('''CREATE TABLE $tableMistakes (
        ${MistakeFields.id} $idType, 
        ${MistakeFields.title} $textType, 
        ${MistakeFields.topic} $textType, 
        ${MistakeFields.desc} $textType, 
        ${MistakeFields.subject} $textType, 
        ${MistakeFields.time} $textType)''');
  }

  // creates an instance of a mistake and puts it into the database
  Future<Mistake> create(Mistake mistake) async {
    final db = await instance.database;

    final id = await db.insert(tableMistakes, mistake.toJson());
    return mistake.copy(id: id);
  }

  // returns a mistake within the database based on the id
  Future<Mistake> readMistake(int? id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableMistakes,
      columns: MistakeFields.values,
      where: '${MistakeFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Mistake.fromJson(maps.first);
    } else {
      throw Exception('ID $id is not found');
    }
  }

  // returns the list of mistakes within the database through returning the map and then converting it to a list
  Future<List<Mistake>> readAllMistakes() async {
    final db = await instance.database;

    final orderBy = '${MistakeFields.time} ASC';
    final result = await db.query(tableMistakes, orderBy: orderBy);

    return result.map((json) => Mistake.fromJson(json)).toList();
  }

  // updates a mistake
  Future<int> update(Mistake mistake) async {
    final db = await instance.database;

    return db.update(
      tableMistakes,
      mistake.toJson(),
      where: '${MistakeFields.id} = ?',
      whereArgs: [mistake.id],
    );
  }

  // deletes a mistake
  Future<int> delete(int? id) async {
    final db = await instance.database;

    return await db.delete(
      tableMistakes,
      where: '${MistakeFields.id} = ?',
      whereArgs: [id],
    );
  }

  // closes the database
  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
