import 'package:cuore/data/value.dart';

class MasterData {
  String majorDimension;
  String range;
  List<Value> values;

  MasterData(
      {required this.majorDimension,
      required this.range,
      required this.values});

  factory MasterData.fromJson(Map<String, dynamic> json) {
    return MasterData(
      majorDimension: json['majorDimension'],
      range: json['range'],
      values: json['values'] != null
          ? (json['values'] as List).map((i) => Value.fromJson(i)).toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['majorDimension'] = this.majorDimension;
    data['range'] = this.range;
    if (this.values != null) {
      data['values'] = this.values.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
