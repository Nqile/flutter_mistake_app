import 'package:flutter_mistake_app/Mistake.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class MistakeDatabase {
  static final MistakeDatabase instance = MistakeDatabase._init();

  static Database? _database;

  MistakeDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('mistakes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    //android
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

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

  Future<Mistake> create(Mistake mistake) async {
    final db = await instance.database;

    final id = await db.insert(tableMistakes, mistake.toJson());
    return mistake.copy(id: id);
  }

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

  Future<List<Mistake>> readAllMistakes() async {
    final db = await instance.database;

    final orderBy = '${MistakeFields.time} ASC';
    final result = await db.query(tableMistakes, orderBy: orderBy);

    return result.map((json) => Mistake.fromJson(json)).toList();
  }

  Future<int> update(Mistake mistake) async {
    final db = await instance.database;

    return db.update(
      tableMistakes,
      mistake.toJson(),
      where: '${MistakeFields.id} = ?',
      whereArgs: [mistake.id],
    );
  }

  Future<int> delete(int? id) async {
    final db = await instance.database;

    return await db.delete(
      tableMistakes,
      where: '${MistakeFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
