import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  LocalStorage();

  Future getStorage(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.get(name);
  }

  Future setJsonStorage(String name, Map<String, dynamic> value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(name, jsonEncode(value));
    return value;
  }

  Future setStringStorage(String name, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(name, value);
    return value;
  }

  Future setBoolStorage(String name, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(name, value);
    return value;
  }

  Future setIntStorage(String name, int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(name, value);
    return value;
  }

  Future setDoubleStorage(String name, double value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(name, value);
    return value;
  }
}
