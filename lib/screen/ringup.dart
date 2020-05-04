import 'package:cuore/profile/app.dart';
import 'package:flutter/material.dart';
import 'package:cuore/repository/otc.dart';
import 'package:cuore/screen/home.dart';
import 'package:cuore/screen/otclist.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:sms/sms.dart';

/// Show Ring up.
class RingupScreen extends StatefulWidget {
  RingupScreen({this.customer});

  CustomerData customer;

  @override
  _RingupState createState() => new _RingupState(customer: this.customer);
}

class _RingupState extends State<RingupScreen>
    with SingleTickerProviderStateMixin {
  CustomerData customer;
  List<OtcData> _otcList;

  _RingupState({this.customer});

  @override
  void initState() {
    super.initState();
    setState(() {
      _otcList = customer.otcList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return screen();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Widget screen() {
    return new Scaffold(
      key: _scaffoldKey,
      body: body(),
    );
  }

  Widget appBar() {
    return new AppBar(
      title: new GestureDetector(
        onTap: () {},
        child: Text(customer.name),
      ),
      elevation: 0.7,
    );
  }

  Widget body() {
    return new Column(children: <Widget>[
      SizedBox(height: 50),
      new Text(
        "Details",
        style: new TextStyle(color: Colors.black, fontSize: 16.0),
      ),
      new Flexible(
        child: new ListView.builder(
          physics: BouncingScrollPhysics(),
          reverse: false,
          itemCount: _otcList.length,
          itemBuilder: (context, i) => _buildCustomerItem(i),
        ),
      ),
      new Divider(height: 1.0),
      _result(),
      _buildBottomButton2()
    ]);
  }

  Widget _buildCustomerItem(int i) {
    var otc = _otcList[i];
    return Padding(
      padding: new EdgeInsets.all(4.0),
      child: OutlineButton(
        padding: EdgeInsets.only(top: 4.0, right: 4.0, bottom: 0.0, left: 4.0),
        child: new Column(
          children: <Widget>[
            new ListTile(
              title: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Text(
                    otc.name,
                    style: new TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16.0),
                  ),
                  new Text(
                    otc.price.toString(),
                    style: new TextStyle(color: Colors.pink, fontSize: 16.0),
                  ),
                  new Text(
                    'use: ' +
                        (otc.base - otc.count).toString() +
                        (otc.count == 0 ? ' (count 0)' : ''),
                    style: new TextStyle(color: Colors.black, fontSize: 16.0),
                  ),
                ],
              ),
            ),
          ],
        ),
        onPressed: () {},
      ),
    );
  }

  Widget _result() {
    return new Column(children: <Widget>[
      _buildBottomNavigationBar(),
    ]);
  }

  Widget label(String label) {
    return Text(label, style: TextStyle(color: Colors.black, fontSize: 20.0));
  }

  Widget labelColor(String label, Color color) {
    return Text(label, style: TextStyle(color: color, fontSize: 20.0));
  }

  Widget getChip(String label, Color color) {
    return Chip(
        label: Text(label, style: TextStyle(color: color, fontSize: 20.0)),
        backgroundColor: Colors.white,
        shape: OutlineInputBorder(
          borderSide: BorderSide(width: 1.0, color: Colors.grey),
          borderRadius: new BorderRadius.circular(25.0),
        ));
  }

  // 利用額
  int use = 0;

  // 集金額
  int collection = -1;

  // 価格
  _buildBottomNavigationBar() {
    // 利用額
    use = 0;
    int sum = 0;
    for (var otc in _otcList) {
      sum += otc.count;
      var n = otc.base - otc.count;
      if (n > 0) {
        use += n * otc.price;
      }
    }
    // 未入力なら
    if (sum == 0) {
      use = 0;
    }

    // 負債額
    int debt = customer.debt;

    // 請求額
    int claim = use + debt;

    // 次回請求額
    int next = claim - (collection >= 0 ? collection : 0);

    return Container(
        width: MediaQuery.of(context).size.width,
        // height: 85.0,
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                ),
                label('Usage'),
                Padding(
                  padding: EdgeInsets.all(8.0),
                ),
                labelColor(
                    use > 0 ? use.toString() : "         ", Colors.red[300]),
                Padding(
                  padding: EdgeInsets.all(8.0),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                ),
                label('Accounts payable'),
                Padding(
                  padding: EdgeInsets.all(8.0),
                ),
                labelColor(debt.toString(), Colors.red[300]),
                Padding(
                  padding: EdgeInsets.all(8.0),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                ),
                label('Billing'),
                Padding(
                  padding: EdgeInsets.all(8.0),
                ),
                labelColor(claim.toString(), Colors.red[300]),
                Padding(
                  padding: EdgeInsets.all(8.0),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                ),
                label('Collection'),
                Padding(
                  padding: EdgeInsets.all(8.0),
                ),
                _buildTextComposer(),
                Padding(
                  padding: EdgeInsets.all(8.0),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                ),
                label('Remaining'),
                Padding(
                  padding: EdgeInsets.all(8.0),
                ),
                labelColor(next.toString(), Colors.red[300]),
                Padding(
                  padding: EdgeInsets.all(8.0),
                ),
              ],
            ),
          ],
        ));
  }

  final TextEditingController _textController = new TextEditingController();

  // 自由入力フィールド
  Widget _buildTextComposer() {
    return Flexible(
      child: Padding(
        padding: EdgeInsets.all(4.0),
        child: OutlineButton(
          borderSide: BorderSide(width: 1.0, color: Colors.grey),
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(10.0)),
          padding: new EdgeInsets.all(10.0),
          child: new TextField(
            keyboardType: TextInputType.number,
            controller: _textController,
            onChanged: (String t) {
              if (t.length > 0) {
                _handleSubmitted(t);
              }
            },
            onSubmitted: _handleSubmitted,
            decoration: new InputDecoration.collapsed(hintText: ""),
          ),
          onPressed: () async {},
        ),
      ),
    );
  }

  // 送信したテキストでシナリオを実行する
  void _handleSubmitted(String text) {
    // _textController.clear();
    collection = int.parse(text);
  }

  _buildBottomButton2() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50.0,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Flexible(
            fit: FlexFit.tight,
            flex: 1,
            child: RaisedButton(
              onPressed: () async {
                Navigator.pop(context, false);
              },
              color: Colors.grey,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 4.0,
                    ),
                    Text(
                      "Back",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Flexible(
            fit: FlexFit.tight,
            flex: 2,
            child: RaisedButton(
              onPressed: () async {
                if (collection >= 0) {
                  await _handleDone();
                }
              },
              color: (collection >= 0) ? Colors.blue : Colors.white,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 4.0,
                    ),
                    Text(
                      (collection >= 0) ? "Ring up" : "(Input collection)",
                      style: TextStyle(
                        color: (collection >= 0) ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future _handleDone() async {
    // baseがあるのにcountが0ならcaution
    var caution = false;
    var count = false;
    for (var otc in _otcList) {
      if (otc.count > 0 || otc.add > 0) {
        count = true;
      } else if (otc.base > 0) {
        caution = true;
      }
    }

    if (count) {
      // 0にするケースもあるかもしれない
      // if (caution) {
      //   final snackBar = SnackBar(
      //       content: Text('There are some items that are not counted.'));
      //   _scaffoldKey.currentState.showSnackBar(snackBar);
      //   return;
      // }

      // 在庫数
      for (var i = 0; i < _otcList.length; i++) {
        _otcList[i].preuse = _otcList[i].base - _otcList[i].count;
        _otcList[i].preadd = _otcList[i].add;
        _otcList[i].useall += _otcList[i].preuse;
        _otcList[i].addall += _otcList[i].preadd;
        _otcList[i].base = _otcList[i].count + _otcList[i].add;
        _otcList[i].count = 0;
        _otcList[i].add = 0;
      }
      customer.otcList = _otcList;
    }

    // 請求額
    int claim = use + customer.debt;

    // 売上
    collection = (collection >= 0 ? collection : 0);
    customer.sale += collection;

    // 次回請求額
    customer.debt = claim - collection;

    // 更新日時
    customer.updated = DateTime.now().toUtc();

    var text = await getSmsText(customer, _otcList, collection);
    print(text);

    collection = 0;

    // SMS送信
    // TODO: この情報はDBに保存しておいて、SMS送信失敗時にリトライできるようにする
    var address = "+1 717 727-2636";
    sendSms(address, text);

    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  void sendSms(String address, String text) {
    SmsSender sender = new SmsSender();
    SmsMessage message = new SmsMessage(address, text);
    message.onStateChanged.listen((state) {
      if (state == SmsMessageState.Sent) {
        print("SMS is sent!");
      } else if (state == SmsMessageState.Delivered) {
        print("SMS is delivered!");
      }
    });
    sender.sendSms(message);
  }

  Future<String> getSmsText(customer, _otcList, collection) async {
    // 送信者
    var user = await App.getProfile();
    var text = '@' + user['name'] + ',';
    // 顧客名
    text += 'N' + customer.name + ',';
    // 日付
    text += 'T' + date(customer) + ',';
    // 今回徴収額
    text += 'M' + collection.toString() + ',';
    // 負債
    text += 'D' + customer.debt.toString() + ',';
    for (var i = 0; i < _otcList.length; i++) {
      if (_otcList[i].preuse > 0 || _otcList[i].preadd > 0) {
        // 薬ID
        text += 'K' + _otcList[i].code + ',';
        // 今回使った個数
        text += 'U' + _otcList[i].preuse.toString() + ',';
        // 今回追加した個数
        text += 'A' + _otcList[i].preadd.toString() + ',';
      }
    }
    return text;
  }

  String date(customer) {
    final _formatter = DateFormat("MM/dd HH:mm");
    return _formatter.format(customer.updated.toLocal());
  }
}
