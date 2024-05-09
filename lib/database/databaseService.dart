import 'package:projet_todo_list/database/todoDB.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/// classe permanent l'initialisation et la mise en place de la BDD
class DatabaseService{
  // Instance de la base de données
  Database? _database;

  /// Initialisation et récuperation du singleton DatabaseService
  Future<Database> get database async{
    if (_database != null) {
      return _database!;
    }
    _database = await _initialize();
    return _database!;
  }

  ///Permet d'obtenir le chemin vers la BDD
  Future<String> get fullPath async{
    const name = 'todo.db';
    final path = await getDatabasesPath();
    return join(path, name);
  }

  ///Initialisation de la BDD sur l'appareil
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

  ///Fonction utilisé pour la création de la BDD
  Future<void> _create(Database database, int version) async =>
      await TodoDB().createTable(database);
}