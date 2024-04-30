import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' as flutter_map;
import 'package:latlong2/latlong.dart';
import 'package:lottie/lottie.dart';
import 'package:projet_todo_list/colors.dart';
import 'package:projet_todo_list/models/todo.dart';
import 'package:projet_todo_list/models/todoList.dart';
import 'package:projet_todo_list/pages/widgetMap.dart';

import '../models/weather.dart';
import 'widgetEditTodo.dart';

class WidgetTodo extends StatefulWidget {
  const WidgetTodo({Key? key, required this.todo, required this.refresh})
      : super(key: key);
  final Todo todo;
  final Function() refresh;

  @override
  State<WidgetTodo> createState() => _WidgetToDoState();
}

class _WidgetToDoState extends State<WidgetTodo> {
  @override
  Widget build(BuildContext context) {
    return
      GestureDetector(
        onTap: () {todoDetail();},
        child:Container(
          decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: separator,
                  width: 1.0,
                )
              )
          ),
          child: Dismissible(
            direction: DismissDirection.horizontal,
            key: UniqueKey(),
            resizeDuration: null,
            onDismissed: (DismissDirection direction) {
              if (direction == DismissDirection.endToStart) {
                TodoList().remove(widget.todo);
                widget.refresh();
              }
              if (direction == DismissDirection.startToEnd) {
                setState(() {
                  widget.todo.changeIsImportant();
                  widget.refresh();
                });
              }
            },
            confirmDismiss: (direction) async {
              if (direction == DismissDirection.endToStart) {
                return askForDelete();
              } else{
                return true;
              }
            },
            background: const ColoredBox(
              color: starButton,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Icon(Icons.star, color: iconOnColor),
                ),
              ),
            ),
            secondaryBackground: const ColoredBox(
              color: deleteButton,
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Icon(Icons.delete, color: iconOnColor),
                ),
              ),
            ),
            child:Container(
              color: backgroundColor,
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                leading: Row(mainAxisSize: MainAxisSize.min, children: [
                  IconButton(
                      onPressed: () {
                        setState(() {
                          widget.todo.changeIsDone();
                          widget.refresh();
                        });
                      },
                      icon: Icon(
                        widget.todo.getIsDone()
                            ? Icons.check_box
                            : Icons.check_box_outline_blank,
                        color: textColor,
                      )),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        widget.todo.changeIsImportant();
                        widget.refresh();
                      });
                    },
                    icon: Icon(
                      widget.todo.getIsImportant() ? Icons.star : Icons.star_outline,
                      color: starButton,
                    ),
                  )
                ]),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:[
                    Text(
                      overflow: TextOverflow.ellipsis,
                      widget.todo.getTitle() ?? "",
                      style: TextStyle(
                        fontSize: 16,
                        color: textColor,
                        fontWeight: FontWeight.bold,
                        decoration:
                            widget.todo.getIsDone() ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    if (widget.todo.getDateTime() != null)
                      Text(
                        widget.todo.getDate(),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: textColor,
                          decoration: widget.todo.getIsDone() ? TextDecoration.lineThrough : null,
                        ),
                      ),
                  ]
                ),
                trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                  IconButton(
                    onPressed: () async {
                      if(await askForDelete()) {
                        TodoList().remove(widget.todo);
                        widget.refresh();
                      }
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: deleteButton,
                    )
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
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

  String weatherAnimation(String? condition){
    if(condition == null) return 'assets/sunny.json';
    switch(condition.toLowerCase()){
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
      case 'clouds':
        return 'assets/clouds.json';
      case 'drizzle':
      case 'shower rain':
      case 'rain':
        return 'assets/rain.json';
      case 'thunderstorm':
        return 'assets/thunderstorm.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }

  Widget setWidgetDetail(Weather? _weather) {
    List<Widget> widgetsList = [];
    double mapSize = min(MediaQuery.of(context).size.width * 0.5, MediaQuery.of(context).size.height * 0.5);

    if (widget.todo.getDescription() != "") {
      widgetsList.add(
        RichText(
          text: TextSpan(
            children: [
              const TextSpan(
                text: 'Description: ',
                style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
              ),
              TextSpan(
                text: widget.todo.getDescription(),
                style: const TextStyle(color: textColor),
              ),
            ],
          ),
        ),
      );
    }
    if (widget.todo.getDate() != ""){
      widgetsList.add(
        RichText(
          text: TextSpan(
            children: [
              const TextSpan(
                text: 'Date d\'échéance: ',
                style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
              ),
              TextSpan(
                text: widget.todo.getDate(),
                style: const TextStyle(color: textColor),
              ),
            ],
          ),
        ),
      );
    }
    if(widget.todo.getCity() != ""){
      widgetsList.add(
        RichText(
          text: TextSpan(
            children: [
              const TextSpan(
                text: 'Ville: ',
                style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
              ),
              TextSpan(
                text: widget.todo.getCity(),
                style: const TextStyle(color: textColor),
              ),
            ],
          ),
        ),
      );
    }
    if(_weather != null){
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
                Positioned(
                  bottom: 5,
                  right: 5,
                  child: FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => WidgetMap(weather: _weather, title: widget.todo.getTitle(),)),
                      );
                    },
                    mini: true,
                    child: Icon(Icons.fullscreen),
                  ),
                ),
              ])
            ),
            SizedBox(
              height: 80,
              width: 80,
              child: Lottie.asset(
                weatherAnimation(_weather?.condition),
              ),
            ),
            Text("Actuel: ${_weather?.temp ?? 0}°C",
              softWrap: true,
              style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
            ),
            Text("Min: ${_weather?.minTemp ?? 0}°C | Max: ${_weather?.maxTemp ?? 0}°C",
              softWrap: true,
              style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
            )
          ]
          )
        ),
      );
    }

    if(widgetsList.isEmpty){
      return const Text("Vous n'avez pas encore édité cette activité. \n"
          "Une fois cela fait, vous aurez toutes les informations renseignées qui apparaîtront ici.");
    }
    else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widgetsList,
      );
    }
  }

  Future todoDetail() async{
    Weather? _weather;
    try {
      final weather = await widget.todo.getWeather();
      setState(() {
        _weather = weather;
      });
    }
    catch(e){
      print(e);
    }
    return showDialog(
      context: context,
      builder: (context) {
        return
          AlertDialog(
            title: Row(
              children: [
                Expanded(
                  child: Text(widget.todo.getTitle()),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => WidgetEditTodo(todo: widget.todo, refresh: affichage)),
                    );
                  },
                ),
              ],
            ),
            content: SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              height: MediaQuery.of(context).size.height * 0.7,
              child:SingleChildScrollView(child:setWidgetDetail(_weather)),
            )
        );
      },
    );
  }

  void affichage() {
    setState(() {
      widget.todo;
    });
  }
}
