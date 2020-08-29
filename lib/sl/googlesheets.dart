import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';

import 'package:cuore/secret.dart';
import 'package:googleapis/sheets/v4.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:path_provider/path_provider.dart';

class Sheets {
  static Future<Map<String, dynamic>> load(
      sheetId, range, String name, bool fromServer) async {
    final file = await getFilePath(name);
    if (await file.exists()) {
      var result = await file.readAsString();
      if (result != null && result.length > 0) {
        print("ファイルからロード");
        print(file.uri);
        print(json.decode(result));
        return json.decode(result);
      }
    }

    print("Assetからロード");
    var result = await rootBundle.loadString("assets/data/" + name + ".json");
    if (result != null && result.length > 0) {
      print(json.decode(result));
      return json.decode(result);
    }

    // print("GSheetからロードしてセーブ");

    // final _credentials =
    //     new ServiceAccountCredentials.fromJson(Secret.serviceAccountKey);
    // const _SCOPES = const [SheetsApi.SpreadsheetsScope];

    // var client = await clientViaServiceAccount(_credentials, _SCOPES);
    // var api = new SheetsApi(client);

    // try {
    //   var sheet = await api.spreadsheets.values.get(sheetId, range);
    //   var data = sheet.toJson();

    //   getFilePath(name).then((File file) {
    //     file.writeAsString(json.encode(data));
    //   });

    //   print(data);
    //   return data;
    // } catch (e) {
    //   return null;
    // }
  }

  static Future<void> save(sheetId, sheet, name) async {
    print("ファイルへセーブ");
    // var data = json.encode(mapdata);
    getFilePath(name).then((File file) {
      print(file.uri);
      print(json.encode(sheet));
      file.writeAsString(json.encode(sheet));
    });
    // final _credentials =
    //     new ServiceAccountCredentials.fromJson(Secret.serviceAccountKey);
    // const _SCOPES = const [SheetsApi.SpreadsheetsScope];

    // var client = await clientViaServiceAccount(_credentials, _SCOPES);
    // var api = new SheetsApi(client);

    // ValueRange request = ValueRange.fromJson(json);
    // var res = await api.spreadsheets.values.update(
    //     request, sheetId, request.range,
    //     valueInputOption: 'USER_ENTERED');
    // print(res);
  }

  static Future<File> getFilePath(sheetId) async {
    // print((await getTemporaryDirectory()).path);
    // print((await getApplicationDocumentsDirectory()).path);
    // print((await getApplicationSupportDirectory()).path);
    // // print((await getLibraryDirectory()).path); // iOS
    // print((await getExternalStorageDirectory()).path);

    final _fileName = sheetId + '.json';
    final directory = await getExternalStorageDirectory();
    var testdir =
        await new Directory('${directory.path}').create(recursive: true);
    // final directory = await getExternalStorageDirectory();
    // print(directory.path + '/' + _fileName);
    return File(testdir.path + '/' + _fileName);
  }
}
