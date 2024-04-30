import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import 'weather.dart';

class Todo {
  static int _cpt = 0;
  int _id = 0;
  String _title = "";
  DateTime? _date;
  String _description = "";
  bool _isDone = false;
  bool _isImportant = false;
  String _city = "reims";

  Todo(String message, [bool isDone = false, bool isImportant = false]) {
    _id = _cpt++;
    _title = message;
    _isDone = isDone;
    _isImportant = isImportant;

  }

  int getId() {
    return _id;
  }

  String getTitle() {
    return _title;
  }

  void setDate(DateTime date){
    _date = date;
  }

  String getDate() {
    if(_date == null) {
      return "";
    }
    return DateFormat('dd/MM/yyyy').format(_date as DateTime);
  }

  void setDescription(String description){
    _description = description;
  }

  String getDescription(){
    return _description;
  }

  void setCity(String city){
    _city = city;
  }

  String getCity(){
    return _city;
  }

  Future<Weather> getWeather() async{
    String baseUrl = 'http://api.openweathermap.org/data/2.5/weather';
    String apiKey = '9ad79100fdf5b50dcb1b0e38caa4be33';
    final response = await http.get(Uri.parse('$baseUrl?q=$_city&appid=$apiKey&units=metric'));
    print('$baseUrl?q=$_city&appid=$apiKey&units=metric');

    if(response.statusCode == 200){
      return Weather.fromJson(jsonDecode(response.body));
    }
    else{
      throw Exception('Impossible de trouver la météo');
    }
  }

  bool getIsDone() {
    return _isDone;
  }

  void changeIsDone() {
    _isDone = !_isDone;
  }

  bool getIsImportant() {
    return _isImportant;
  }

  void changeIsImportant() {
    _isImportant = !_isImportant;
  }
}
