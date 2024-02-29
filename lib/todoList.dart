import 'package:projet_todo_list/todo.dart';


class ToDoList {
  final List<ToDo> _todoList = List.empty(growable: true);
  static ToDoList? _instance;

  void add(String message){
    _todoList.add(ToDo(message));
  }

  ToDoList(){
    _todoList.add(ToDo("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus non pellentesque odio, feugiat feugiat metus. Praesent blandit risus ut dolor laoreet fringilla. Donec ac magna neque. Nunc dolor elit, interdum sit amet ante ac, suscipit condimentum nisi. Proin venenatis metus at eros vehicula vulputate. Mauris eget tincidunt massa, vel fringilla augue. Curabitur vitae hendrerit sem. Vestibulum lectus nulla, aliquet eu est scelerisque, euismod semper arcu. Pellentesque non lacus et dolor eleifend tempor. Phasellus placerat pharetra enim in porttitor. Nullam egestas condimentum ultrices. Quisque diam tortor, accumsan ac euismod nec, fringilla ac ligula. Donec fringilla in neque eu dapibus. Nam nec augue rutrum, euismod elit et, scelerisque diam. Maecenas pretium augue sed ex rhoncus sagittis."));
  }

  static ToDoList getInstance(){
    return _instance ??= ToDoList();
  }

  List<ToDo> getList() {return List.from(_todoList);}
}