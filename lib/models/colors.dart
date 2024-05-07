import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Palette de couleur de l'application
class AppColor {
  static final AppColor _instance = AppColor.internal();
  late SharedPreferences prefs;
  late ValueNotifier<bool> _themeNotifier;
  bool _darkmode = true;

  factory AppColor() {
    return _instance;
  }

  AppColor.internal() {
    init();
  }

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
    _darkmode = prefs.getBool('darkmode') ?? true;
    _themeNotifier = ValueNotifier<bool>(_darkmode);
  }

  Future<void> setTheme(bool val) async {
    _darkmode = val;
    await prefs.setBool('darkmode', _darkmode);
    _themeNotifier.value = _darkmode; // Notifie les écouteurs du changement de thème
  }

  bool getTheme() {
    return _darkmode;
  }

  ValueNotifier<bool> get themeNotifier => _themeNotifier;

  Color textColor(){return _darkmode ? Colors.white : Colors.black;}
  Color textTodo(){return Colors.black;}
  Color backgroundColor(){return const Color.fromARGB(255, 245, 245, 245);}
  Color backgroundColorCheck(){return const Color.fromARGB(255, 204, 204, 204);}
  Color buttonColor(){return _darkmode ? Colors.orange : Colors.blue;}
  Color insideButtonColor(){return _darkmode ? Colors.black : Colors.white;}
  Color iconOnColor(){return _darkmode ? Colors.black : Colors.white;}
  Color separator(){return _darkmode ? const Color.fromARGB(255, 200, 200, 200) : const Color.fromARGB(255, 200, 200, 200);}
  Color separatorDone(){return _darkmode ? Colors.grey : Colors.grey;}
  Color starButton(){return Colors.orange;}
  Color deleteButton(){return const Color.fromARGB(255, 156, 24, 15);}
  Color background() {return _darkmode ? Colors.black : Colors.white;}
}
