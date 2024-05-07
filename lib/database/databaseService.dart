import 'package:projet_todo_list/database/todoDB.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

//classe permettant l'initialisation et la mise en place de la BDD
class DatabaseService{
  Database? _database;

  //BDD de type singleton
  Future<Database> get database async{
    if (_database != null) {
      return _database!;
    }
    _database = await _initialize();
    return _database!;
  }

  //permet d'obtenir le chemin vers la BDD
  Future<String> get fullPath async{
    const name = 'todo.db';
    final path = await getDatabasesPath();
    return join(path, name);
  }

  //initialisation de la BDD
  Future<Database> _initialize() async{
    final path = await fullPath;
    var database = await openDatabase(
      path,
      version: 1,
      onCreate: _create,
      singleInstance: true,
    );
    return database;
  }

  //fonction utilisé pour la création de la BDD
  Future<void> _create(Database database, int version) async =>
      await TodoDB().createTable(database);
}