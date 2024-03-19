import 'package:projet_todo_list/todo.dart';
import 'package:projet_todo_list/widgetTodo.dart';

class TodoList {
  final List<WidgetTodo> _widgetTodoList = List.empty(growable: true);
  static final TodoList _instance = TodoList.internal();

  factory TodoList() {
    return _instance;
  }

  TodoList.internal();

  void add(String message) {
    Todo todoo = Todo(message);
    _widgetTodoList.add(WidgetTodo(todo: todoo, supprimer: remove));
  }

  void remove(Todo todo) {
    _widgetTodoList.remove(todo);
  }

  List<Todo> getList() {
    return List.from(_widgetTodoList);
  }

  List<WidgetTodo> afficherList() {
    return _widgetTodoList;
  }
}
