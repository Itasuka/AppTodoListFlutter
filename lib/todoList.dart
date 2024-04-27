import 'package:projet_todo_list/todo.dart';
import 'package:projet_todo_list/widgetTodo.dart';

class TodoList {
  final List<WidgetTodo> _widgetTodoList = List.empty(growable: true);
  static final TodoList _instance = TodoList.internal();
  bool _sortByIsImportant = false;
  bool _sortByIsDone = false;
  bool _sortById = false;

  factory TodoList() {
    return _instance;
  }

  TodoList.internal();

  void add(String message, Function() refresh) {
    Todo todoo = Todo(message);
    _widgetTodoList.add(WidgetTodo(todo: todoo, refresh: refresh));
  }

  void remove(Todo todo) {
    _widgetTodoList.removeWhere((widgetTodo) => widgetTodo.todo.getId() == todo.getId());
  }

  void setOrder(bool sortByIsImportant, bool sortByIsDone, bool sortById){
    _sortById = sortById;
    _sortByIsDone = sortByIsDone;
    _sortByIsImportant = sortByIsImportant;
  }

  List<Todo> getList() {
    return List.from(_widgetTodoList);
  }

  List<WidgetTodo> afficherList() {
    print("start: " + _sortByIsImportant.toString());
    print("finish: " + _sortByIsDone.toString());
    print("date: " + _sortById.toString());
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
