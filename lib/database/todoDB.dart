import 'package:projet_todo_list/database/databaseService.dart';
import 'package:projet_todo_list/models/todo.dart';
import 'package:sqflite/sqflite.dart';

class TodoDB{
  final tableName = 'todolist';

  //définition de la BDD et de sa structure
  Future<void> createTable(Database database) async{
    await database.execute("""CREATE TABLE IF NOT EXISTS $tableName(
      "id" INTEGER NOT NULL,
      "title" TEXT NOT NULL,
      "isDone" INTEGER NOT NULL,
      "isImportant" INTEGER NOT NULL,
      "date" TEXT,
      "description" TEXT,
      "city" TEXT,
      "lon" DOUBLE,
      "lat" DOUBLE,
      PRIMARY KEY("id" AUTOINCREMENT)
    );""");
  }

  //Ajout d'une nouvelle tache dans la BDD
  Future<int> create({required String title}) async {
    final database = await DatabaseService().database;
    return await database.rawInsert(
        """INSERT INTO $tableName (title, isDone, isImportant) VALUES(?, ?, ?)""",
        [title, 0, 0]
    );
  }

  //Suppression d'une tache de la BDD
  Future<void> delete(int id) async {
    final database = await DatabaseService().database;
    await database.rawDelete("""DELETE FROM $tableName WHERE id = ?""", [id]);
  }

  //Change l'état Done qui permet de savoir si une tache et fini
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

  //Change l'état important d'une teche
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

  //Mise à jour du titre, description, ville et date d'une tache
  Future<int> update({required int id, String? title, String? description, String? city, DateTime? date, double? lat, double? lon}) async {
    final database = await DatabaseService().database;
    return await database.update(
      tableName,
      {
        if(title != null) 'title': title,
        if(description != null) 'description': description,
        if(city != null) 'city': city,
        if(date != null) 'date': ("${date.day}/${date.month}/${date.year}"),
        if(lat != null) 'lat': lat,
        if(lon != null) 'lon': lon,
      },
      where: "id = ?",
      conflictAlgorithm: ConflictAlgorithm.rollback,
      whereArgs: [id],
    );
  }

  //Permet de recuperer toutes les taches dans la BDD
  Future<List<Todo>> fetchAll() async {
    final database = await DatabaseService().database;
    final todolist = await database.rawQuery(
      """SELECT * from $tableName ORDER BY id"""
    );
    return todolist.map((todo) => Todo.fromDatabase(todo)).toList();
  }

  int _boolConverter(bool? convert) => convert != null && convert ? 0 : 1;
}