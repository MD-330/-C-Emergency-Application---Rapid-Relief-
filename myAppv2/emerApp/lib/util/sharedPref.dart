import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SharedPref {

  saveList(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
    //prefs.l;
  }
  read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return json.decode(prefs.getString(key)!);
  }
  save(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(value));
    //prefs.l;
  }



  remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }
//  checkFoundKey1(String key) async {
//    final prefs = await SharedPreferences.getInstance();
//    return json.decode(prefs.containsKey(key).toString());
//    //return prefs.containsKey(key);
//    //prefs.l;
//  }
//
//  Future<bool> checkFoundKey(String key) async {
//    final prefs = await SharedPreferences.getInstance();
//    return prefs.containsKey(key);
//  }
  checkFound(String key) async {
    final prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey(key))
    return true;
    else
      return false;
  }
}
