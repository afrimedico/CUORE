import 'package:cuore/profile/app.dart';
import 'package:cuore/repository/otc.dart';
import 'package:cuore/screen/home.dart';
import 'package:cuore/sl/helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Show Ring up.
class RingupScreen extends StatefulWidget {
  RingupScreen({this.customer, this.callback, this.status});

  Function(String)? callback;

  int? status;

  CustomerData? customer;

  @override
  _RingupState createState() =>
      new _RingupState(customer: this.customer, status: this.status);
}

class _RingupState extends State<RingupScreen>
    with SingleTickerProviderStateMixin {
  CustomerData? customer;

  int? status;

  List<OtcData>? _otcList;

  bool _isButtonTapped = false;

  DateTime selectedVisitedDate = DateTime.now();

  _RingupState({this.customer, this.status});

  @override
  void initState() {
    super.initState();
    setState(() {
      _otcList = customer!.otcList;
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
      body: SafeArea(child: body()),
    );
  }

  Widget appBar() {
    return new AppBar(
      title: new GestureDetector(
        onTap: () {},
        child: Text(customer!.name!),
      ),
      elevation: 0.7,
    );
  }

  Widget body() {
    return new Column(children: <Widget>[
      Text(
        AppLocalizations.of(context)!.details,
        style: new TextStyle(color: Colors.black, fontSize: 16.0),
      ),
      Expanded(
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          reverse: false,
          itemCount: _otcList?.length ?? 0,
          itemBuilder: (context, i) => _buildCustomerItem(i),
        ),
      ),
      Divider(height: 1.0),
      _visitDate(),
      Divider(height: 1.0),
      _result(),
      _buildBottomButton2()
    ]);
  }

  Widget _buildCustomerItem(int i) {
    var otc = _otcList![i];
    if (otc.base - otc.count == 0) {
      return Container();
    }
    return Padding(
      padding: new EdgeInsets.all(4.0),
      child: OutlineButton(
        padding: EdgeInsets.only(top: 4.0, right: 4.0, bottom: 0.0, left: 4.0),
        child: new Column(
          children: <Widget>[
            new ListTile(
              title: new Text(
                otc.name,
                style:
                    new TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
              ),
              trailing: new Wrap(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Text(
                    otc.price.toString(),
                    style: new TextStyle(color: Colors.pink, fontSize: 16.0),
                  ),
                  new Text(
                    AppLocalizations.of(context)!.ringup_use +
                        (otc.base - otc.count).toString(),
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

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedVisitedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedVisitedDate)
      setState(() {
        selectedVisitedDate = picked;
      });
  }

  Widget _visitDate() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          SizedBox(width: 5, height: 10),
          Text(
            AppLocalizations.of(context)!.visit_date,
            style: new TextStyle(fontSize: 16.0),
          ),
          SizedBox(
            width: 40,
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.all(Radius.circular(5.0) //
                  ),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 5,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("${selectedVisitedDate.toLocal()}".split(' ')[0],
                      style: new TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold)),
                ),
                SizedBox(
                  width: 5,
                ),
                CupertinoButton(
                  child: Icon(Icons.date_range),
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  borderRadius: BorderRadius.zero,
                  minSize: 0,
                  color: Colors.green,
                  onPressed: () => _selectDate(context),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget label(String label) {
    return Text(label, style: TextStyle(color: Colors.black, fontSize: 20.0));
  }

  Widget labelColor(String label, Color? color) {
    return Text(label, style: TextStyle(color: color, fontSize: 20.0));
  }

  Widget getChip(String label, Color color) {
    return Chip(
      label: Text(label, style: TextStyle(color: color, fontSize: 20.0)),
      backgroundColor: Colors.white,
      // shape: OutlineInputBorder(
      //   borderSide: BorderSide(width: 1.0, color: Colors.grey),
      //   borderRadius: new BorderRadius.circular(25.0),
      // ),
    );
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
    for (var otc in _otcList!) {
      sum += otc.count;

      var n = otc.base - otc.count;

      if (n > 0) {
        use += n * otc.price;
      }
    }

    // User go to checkout page directly
    if (status == 1) {
      use = 0;
    }

    // // 未入力なら
    // if (sum == 0) {
    //   use = 0;
    // }

    // 負債額
    int debt = customer!.debt;

    // 請求額
    int claim = use + debt;

    // 次回請求額
    int next = claim - (collection != -1 ? collection : 0);

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
                label(AppLocalizations.of(context)!.accounts_payable),
                Padding(
                  padding: EdgeInsets.all(8.0),
                ),
                labelColor(claim.toString(), Colors.red[300]),
                Padding(
                  padding: EdgeInsets.all(8.0),
                ),
              ],
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   crossAxisAlignment: CrossAxisAlignment.center,
            //   children: <Widget>[
            //     Padding(
            //       padding: EdgeInsets.all(8.0),
            //     ),
            //     label('Billing'),
            //     Padding(
            //       padding: EdgeInsets.all(8.0),
            //     ),
            //     labelColor(claim.toString(), Colors.red[300]),
            //     Padding(
            //       padding: EdgeInsets.all(8.0),
            //     ),
            //   ],
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                ),
                label(AppLocalizations.of(context)!.collection),
                Padding(
                  padding: EdgeInsets.all(8.0),
                ),
                _buildTextComposer(),
                Padding(
                  padding: EdgeInsets.all(8.0),
                ),
              ],
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   crossAxisAlignment: CrossAxisAlignment.center,
            //   children: <Widget>[
            //     Padding(
            //       padding: EdgeInsets.all(8.0),
            //     ),
            //     label('Remaining'),
            //     Padding(
            //       padding: EdgeInsets.all(8.0),
            //     ),
            //     labelColor(next.toString(), Colors.red[300]),
            //     Padding(
            //       padding: EdgeInsets.all(8.0),
            //     ),
            //   ],
            // ),
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

  _showConfirmCustomerDialog() {
    var _originalContext = context;

    showDialog(
        context: context,
        builder: (BuildContext dialogContext) => new CupertinoAlertDialog(
              title: new Text(customer!.name!),
              actions: [
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text(AppLocalizations.of(context)!.send),
                  onPressed: () async {
                    if(_isButtonTapped == true){
                      return;
                    }

                    _isButtonTapped = true;

                    bool isHandled = await _handleDone(dialogContext);

                    if (isHandled) {

                      Navigator.of(dialogContext).maybePop();

                      _isButtonTapped = false;
                    }
                  },
                ),
                CupertinoDialogAction(
                  child: Text(AppLocalizations.of(context)!.cancel),
                  onPressed: () {
                    _isButtonTapped = false;
                    Navigator.of(context).maybePop();
                    Navigator.pushAndRemoveUntil(
                        _originalContext,
                        MaterialPageRoute(
                            builder: (BuildContext context) => HomeScreen()),
                        (Route<dynamic> route) => false);
                  },
                )
              ],
            ),
        barrierDismissible: false);
  }

  void _sendSMS(String message, List<String> recipents) async {
    String _result = await sendSMS(message: message, recipients: recipents)
        .catchError((onError) {
      print(onError);
    });
    print(_result);
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
                      AppLocalizations.of(context)!.back,
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
              onPressed: () {
                if (collection != -1 && _isButtonTapped == false) {
                  return _showConfirmCustomerDialog();
                }
              },
              color: (collection != -1) ? Colors.blue : Colors.white,
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
                      (collection != -1)
                          ? AppLocalizations.of(context)!.ring_up
                          : AppLocalizations.of(context)!.input_collection,
                      style: TextStyle(
                        color: (collection != -1) ? Colors.white : Colors.black,
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

  Future _handleDone(context) async {
    var user = await App.getProfile();

    if (user['name'] == null) {
      await showDialog(
          context: context,
          builder: (BuildContext dialogContent) => new CupertinoAlertDialog(
            title: Text("You must fill name before do this action"),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text(AppLocalizations.of(context)!.ok),
                onPressed: () {
                  Navigator.of(dialogContent).maybePop();

                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => HomeScreen()),
                          (Route<dynamic> route) => false);
                },
              )
            ],
          ),
          barrierDismissible: false);
      return true;
    }

    // baseがあるのにcountが0ならcaution
    var caution = false;
    var count = false;
    for (var otc in _otcList!) {
      if (otc.count > 0 || otc.add > 0) {
        count = true;
      } else if (otc.base > 0) {
        caution = true;
      }
    }

    if (status != 1) {
      for (var i = 0; i < _otcList!.length; i++) {
        _otcList![i].preuse = _otcList![i].base - _otcList![i].count;
        _otcList![i].preadd = _otcList![i].add;
        _otcList![i].useall += _otcList![i].preuse;
        _otcList![i].addall += _otcList![i].preadd;
        _otcList![i].base = _otcList![i].count + _otcList![i].add;
        _otcList![i].count = 0;
        _otcList![i].add = 0;
      }
      customer!.otcList = _otcList;
    }

    // print(customer!.otcList.toString());

    // 請求額
    int claim = use + customer!.debt;

    // 売上
    collection = (collection);

    customer!.sale += collection;

    // 次回請求額
    customer!.debt = claim - collection;

    // 更新日時
    customer!.updated = selectedVisitedDate.toLocal();

    // セーブ
    widget.callback!("save");

    var text = await getSmsText(customer, _otcList, collection);

    collection = 0;

    // SMS送信
    // TODO: この情報はDBに保存しておいて、SMS送信失敗時にリトライできるようにする
    return _sendMessage(text);
  }

  List<String> _sent = [];

  Future<bool> _sendMessage(String text) async {
    final prefs = await SharedPreferences.getInstance();

    List<String> failedMessages = prefs.getStringList('failedMessages') != null
        ? prefs.getStringList('failedMessages')!
        : [];

    failedMessages.add(text);

    var isNetworkConnected = await HelperFunction().checkDeviceNetwork();

    var _originalContext = context;

    int result = await (HelperFunction().sendSms(text));

    if (result != 200 || !isNetworkConnected) {
      prefs.setStringList('failedMessages', failedMessages);

      widget.callback!('reloadFailedMessage');

      await showDialog(
          context: context,
          builder: (BuildContext context) => new CupertinoAlertDialog(
                title: Text(AppLocalizations.of(context)!.resend_error),
                content: Text(AppLocalizations.of(context)!.resend_again),
                actions: [
                  CupertinoDialogAction(
                    isDefaultAction: true,
                    child: Text(AppLocalizations.of(context)!.ok),
                    onPressed: () {
                      Navigator.of(context).maybePop();
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => HomeScreen()),
                              (Route<dynamic> route) => false);

                    },
                  )
                ],
              ),
          barrierDismissible: false);
    } else {
      failedMessages.remove(text);

      prefs.setStringList('failedMessages', failedMessages);

      _sent.add(text);

      widget.callback!('reloadFailedMessage');

      await showDialog(
        context: context,
        builder: (BuildContext context) => new CupertinoAlertDialog(
          title: Text(AppLocalizations.of(context)!.message_sent),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text(AppLocalizations.of(context)!.ok),
              onPressed: () async {
                Navigator.of(context).maybePop();
                Navigator.pushAndRemoveUntil(
                    _originalContext,
                    MaterialPageRoute(builder: (BuildContext context) => HomeScreen()),
                        (Route<dynamic> route) => false);
              },
            )
          ],
        ),
      );
    }

    return true;
  }

  void sendSms(String address, String text) {
    // SmsSender sender = new SmsSender();
    // SmsMessage message = new SmsMessage(address, text);
    // message.onStateChanged.listen((state) {
    //   if (state == SmsMessageState.Sent) {
    //     print("SMS is sent!");
    //   } else if (state == SmsMessageState.Delivered) {
    //     print("SMS is delivered!");
    //   } else if (state == SmsMessageState.Fail) {
    //     print("SMS is Fail!");
    //   } else if (state == SmsMessageState.None) {
    //     print("SMS is None!");
    //   } else if (state == SmsMessageState.Sending) {
    //     print("SMS is Sending!");
    //   } else {
    //     // unknown
    //     print("SMS is unknown!");
    //   }
    // });
    // sender.sendSms(message);
  }

  Future<String> getSmsText(customer, _otcList, collection) async {
    // 送信者
    var user = await App.getProfile();

    String? name = '';

    if (user != null && user['name'] != null) {
      name = user['name'];
    }

    // 送信者
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
      // 薬ID
      text += 'K' + _otcList[i].code + ',';
      // 今回チェックした個数
      text += 'U' + _otcList[i].preuse.toString() + ',';
      // 今回追加した個数
      text += 'A' + _otcList[i].preadd.toString() + ',';
    }

    return text;
  }

  String date(customer) {
    final _formatter = DateFormat("yy/MM/dd HH:mm");
    return _formatter.format(customer.updated.toLocal());
  }
}
