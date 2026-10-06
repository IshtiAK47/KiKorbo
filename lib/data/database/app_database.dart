import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/task_model.dart';

class AppDatabase {
  static const String _databaseName = 'kikorbo.db';
  static const int _databaseVersion = 1;
  static const String tableTasks = 'tasks';

  static AppDatabase? _instance;
  static Database? _database;

  AppDatabase._internal();

  factory AppDatabase() {
    _instance ??= AppDatabase._internal();
    return _instance!;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableTasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        date TEXT NOT NULL,
        start_hour INTEGER NOT NULL,
        start_minute INTEGER NOT NULL,
        duration_minutes INTEGER NOT NULL,
        category TEXT NOT NULL,
        emoji TEXT NOT NULL,
        timer_type TEXT NOT NULL,
        is_completed INTEGER NOT NULL DEFAULT 0,
        is_skipped INTEGER NOT NULL DEFAULT 0,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL
      )
    ''');
  }

  Future<int> insertTask(TaskModel task) async {
    final db = await database;
    return await db.insert(tableTasks, task.toMap());
  }

  Future<int> updateTask(TaskModel task) async {
    final db = await database;
    if (task.id == null) return 0;
    return await db.update(
      tableTasks,
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> deleteTask(int id) async {
    final db = await database;
    return await db.delete(
      tableTasks,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<TaskModel>> getTasksForDate(DateTime date) async {
    final db = await database;
    final dateStr =
        '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    final List<Map<String, dynamic>> maps = await db.query(
      tableTasks,
      where: 'date = ?',
      whereArgs: [dateStr],
      orderBy: 'start_hour ASC, start_minute ASC',
    );
    return maps.map((m) => TaskModel.fromMap(m)).toList();
  }

  Future<List<TaskModel>> getAllTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableTasks,
      orderBy: 'date ASC, start_hour ASC, start_minute ASC',
    );
    return maps.map((m) => TaskModel.fromMap(m)).toList();
  }

  Future<void> clearAll() async {
    final db = await database;
    await db.delete(tableTasks);
  }
}
