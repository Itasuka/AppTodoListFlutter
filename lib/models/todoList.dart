import 'package:flutter/widgets.dart';
import 'package:projet_todo_list/database/todoDB.dart';
import 'package:projet_todo_list/models/todo.dart';
import 'package:projet_todo_list/pages/WidgetTodoSeparator.dart';
import 'package:projet_todo_list/pages/widgetTodo.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<void> init() async{
    prefs = await SharedPreferences.getInstance();
    _displayIsDone = prefs.getBool('displayIsDone') ?? true;
    _sortByIsImportant = prefs.getBool('sortByIsImportant') ?? true;
  }

  void initialisation(Function() refresh) async {
    List<Todo> todolist = await todoDB.fetchAll();
    _widgetTodoList.clear();
    for (Todo todo in todolist) {
      _widgetTodoList.add(WidgetTodo(todo: todo, refresh: refresh));
    }
    refresh();
  }

  void add(String message, Function() refresh) async {
    await todoDB.create(title: message);
    initialisation(refresh);
  }

  void remove(Todo todo, Function() refresh) async{
    await todoDB.delete(todo.id);
    initialisation(refresh);
  }

  void updateIsDone(Todo todo, Function() refresh) async{
    await todoDB.updateIsDone(id:todo.id, done:todo.isDone);
    initialisation(refresh);
  }

  void updateIsImportant(Todo todo, Function() refresh) async{
    await todoDB.updateIsImportant(id:todo.id, important:todo.isImportant);
    initialisation(refresh);
  }

  void update(Todo todo, String? title, String? description, String? city, DateTime? date, Function() refresh) async{
    if(description == "") description = null;
    if(city == "") city = null;

    await todoDB.update(id:todo.id, title: title, description: description, city: city, date: date);
    initialisation(refresh);
  }

  Future<void> setDisplayIsDone() async {
    _displayIsDone = !_displayIsDone;
    await prefs.setBool('displayIsDone', _displayIsDone);
  }

  Future<void> setOrder() async {
    _sortByIsImportant = !_sortByIsImportant;
    await prefs.setBool('sortByIsImportant', _sortByIsImportant);
  }

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

  List<Todo> getList() {
    return List.from(_widgetTodoList);
  }

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

    if (done.isNotEmpty) {
      notDone.add(WidgetTodoSeparator(refresh: refresh));
      if(_displayIsDone) {
        notDone.addAll(done);
      }
    }

    return notDone;
  }

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

  bool getFavorites() {
    return _sortByIsImportant;
  }

  getDisplayIsDone() {
    return _displayIsDone;
  }
}
