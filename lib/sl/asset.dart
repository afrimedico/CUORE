import 'package:csv/csv_settings_autodetection.dart';
import 'package:flutter/services.dart';
import 'package:csv/csv.dart';

class SLAssetService {
  static Future<List<List<dynamic>>> loadCsv(String filename) async {
    var s = await rootBundle.loadString(filename);
    var d = new FirstOccurrenceSettingsDetector(
        eols: ['\r\n', '\n'], textDelimiters: ['"']);
    List<List<dynamic>> result =
        CsvToListConverter(csvSettingsDetector: d).convert(s);
    return result;
  }
}
