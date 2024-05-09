import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' as flutter_map;

import 'package:latlong2/latlong.dart';
import 'package:lottie/lottie.dart';
import 'package:projet_todo_list/models/colors.dart';
import 'package:projet_todo_list/models/todo.dart';
import 'package:projet_todo_list/models/todoList.dart';
import 'package:projet_todo_list/pages/widgetMap.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/weather.dart';
import 'widgetEditTodo.dart';

///Gestion de l'affichage de chaque tâches ainsi que de sa popup de détail
class WidgetTodo extends StatefulWidget {
  WidgetTodo({Key? key, required this.todo, required this.refresh})
      : super(key: key);
  Todo todo;
  final Function() refresh;

  @override
  State<WidgetTodo> createState() => _WidgetToDoState();
}

class _WidgetToDoState extends State<WidgetTodo> {
  Weather? _weather;

  @override
  Widget build(BuildContext context) {
    return
      GestureDetector(
        //affiche la popup de détail quand on clique sur une tâche
        onTap: () {todoDetail();},
        child:Container(
          decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppColor().separator(),
                  width: 2.0,
                )
              )
          ),
          //Dismissible permet d'ajouter en favoris ou supprimer une tâche
          child: Dismissible(
            direction: DismissDirection.horizontal,
            key: UniqueKey(),
            resizeDuration: null,
            onDismissed: (DismissDirection direction) {
              //Mouvement de droite à gauche pour supprimer une tache
              if (direction == DismissDirection.endToStart) {
                TodoList().remove(widget.todo, widget.refresh);
              }
              //Mouvement de gauche à droite pour mettre en favorie une tache
              if (direction == DismissDirection.startToEnd) {
                setState(() {
                  TodoList().updateIsImportant(widget.todo, widget.refresh);
                });
              }
            },
            confirmDismiss: (direction) async {
              //Ouvre une popup pour supprimer et accept directement pour les favoris
              if (direction == DismissDirection.endToStart) {
                return askForDelete();
              } else{
                return true;
              }
            },
            background: ColoredBox(
              color: AppColor().starButton(),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Icon(Icons.star, color: AppColor().iconOnColor()),
                ),
              ),
            ),
            secondaryBackground: ColoredBox(
              color: AppColor().deleteButton(),
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Icon(Icons.delete, color: AppColor().iconOnColor()),
                ),
              ),
            ),
              //Affichage des élements composant une tache(bouton fini, favori, titre, date, supprimer, éditer)
            child:Container(
              color: widget.todo.isDone ? AppColor().backgroundColorCheck() : AppColor().backgroundColor(),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                leading: Row(mainAxisSize: MainAxisSize.min, children: [
                  IconButton(
                      onPressed: () {
                        setState(() {
                          TodoList().updateIsDone(widget.todo, widget.refresh);
                        });
                      },
                      icon: Icon(
                        widget.todo.isDone
                            ? Icons.check_box
                            : Icons.check_box_outline_blank,
                        color: AppColor().textTodo(),
                      )),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        TodoList().updateIsImportant(widget.todo, widget.refresh);
                      });
                    },
                    icon: Icon(
                      widget.todo.isImportant ? Icons.star : Icons.star_outline,
                      color: AppColor().starButton(),
                    ),
                  )
                ]),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:[
                    Text(
                      overflow: TextOverflow.ellipsis,
                      widget.todo.title ?? "",
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColor().textTodo(),
                        fontWeight: FontWeight.bold,
                        decoration:
                            widget.todo.isDone ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    if (widget.todo.date != null)
                      Text(
                        widget.todo.getDate(),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColor().textTodo(),
                          decoration: widget.todo.isDone ? TextDecoration.lineThrough : null,
                        ),
                      ),
                  ]
                ),
                trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                  IconButton(
                    onPressed: () async {
                      if(await askForDelete()) {
                        TodoList().remove(widget.todo, widget.refresh);
                      }
                    },
                    icon: Icon(
                      Icons.delete,
                      color: AppColor().deleteButton(),
                    )
                  ),
                  IconButton(
                    icon: Icon(Icons.edit, color: AppColor().textTodo(),),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => WidgetEditTodo(todo: widget.todo, refresh: affichage)),
                      );
                    },
                  ),
                ]),
              ),
            )
          )
        )
      );
  }

  ///Popup pour confirmation de suppressions d'une tache
  Future<bool> askForDelete() async {
    bool dismiss = false;
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Voulez-vous vraiment supprimer cette tâche?"),
          actions: [
            TextButton(
              onPressed: () {
                dismiss = true;
                Navigator.pop(context);
              },
              child: const Text("Oui"),
            ),
            TextButton(
              onPressed: () {
                dismiss = false;
                Navigator.pop(context);
              },
              child: const Text("Non"),
            ),
          ],
        );
      },
    );
    return dismiss;
  }

  ///Permet de recuperer l'heure d'une coordonnée géographique
  Future<DateTime> timeByLocation({required double latitude, required double longitude}) async {
    const String urlLocation = 'https://www.timeapi.io/api/Time/current/coordinate?';
    final String url = '${urlLocation}latitude=$latitude&longitude=$longitude';
    const Map<String, String> headers = {'Content-type': 'application/json; charset=UTF-8'};
    //si on a une erreur lors de la récupération de l'heure on rethrow l'erreur à la fonction appelante
    try {
      http.Response response = await http.get(
        Uri.parse(url),
        headers: headers,
      );
      final String data = utf8.decode(response.bodyBytes.toList());
      if (response.statusCode != 200) {
        return DateTime(1990);
      }
      final Map json = jsonDecode(data);
      return DateTime.tryParse(json['dateTime']) ?? DateTime(1990);
    }catch (e) {
      rethrow;
    }
  }

  ///Permet de définir l'animation à jouer pour la météo en fonction de la météo et de l'heure
  ///géographique de l'adresse fournie
  Future<String> weatherAnimation(String? condition) async {
    String res = 'assets/';

    //Par défaut retourner un soleil
    if (condition == null) return 'assets/sunny.json';
    //Vérification de l'heure et ajout de 'n' dans res pour prendre les images de nuit
    //On ne retourne rien dans le catch car on veut juste ignorer les erreurs
    if (_weather != null) {
      try {
        DateTime timeZone = await timeByLocation(
            latitude: _weather!.lat, longitude: _weather!.lon);
        if (timeZone.hour < 7 || 21 < timeZone.hour) {
          res += 'n';
        }
      }catch(e){}
    }

    //ajout de la condition météo
    switch (condition.toLowerCase()) {
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
      case 'clouds':
        res += 'clouds.json';
        break;
      case 'drizzle':
      case 'shower rain':
      case 'rain':
        res += 'rain.json';
        break;
      case 'thunderstorm':
        res += 'thunderstorm.json';
        break;
      case 'clear':
        res += 'sunny.json';
        break;
      default:
        res += 'sunny.json';
    }
    return res;
  }

  ///Fonction retournant une liste de widgets en fonction des données ajouté à la tache
  Widget setWidgetDetail(Weather? _weather) {
    //Liste de widget retourné en fonction des données que la tâche comprend.
    //Si une donnée est vide on ne l'ajoute pas à la liste
    List<Widget> widgetsList = [];
    double mapSize = min(MediaQuery.of(context).size.width * 0.5, MediaQuery.of(context).size.height * 0.5);
    if (widget.todo.description != "") {
      widgetsList.add(
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Description: ',
                style: TextStyle(fontWeight: FontWeight.bold, color: AppColor().textColor()),
              ),
              TextSpan(
                text: widget.todo.description,
                style: TextStyle(color: AppColor().textColor()),
              ),
            ],
          ),
        ),
      );
    }
    //Ajout de la date à la liste de widget
    if (widget.todo.getDate() != ""){
      widgetsList.add(
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Date d\'échéance: ',
                style: TextStyle(fontWeight: FontWeight.bold, color: AppColor().textColor()),
              ),
              TextSpan(
                text: widget.todo.getDate(),
                style: TextStyle(color: AppColor().textColor()),
              ),
            ],
          ),
        ),
      );
    }
    //Ajoute l'adresse à la liste de widget
    if(widget.todo.address != ""){
      widgetsList.add(
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Adresse: ',
                style: TextStyle(fontWeight: FontWeight.bold, color: AppColor().textColor()),
              ),
              TextSpan(
                text: widget.todo.address,
                style: TextStyle(color: AppColor().textColor()),
              ),
            ],
          ),
        ),
      );
    }
    //Ajoute du widget map à la liste de widget et mise au point d'un curseur en fonction de la coordonnée
    //gps choisi
    if(_weather != null && _weather.lon != 0 && _weather.lat != 0){
      widgetsList.add(const SizedBox(height: 16),);
      widgetsList.add(
       Center(
        child:Column(
          children: <Widget>[
            SizedBox(
              width: mapSize,
              height: mapSize,
              child: Stack(
                children: [
                  flutter_map.FlutterMap(
                  options: flutter_map.MapOptions(
                    initialCenter: LatLng(_weather.lat, _weather.lon),
                    initialZoom: 11,

                  ),
                  children: [
                    flutter_map.TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                    ),
                    flutter_map.MarkerLayer(markers: [
                      flutter_map.Marker(
                        point:LatLng(_weather.lat, _weather.lon),
                        width: 60,
                        height: 60,
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.location_pin,
                          size: 40,
                          color: Colors.red,
                        )
                      )
                    ]),
                  ],
                ),
                //Bouton permettant d'aller sur la map en pleine écran
                Positioned(
                  bottom: 5,
                  right: 5,
                  child: FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => WidgetMap(weather: _weather, title: widget.todo.title,)),
                      );
                    },
                    mini: true,
                    child: const Icon(Icons.fullscreen),
                  ),
                ),
              ])
            ),
            //affichage de l'icone de météo
            SizedBox(
              height: 80,
              width: 80,
              child: FutureBuilder<String>(
                future: weatherAnimation(_weather.condition),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Erreur: ${snapshot.error}');
                  } else {
                    String animationPath = snapshot.data!;
                    return Lottie.asset(animationPath);
                  }
                },
              ),
            ),
            //Affichage des température
            Text("Actuel: ${_weather.temp ?? 0}°C",
              softWrap: true,
              style: TextStyle(fontWeight: FontWeight.bold, color: AppColor().textColor()),
            ),
            Text("Min: ${_weather.minTemp ?? 0}°C | Max: ${_weather.maxTemp ?? 0}°C",
              softWrap: true,
              style: TextStyle(fontWeight: FontWeight.bold, color: AppColor().textColor()),
            )
          ]
          )
        ),
      );
    }
    //Si juste un titre est enregistré on retourne un message d'erreur
    if(widgetsList.isEmpty){
      return Text("Vous n'avez pas encore édité cette activité. \n"
          "Une fois cela fait, vous aurez toutes les informations renseignées qui apparaîtront ici.", style: TextStyle(color: AppColor().textColor()),);
    }
    //sinon on retourne la liste des différents widget remplis
    else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widgetsList,
      );
    }
  }

  //Affichage du popup de détail des taches en fonction des données ajouté
  Future todoDetail() async {
    await updateTodoDetail();
    return showDialog(
      context: context,
      builder: (context) {
        return SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          height: MediaQuery.of(context).size.height * 0.7,
          child: SingleChildScrollView(
            child: AlertDialog(
              backgroundColor: AppColor().background(),
              title: Row(
                children: [
                  Expanded(
                    child: Text(widget.todo.title, style: TextStyle(color: AppColor().textColor()),),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
          content: setWidgetDetail(_weather)),
          ),
        );
      },
    );
  }

  ///Pour la mise à jour d'une tache après son édition
  Future<void> updateTodoDetail() async {
    try {
      final updatedTodo = await TodoList().getTodo(widget.todo, widget.refresh);
      final weather = await widget.todo.getWeather();
      setState(() {
        widget.todo = updatedTodo;
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }
  ///Fonction passé en paramêtre au widget d'edition pour la mise à jour des taches
  void affichage()async{
    setState((){
      updateTodoDetail();
    });
  }
}
