import 'package:cuore/secret.dart';
import 'package:googleapis/sheets/v4.dart';
import 'package:googleapis_auth/auth_io.dart';

class Sheets {
  static Future<Map<String, dynamic>> load(sheetId, range) async {
    final _credentials =
        new ServiceAccountCredentials.fromJson(Secret.serviceAccountKey);
    const _SCOPES = const [SheetsApi.SpreadsheetsScope];

    var client = await clientViaServiceAccount(_credentials, _SCOPES);
    var api = new SheetsApi(client);

    try {
      var sheet = await api.spreadsheets.values.get(sheetId, range);
      var json = sheet.toJson();
      return json;
    } catch (e) {
      return null;
    }
  }

  static Future<void> save(sheetId, json) async {
    final _credentials =
        new ServiceAccountCredentials.fromJson(Secret.serviceAccountKey);
    const _SCOPES = const [SheetsApi.SpreadsheetsScope];

    var client = await clientViaServiceAccount(_credentials, _SCOPES);
    var api = new SheetsApi(client);

    ValueRange request = ValueRange.fromJson(json);
    var res = await api.spreadsheets.values.update(
        request, sheetId, request.range,
        valueInputOption: 'USER_ENTERED');
    print(res);
  }
}
