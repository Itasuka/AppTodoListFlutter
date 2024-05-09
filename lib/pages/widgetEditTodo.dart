import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:projet_todo_list/models/todoList.dart';

import '../models/colors.dart';
import '../models/todo.dart';

///Page d'édition des tâches
class WidgetEditTodo extends StatefulWidget {
  final Todo todo;
  final Function() refresh;

  const WidgetEditTodo({super.key, required this.todo, required this.refresh});

  @override
  _WidgetEditTodoState createState() => _WidgetEditTodoState();
}

class _WidgetEditTodoState extends State<WidgetEditTodo> {
  final _formKey = GlobalKey<FormState>(); // Clé unique pour le formulaire

  late TextEditingController _title;
  late TextEditingController _description;
  late TextEditingController _city;
  late DateTime? _date;
  String _cityValidationMessage = '';

  ///Initialisation des champs avec les valeurs de la tâche
  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: widget.todo.title);
    _description = TextEditingController(text: widget.todo.description);
    _city = TextEditingController(text: widget.todo.address);
    _date = widget.todo.date;
  }

  ///Pour liberer la mémoire une fois que l'on retourne à la page d'avant
  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _city.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //mise en page de la nouvelle page pour l'édition de la tâche
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: AppColor().background(),
          appBar: AppBar(
            backgroundColor: AppColor().buttonColor(),
            title: Text('Editez votre todo', style: TextStyle(color: AppColor().iconOnColor()),),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Form(
                // Clé unique du formulaire
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  //Les différents champs de la pages
                  children: [
                    TextFormField(
                      controller: _title,
                      autofocus: false,
                      style: TextStyle(color: AppColor().textColor()),
                      decoration: InputDecoration(
                        labelText: 'Titre (50 caractères max)',
                        labelStyle: TextStyle(
                          color: AppColor().textColor(),
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez saisir un titre';
                        }
                        return null;
                      },
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(50),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _description,
                      autofocus: false,
                      style: TextStyle(color: AppColor().textColor()),
                      maxLines: null,
                      decoration: InputDecoration(
                        labelText: 'Description (500 caractères max)',
                        labelStyle: TextStyle(
                          color: AppColor().textColor(),
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(500),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _city,
                      autofocus: false,
                      style: TextStyle(color: AppColor().textColor()),
                      decoration: InputDecoration(
                        labelText: 'Adresse',
                        errorText: _cityValidationMessage.isNotEmpty ? _cityValidationMessage : null,
                        labelStyle: TextStyle(
                          color: AppColor().textColor(),
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                        //Gestion du bouton de géolocalisation
                        suffixIcon: IconButton(
                          onPressed: () async {
                            //Récupération de la latitude et longitude de l'appareil
                            Position? position = await _getCurrentLocation();
                            if (position != null) {
                              //Sonvertion de la position en adresse
                              String address = await _getAddressFromLatLng(position.latitude, position.longitude);
                              setState(() {
                                _city.text = address;
                                _cityValidationMessage = '';
                              });
                            }
                            //Si problème de géolocalisation
                            else {
                              _cityValidationMessage = 'Impossible de récupérer la position géographique actuelle';
                            }
                          },
                          icon: Icon(Icons.my_location, color: AppColor().textColor(),),
                        ),
                      ),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(100),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, color: AppColor().textColor(),),
                        const SizedBox(width: 8),
                        TextButton(
                          onPressed: () {
                            showDatePicker(
                              context: context,
                              initialDate: _date ?? DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            ).then((selectedDate) {
                              if (selectedDate != null) {
                                setState(() {
                                  _date = selectedDate;
                                });
                              }
                            });
                          },
                          child: Text(
                            _date != null ? DateFormat('dd/MM/yyyy').format(_date!) : 'Sélectionner une date',
                            style: TextStyle(color: AppColor().textColor()),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor().buttonColor(),
                        ),
                        //vérification de la validité des champs avant d'ajouter et quitter la page
                        onPressed: () async {
                          //Vérifie si tous les champs sont complétement remplis
                          if (_formKey.currentState!.validate()) {
                            bool isAddressValid = await TodoList().checkAdressAvailability(_city.text);
                            //Si l'adresse n'existe pas on retourne une erreur et on reste sur le même widget
                            if (!isAddressValid && _city.text.isNotEmpty) {
                              setState(() {
                                _cityValidationMessage = 'Adresse non valide';
                              });
                              return;
                            }
                            //sinon on upgrade la tâche
                            TodoList().update(
                                widget.todo,
                                _title.text,
                                _description.text,
                                _city.text,
                                _date,
                                widget.refresh);
                            Navigator.pop(context);
                            widget.refresh;
                          }
                        },
                        child: Text('Valider', style: TextStyle(color: AppColor().insideButtonColor()),),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
    );
  }

  /// Pour avoir la position GPS de l'appareil
  Future<Position?> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    //On regarde si on peut utiliser le gps
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null;
    }
    //Pour vérifier les permissions et si elle ne sont pas donner on demande à l'utilisateur
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return null;
      }
    }
    //Dans le cas où l'utilisateur refuse
    if (permission == LocationPermission.deniedForever) {
      return null;
    }
    return await Geolocator.getCurrentPosition();
  }

  ///Converti des coordonnées en adresse
  Future<String> _getAddressFromLatLng(double latitude, double longitude) async {
    //Demande d'existance ou non de la position
    final response = await http.get(
      Uri.parse('https://nominatim.openstreetmap.org/reverse?lat=$latitude&lon=$longitude&format=json'),
    );
    //si on trouve une adresse on la retourne
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      String address = jsonResponse['display_name'];
      return address;
    }
    //sinon on retourne une erreur
    else {
      throw Exception('Impossible de trouver une adresse');
    }
  }
}
