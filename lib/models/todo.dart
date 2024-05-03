import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import 'weather.dart';

class Todo {
  static int _cpt = 0;
  int id = 0;
  String title = "";
  DateTime? date;
  String description = "";
  bool isDone = false;
  bool isImportant = false;
  String city = "";

  Todo.db({
    required this.id,
    required this.title,
    required this.description,
    required this.city,
    required this.date,
    required this.isDone,
    required this.isImportant
  });

  factory Todo.fromDatabase(Map<String, dynamic> map) => Todo.db(
    id: map['id']?.toInt() ?? 0,
    title: map['title'] ?? '',
    description: map['description'] ?? '',
    city: map['city'] ?? '',
    date: map['date'] != null
        ? DateFormat('dd/MM/yyyy').parse(map['date'])
        : null,
    isDone: map['isDone'] != null ? map['isDone'].toInt() == 1 : false,
    isImportant: map['isImportant'] != null ? map['isImportant'].toInt() == 1 : false,
  );

  String getDate() {
    if(date == null) {
      return "";
    }
    return DateFormat('dd/MM/yyyy').format(date as DateTime);
  }

  Future<Weather> getWeather() async{
    String baseUrl = 'http://api.openweathermap.org/data/2.5/weather';
    String apiKey = '9ad79100fdf5b50dcb1b0e38caa4be33';
    final response = await http.get(Uri.parse('$baseUrl?q=$city&appid=$apiKey&units=metric'));

    if(response.statusCode == 200){
      return Weather.fromJson(jsonDecode(response.body));
    }
    else{
      throw Exception('Impossible de trouver la météo');
    }
  }
}
