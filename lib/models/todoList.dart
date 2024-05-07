import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:projet_todo_list/database/todoDB.dart';
import 'package:projet_todo_list/models/todo.dart';
import 'package:projet_todo_list/pages/WidgetTodoSeparator.dart';
import 'package:projet_todo_list/pages/widgetTodo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

//Objet singleton permettant la gestion de la liste de tache à travers l'application
class TodoList {
  final List<WidgetTodo> _widgetTodoList = List.empty(growable: true);
  static final TodoList _instance = TodoList.internal();
  final todoDB = TodoDB();
  bool _sortByIsImportant = true;
  bool _displayIsDone = true;
  late SharedPreferences prefs;

  factory TodoList() {
    return _instance;
  }

  TodoList.internal(){
    init();
  }

  //Set les options de trie de l'application enregistrées dans des sharedPreferences
  Future<void> init() async{
    prefs = await SharedPreferences.getInstance();
    _displayIsDone = prefs.getBool('displayIsDone') ?? true;
    _sortByIsImportant = prefs.getBool('sortByIsImportant') ?? true;
  }

  //Met à jour la liste de tache depuis la BDD
  void initialisation(Function() refresh) async {
    List<Todo> todolist = await todoDB.fetchAll();
    _widgetTodoList.clear();
    for (Todo todo in todolist) {
      _widgetTodoList.add(WidgetTodo(todo: todo, refresh: refresh));
    }
    refresh();
  }

  //Ajout d'une tache
  void add(String message, Function() refresh) async {
    await todoDB.create(title: message);
    initialisation(refresh);
  }

  //Suppression d'une tache
  void remove(Todo todo, Function() refresh) async{
    await todoDB.delete(todo.id);
    initialisation(refresh);
  }

  //Mise à jour de l'état fini ou non de la tache
  void updateIsDone(Todo todo, Function() refresh) async{
    await todoDB.updateIsDone(id:todo.id, done:todo.isDone);
    initialisation(refresh);
  }

  //Mise à jour de l'état d'importance d'une tache
  void updateIsImportant(Todo todo, Function() refresh) async{
    await todoDB.updateIsImportant(id:todo.id, important:todo.isImportant);
    initialisation(refresh);
  }

  //Mise à jour du contenu d'une tache
  void update(Todo todo, String? title, String? description, String? city, DateTime? date, Function() refresh) async{
    double lat = 0;
    double lon = 0;
    if(description == "") description = null;
    if(city == "") city = null;

    String url = 'https://nominatim.openstreetmap.org/search?format=json&q=$city';

    var responseLatLon = await http.get(Uri.parse(url));
    var responseBody = json.decode(responseLatLon.body);
    if (responseBody != null && responseBody.isNotEmpty) {
      lat = double.parse(responseBody[0]['lat']);
      lon = double.parse(responseBody[0]['lon']);
    }

    await todoDB.update(id:todo.id, title: title, description: description, city: city, date: date, lat: lat, lon: lon);
    initialisation(refresh);
  }

  //Change l'options de l'affichage des tache finis
  Future<void> setDisplayIsDone() async {
    _displayIsDone = !_displayIsDone;
    await prefs.setBool('displayIsDone', _displayIsDone);
  }

  //Permet de changet le type d'affichage de la liste de tache
  Future<void> setOrder() async {
    _sortByIsImportant = !_sortByIsImportant;
    await prefs.setBool('sortByIsImportant', _sortByIsImportant);
  }

  //Retourne une tache particuliere de la liste de tache
  Future<Todo> getTodo(Todo todo, Function() refresh) async {
    List<Todo> todolist = await todoDB.fetchAll();
    Todo res = todo;
    _widgetTodoList.clear();
    for (Todo todoo in todolist) {
      if(todo.id == todoo.id) res = todoo;
      _widgetTodoList.add(WidgetTodo(todo: todoo, refresh: refresh));
    }
    refresh();
    return res;
  }

  //Retourne la liste de widget de taches
  List<Todo> getList() {
    return List.from(_widgetTodoList);
  }

  //Permet l'affichage de la liste de tache en fonction de l'ordre choisi
  List<Widget> afficherList(Function() refresh) {
    sortTodoList();
    List<Widget> notDone = [];
    List<Widget> done = [];

    for (var widgetTodo in _widgetTodoList) {
      if (widgetTodo.todo.isDone) {
        done.add(widgetTodo);
      } else {
        notDone.add(widgetTodo);
      }
    }
    //Affiche ou non les taches finis
    if (done.isNotEmpty) {
      notDone.add(WidgetTodoSeparator(refresh: refresh));
      if(_displayIsDone) {
        notDone.addAll(done);
      }
    }
    return notDone;
  }

  //Organise les taches en fonction des choix de l'utilisateur
  void sortTodoList() {
    _widgetTodoList.sort((a, b) {
      // Pour mettre les taches terminees en bas
      if (a.todo.isDone != b.todo.isDone) {
        return a.todo.isDone ? 1 : -1;
      }
      // Tri par importance de la tache
      if (_sortByIsImportant) {
        if (a.todo.isImportant && !b.todo.isImportant) {
          return -1;
        } else if (!a.todo.isImportant && b.todo.isImportant) {
          return 1;
        }
        else{
          return a.todo.id.compareTo(b.todo.id);
        }
      }
      // Tri par date de saisie ou de derniere modification
      if (a.todo.date != null && b.todo.date != null) {
        int dateComparison = a.todo.date!.compareTo(b.todo.date!);
        if (dateComparison != 0) {
          return dateComparison;
        }
      }
      else if (a.todo.date == null && b.todo.date != null) {
        return 1;
      }
      else if (a.todo.date != null && b.todo.date == null) {
        return -1;
      }
      else {
        return a.todo.id.compareTo(b.todo.id);
      }
      return 0;
    });
  }

  //Retourne l'état de l'option de trie en fonction de l'importance
  bool getFavorites() {
    return _sortByIsImportant;
  }

  //Retourne si l'application doit afficher ou non les taches finis
  getDisplayIsDone() {
    return _displayIsDone;
  }

  Future<bool> checkAdressAvailability(String address) async {
    String url = 'https://nominatim.openstreetmap.org/search?format=json&q=$address';
    var response = await http.get(Uri.parse(url));
    var responseBody = json.decode(response.body);
    if (responseBody != null && responseBody.isNotEmpty) {
      return true;
    }
    return false;
  }
}
