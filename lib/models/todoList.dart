import 'package:projet_todo_list/database/todoDB.dart';
import 'package:projet_todo_list/models/todo.dart';
import 'package:projet_todo_list/pages/widgetTodo.dart';

class TodoList {
  final List<WidgetTodo> _widgetTodoList = List.empty(growable: true);
  static final TodoList _instance = TodoList.internal();
  final todoDB = TodoDB();
  bool _sortByIsImportant = false;
  bool _sortByIsDone = false;
  bool _sortById = false;

  factory TodoList() {
    return _instance;
  }

  TodoList.internal();

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

  void setOrder(bool sortByIsImportant, bool sortByIsDone, bool sortById){
    _sortById = sortById;
    _sortByIsDone = sortByIsDone;
    _sortByIsImportant = sortByIsImportant;
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

  List<WidgetTodo> afficherList() {
    sortTodoList();
    return _widgetTodoList;
  }

  void sortTodoList() {
    _widgetTodoList.sort((a, b) {

      if (_sortByIsDone) {
        if (!a.todo.getIsDone() && b.todo.getIsDone()) {
          return -1;
        } else if (a.todo.getIsDone() && !b.todo.getIsDone()) {
          return 1;
        }
      }

      if (_sortByIsImportant) {
        if (a.todo.getIsImportant() && !b.todo.getIsImportant()) {
          return -1;
        } else if (!a.todo.getIsImportant() && b.todo.getIsImportant()) {
          return 1;
        }
      }

      if (_sortById) {
        return a.todo.getId().compareTo(b.todo.getId());
      }

      return 0;
    });
  }

  bool getCreationDate() {
    return _sortById;
  }

  bool getFavorites() {
    return _sortByIsImportant;
  }

  bool getInProgress() {
    return _sortByIsDone;
  }
}
