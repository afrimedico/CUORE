
import 'package:shared_preferences/shared_preferences.dart';

class SLPrefsService {
  static Future<int> getInt(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return (prefs.getInt(name) ?? 0);
  }

  static setInt(String name, int v) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(name, v);
  }

  static Future<String> getString(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return (prefs.getString(name) ?? "");
  }

  static setString(String name, String v) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(name, v);
  }
}