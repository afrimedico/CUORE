
class OtcData {
  OtcData(
      {this.key,
      this.name,
      this.code,
      this.price,
      this.base,
      this.preuse,
      this.preadd,
      this.useall,
      this.addall});

  // 薬名
  String key;
  // 薬名
  String name;
  // コード
  String code = '';
  // 単価
  int price = 0;
  // 前回記録した個数
  int base = 0;
  // 前回使用した個数
  int preuse = 0;
  // 前回追加した個数
  int preadd = 0;
  // 使用した個数
  int useall = 0;
  // 追加した個数
  int addall = 0;
  // 今回チェックした個数
  int count = 0;
  // 今回追加した個数
  int add = 0;
}
