import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import 'weather.dart';

//Classe représantant les taches
class Todo {
  int id = 0;
  String title = "";
  DateTime? date;
  String description = "";
  bool isDone = false;
  bool isImportant = false;
  String address = "";
  double lat = 0;
  double lon = 0;

  Todo.db({
    required this.id,
    required this.title,
    required this.description,
    required this.address,
    required this.date,
    required this.isDone,
    required this.isImportant,
    required this.lat,
    required this.lon,
  });

  //Permet de construire une tache depuis la BDD
  factory Todo.fromDatabase(Map<String, dynamic> map) => Todo.db(
    id: map['id']?.toInt() ?? 0,
    title: map['title'] ?? '',
    description: map['description'] ?? '',
    address: map['city'] ?? '',
    date: map['date'] != null
        ? DateFormat('dd/MM/yyyy').parse(map['date'])
        : null,
    isDone: map['isDone'] != null ? map['isDone'].toInt() == 1 : false,
    isImportant: map['isImportant'] != null ? map['isImportant'].toInt() == 1 : false,
    lat: map['lat'] ?? 0.0,
    lon: map['lon'] ?? 0.0,
  );

  //Recuperation de la date convertie en string
  String getDate() {
    if(date == null) {
      return "";
    }
    return DateFormat('dd/MM/yyyy').format(date as DateTime);
  }

  //retourne l'objet weather lié à la tache
  Future<Weather> getWeather() async{
    String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';
    String apiKey = '9ad79100fdf5b50dcb1b0e38caa4be33';

    //regarde si le serveur retourne une solution pour la position et créé un objet Weather
    final response = await http.get(Uri.parse('$baseUrl?lat=$lat&lon=$lon&appid=$apiKey&units=metric'));
    if(response.statusCode == 200){
      return Weather.fromJson(jsonDecode(response.body), lat, lon);
    }
    else{
      throw Exception('Impossible de trouver la météo');
    }

  }
}
