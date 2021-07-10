import 'dart:convert';
import 'dart:io';

import 'package:cuore/data/master_data.dart';
import 'package:cuore/data/value.dart';
import 'package:path_provider/path_provider.dart';

class HomeRepository {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/customer.json');
  }

  Future<File> writePlayerData(MasterData masterData) async {
    final file = await _localFile;
    return file.writeAsString(jsonEncode(masterData.toJson()));
  }

  Future<MasterData> readPlayerData() async {
    try {
      final file = await _localFile;
      String contents = await file.readAsString();
      final jsonResponse = jsonDecode(contents);
      MasterData data = MasterData.fromJson(jsonResponse);
      return data;
    } catch (e) {
      print(e);
      throw e;
    }
    // String fileText = await rootBundle.loadString('assets/file.txt');
    // print(fileText);
    // return fileText;
  }

  void addNewCustommer() async {
    var masterData = await readPlayerData();
    await writePlayerData(masterData
      ..values.add(Value(name: "tuan", pLACE: 'VIETNAM', station: 'VietNam')));
    readPlayerData().then((value) => value.values.map((e) => print(e.name)));
  }
}
