import 'package:cuore/repository/otc.dart';
import 'package:cuore/screen/home.dart';
import 'package:cuore/sl/googlesheets.dart';

/// ユーザーリストを保持する
/// このリストを選択して、ユーザーごとに配置している薬リストを表示する。
class CustomerDb {
  static var sheetId = "sheetId";
  static Map<String, dynamic>? sheet = Map<String, dynamic>();

  // 購入記録をセーブする
  static Future<void> saveAsSheets(List<CustomerData?> list) async {
    var data = <Map<String, dynamic>>[];
    for (var row in list) {
      data.add({
        "PLACE": row!.place,
        "CLIENT NAME": row.name,
        "station": row.station,
        "Key": 'updated',
        "Value": row.updated.toUtc().toIso8601String()
      });
      data.add(
          {"PLACE": "", "CLIENT NAME": "", "Key": 'sale', "Value": row.sale});
      data.add(
          {"PLACE": "", "CLIENT NAME": "", "Key": 'debt', "Value": row.debt});
      data.add(
          {"PLACE": "", "CLIENT NAME": "", "Key": 'box', "Value": row.box});
      for (var otc in row.otcList!) {
        data.add({
          "PLACE": "",
          "CLIENT NAME": "",
          "Key": otc.code,
          "Value": otc.price,
          "Count": otc.base,
          "Use": otc.preuse,
          "Add": otc.preadd,
          "Useall": otc.useall,
          "addall": otc.addall
        });
      }
    }
    sheet = Map<String, dynamic>();
    sheet!.putIfAbsent("values", () => data);
    await Sheets.save(sheetId, sheet, 'customers');
  }

  // 購入記録をロードする
  static Future<List<CustomerData>?> loadFromSheets(
      String staffname, Map<String?, ItemData> items, bool fromServer) async {
    var range = staffname + '!A1:I1000';
    sheet = await Sheets.load(sheetId, range, 'customers', fromServer);
    if (sheet == null) {
      return null;
    }

    List<CustomerData> result = <CustomerData>[];
    CustomerData? user;
    for (var row in sheet!.values.last) {
      var place = row['PLACE'];
      var client = row['CLIENT NAME'];
      var station = row['station'];
      var key = row['Key'];
      var value = row['Value'];
      if (client.length > 0) {
        if (user != null) {
          result.add(user);
        }
        user = CustomerData(place: place, name: client, station: station);
      }
      if (key == 'updated') {
        user!.updated = DateTime.parse(value);
      } else if (key == 'sale') {
        user!.sale = value;
      } else if (key == 'debt') {
        user!.debt = value;
      } else if (key == 'box') {
        user!.box = value.toString();
      } else {
        var count = row['Count'];
        var use = row['Use'];
        var add = row['Add'];
        var useall = row['Useall'];
        var addall = row['addall'];
        var item = items[key]!;
        var otc = OtcData(
            key: item.key,
            name: item.name,
            code: item.code,
            price: item.price ?? 0,
            base: count,
            preuse: use,
            preadd: add,
            useall: useall,
            addall: addall);
        user!.otcList!.add(otc);
      }
    }
    result.add(user!);
    return result;
  }

  // アイテムリストをロードする
  static Future<Map<String?, ItemData>> loadItemFromSheets(
      bool fromServer) async {
    var range = 'item!A1:I1000';
    sheet = await Sheets.load(sheetId, range, 'items', fromServer);

    Map<String?, ItemData> result = Map<String?, ItemData>();
    int n = 0;
    for (var row in sheet!.values.last) {
      n++;
      if (n == 1) {
        continue;
      }
      var i = 0;
      try {
        var key = row[i++];
        var name = row[i++];
        var code = row[i++];
        var price = row[i++];
        var item = ItemData(
          key: key,
          name: name,
          code: code,
          price: int.parse(price),
        );
        result.putIfAbsent(code, () => item);
      } catch (e) {
        print(e);
        continue;
      }
    }
    return result;
  }
}

class ItemData {
  ItemData({
    this.key = '',
    this.name = '',
    this.code = '',
    this.price = 0,
  });

  // 薬名
  String key;
  // 薬名
  String name;
  // 識別コード
  String code;
  // 単価
  int? price = 0;
}

class Station {
  final int id;
  final String name;

  Station({this.id = -1, this.name = 'error'});
}
