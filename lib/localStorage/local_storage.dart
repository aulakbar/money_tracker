import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveValueString(String key, String value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(key, value);
}

Future<void> saveValueInt(String key, int value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt(key, value);
}

Future<void> saveValueBool(String key, bool value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool(key, value);
}

Future<String?> getValueString(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(key);
}

Future<int?> getValueInt(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getInt(key);
}

getValueBool(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var value = prefs.getBool(key);
  if(value == null) return false;
  return value;
}

Future<void> deleteValue(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove(key);
}

void clearUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Remove user data from SharedPreferences
    await prefs.clear();
  }