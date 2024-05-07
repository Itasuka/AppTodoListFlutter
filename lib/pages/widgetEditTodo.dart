import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:projet_todo_list/models/todoList.dart';

import '../models/colors.dart';
import '../models/todo.dart';

class WidgetEditTodo extends StatefulWidget {
  final Todo todo;
  final Function() refresh;

  const WidgetEditTodo({Key? key, required this.todo, required this.refresh}) : super(key: key);

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

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: widget.todo.title);
    _description = TextEditingController(text: widget.todo.description);
    _city = TextEditingController(text: widget.todo.address);
    _date = widget.todo.date;
  }

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _city.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Editez votre todo'),
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
                key: _formKey, // Clé unique du formulaire
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _title,
                      autofocus: false,
                      decoration: const InputDecoration(
                        labelText: 'Titre (50 caractères max)',
                        labelStyle: TextStyle(
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
                      maxLines: null,
                      decoration: const InputDecoration(
                        labelText: 'Description (500 caractères max)',
                        labelStyle: TextStyle(
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
                      decoration: InputDecoration(
                        labelText: 'Adresse',
                        errorText: _cityValidationMessage.isNotEmpty ? _cityValidationMessage : null,
                        labelStyle: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                        suffixIcon: IconButton(
                          onPressed: () async {
                            Position? position = await _getCurrentLocation();
                            if (position != null) {
                              String address = await _getAddressFromLatLng(position.latitude, position.longitude);
                              setState(() {
                                _city.text = address;
                                _cityValidationMessage = '';
                              });
                            } else {
                              _cityValidationMessage = 'Impossible de récupérer la position géographique actuelle';
                            }
                          },
                          icon: Icon(Icons.my_location),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez saisir une adresse';
                        }
                        return null;
                      },
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(100),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today),
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
                            style: const TextStyle(color: textColor),
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
                          foregroundColor: buttonColor, backgroundColor: insideButtonColor,
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            bool isAddressValid = await TodoList().checkAdressAvailability(_city.text);
                            if (!isAddressValid) {
                              setState(() {
                                _cityValidationMessage = 'Adresse non valide';
                              });
                              return;
                            }
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
                        child: const Text('Valider'),
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

  Future<Position?> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return null;
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<String> _getAddressFromLatLng(double latitude, double longitude) async {
    final response = await http.get(
      Uri.parse('https://nominatim.openstreetmap.org/reverse?lat=$latitude&lon=$longitude&format=json'),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      String address = jsonResponse['display_name'];
      return address;
    } else {
      throw Exception('Failed to load address');
    }
  }
}
