import 'package:flutter_application_2/modals/Todo.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class TaskDatabaseHelper {
  static final TaskDatabaseHelper _instance = TaskDatabaseHelper._internal();
  factory TaskDatabaseHelper() => _instance;
  TaskDatabaseHelper._internal();

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, 'task_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE tasks (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            description TEXT,
            priority INTEGER,
            dueDate TEXT,
            isCompleted INTEGER
          )
        ''');
      },
    );
  }

  // Future<int> insertTask(Task task) async {
  //   final db = await database;
  //   return await db!.insert('tasks', task.toMap());
  // }
  Future<int> insertTask(Task task) async {
    final db = await database;
    final insertedId = await db!.insert('tasks', task.toMap());
    task.id = insertedId; // Update the Task object's id property
    return insertedId;
  }

  Future<List<Task>> getTasks({String? sortBy}) async {
    final db = await database;
    final orderBy = sortBy ?? 'priority ASC';
    final maps = await db!.query('tasks', orderBy: orderBy);
    return List.generate(maps.length, (i) => Task.fromMap(maps[i]));
  }

  Future<int> updateTask(Task task) async {
    final db = await database;
    return await db!
        .update('tasks', task.toMap(), where: 'id = ?', whereArgs: [task.id]);
  }

  Future<void> deleteTask(int id) async {
    final db = await database;
    await db!.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }
}
