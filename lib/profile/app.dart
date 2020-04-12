import 'dart:convert';
import 'package:cuore/sl/prefs.dart';
import 'package:uuid/uuid.dart';

class App {
  static Future<dynamic> getSettings(String name) async {
    String jsonStr = await SLPrefsService.getString(name);
    if (jsonStr.length == 0) {
      var app = Map<String, dynamic>();
      await setApp(app);
      return app;
    } else {
      return json.decode(jsonStr);
    }
  }

  static Future setSettings(String name, app) async {
    await SLPrefsService.setString(name, json.encode(app));
    print(json.encode(app));
  }

  static Future<dynamic> getApp() async {
    String jsonStr = await SLPrefsService.getString("app");
    if (jsonStr.length > 0) {
      var app = json.decode(jsonStr);
      if (app.length > 0) {
        print(jsonStr);
        return json.decode(jsonStr);
      }
    }

    int now = DateTime.now().toUtc().millisecondsSinceEpoch;
    // 初回の起動
    var app = Map<String, dynamic>();
    // 起動回数
    app.putIfAbsent("boot", () => 0);
    // UUID
    app.putIfAbsent("uuid", () => Uuid().v4() + '-' + now.toString());
    // オンボード
    app.putIfAbsent("wlcm", () => true);

    await setApp(app);
    return app;
  }

  static Future setApp(app) async {
    setSettings("app", app);
  }

  static Future<dynamic> getProfile() async {
    return getSettings("usr");
  }

  static Future setProfile(app) async {
    setSettings("usr", app);
  }

  static Future<dynamic> getMdb() async {
    return getSettings("mdb");
  }

  static Future setMdb(app) async {
    setSettings("mdb", app);
  }
}