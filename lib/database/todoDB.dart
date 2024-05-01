import 'package:projet_todo_list/database/databaseService.dart';
import 'package:projet_todo_list/models/todo.dart';
import 'package:sqflite/sqflite.dart';

class TodoDB{
  final tableName = 'todolist';

  Future<void> createTable(Database database) async{
    await database.execute("""CREATE TABLE IF NOT EXISTS $tableName(
      "id" INTEGER NOT NULL,
      "title" TEXT NOT NULL,
      "isDone" INTEGER NOT NULL,
      "isImportant" INTEGER NOT NULL,
      "date" TEXT,
      "description" TEXT,
      "city" TEXT,
      PRIMARY KEY("id" AUTOINCREMENT)
    );""");
  }

  Future<int> create({required String title}) async {
    final database = await DatabaseService().database;
    return await database.rawInsert(
        """INSERT INTO $tableName (title, isDone, isImportant) VALUES(?, ?, ?)""",
        [title, 0, 0]
    );
  }

  Future<void> delete(int id) async {
    final database = await DatabaseService().database;
    await database.rawDelete("""DELETE FROM $tableName WHERE id = ?""", [id]);
  }

  Future<int> updateIsDone({required int id, bool? done}) async {
    final database = await DatabaseService().database;
    return await database.update(
      tableName,
      {
        "isDone": _boolConverter(done),
      },
      where: "id = ?",
      conflictAlgorithm: ConflictAlgorithm.rollback,
      whereArgs: [id],
    );
  }

  Future<int> updateIsImportant({required int id, bool? important}) async {
    final database = await DatabaseService().database;
    return await database.update(
      tableName,
      {
        "isImportant": _boolConverter(important),
      },
      where: "id = ?",
      conflictAlgorithm: ConflictAlgorithm.rollback,
      whereArgs: [id],
    );
  }

  Future<int> update({required int id, String? title, String? description, String? city, DateTime? date}) async {
    final database = await DatabaseService().database;
    return await database.update(
      tableName,
      {
        if(title != null) 'title': title,
        if(description != null) 'description': description,
        if(city != null) 'city': city,
        if(date != null) 'date': ("${date.day}/${date.month}/${date.year}"),
      },
      where: "id = ?",
      conflictAlgorithm: ConflictAlgorithm.rollback,
      whereArgs: [id],
    );
  }

  Future<List<Todo>> fetchAll() async {
    final database = await DatabaseService().database;
    final todolist = await database.rawQuery(
      """SELECT * from $tableName ORDER BY id"""
    );
    return todolist.map((todo) => Todo.fromDatabase(todo)).toList();
  }

  int _boolConverter(bool? convert) => convert != null && convert ? 0 : 1;
}