class Value {
  String name;
  int add;
  int addAll;
  int count;
  String key;
  String pLACE;
  String station;
  int use;
  int useall;
  int value;

  Value(
      {this.name = '',
      this.add = 0,
      this.addAll = 0,
      this.count = 0,
      this.key = '',
      this.pLACE = '',
      this.station = '',
      this.use = 0,
      this.useall = 0,
      this.value = 0});

  factory Value.fromJson(Map<String, dynamic> json) {
    return Value(
      name: json['NAME'],
      add: json['add'],
      addAll: json['addall'],
      count: json['count'],
      key: json['key'],
      pLACE: json['pLACE'],
      station: json['station'],
      use: json['use'],
      useall: json['useall'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['NAME'] = this.name;
    data['add'] = this.add;
    data['addall'] = this.addAll;
    data['count'] = this.count;
    data['key'] = this.key;
    data['pLACE'] = this.pLACE;
    data['station'] = this.station;
    data['use'] = this.use;
    data['useall'] = this.useall;
    data['value'] = this.value;
    return data;
  }
}
