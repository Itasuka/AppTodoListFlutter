class Todo {
  static int _cpt = 0;
  int _id = 0;
  String _message = "";
  bool _isDone = false;
  bool _isImportant = false;

  Todo(String message, [bool isDone = false, bool isImportant = false]) {
    _id = _cpt++;
    _message = message;
    _isDone = isDone;
    _isImportant = isImportant;
  }

  int getId() {return _id;}

  String? getMessage(){return _message;}

  bool getIsDone(){return _isDone;}

  void changeIsDone(){_isDone = !_isDone;}
  
  bool getIsImportant(){return _isImportant;}

  void changeIsImportant(){_isImportant = !_isImportant;}
}
