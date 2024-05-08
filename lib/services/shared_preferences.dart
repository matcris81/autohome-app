import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class PreferencesService {
  Future<void> saveString(String dataName, String data) async {
    print('data: $data');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(dataName, data);
  }

  Future<String?> getString(String dataName) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(dataName);
  }

  Future<void> clearString(String dataName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(dataName);
  }

  Future<void> saveList(List<int> list, String dataName) async {
    final prefs = await SharedPreferences.getInstance();
    String updatedJson = json.encode(list);
    await prefs.setString(dataName, updatedJson);
  }

  Future<void> saveIntToList(int gameID, String dataName) async {
    final prefs = await SharedPreferences.getInstance();

    String? jsonString = prefs.getString(dataName);

    List<int> intList;
    if (jsonString != null) {
      intList = List<int>.from(json.decode(jsonString));
      print('intList: $intList');
    } else {
      intList = [];
    }

    intList.add(gameID);

    String updatedJson = json.encode(intList);

    await prefs.setString(dataName, updatedJson);
  }

  Future<List<int>> getIntList(String dataName) async {
    final prefs = await SharedPreferences.getInstance();

    String? jsonString = prefs.getString(dataName);

    List<int> intList;
    if (jsonString != null) {
      intList = List<int>.from(json.decode(jsonString));
      return intList;
    } else {
      return [];
    }
  }
}
