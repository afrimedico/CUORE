import 'dart:async';
import 'dart:collection';

import 'package:cuore/profile/app.dart';
import 'package:cuore/repository/otc.dart';
import 'package:cuore/repository/sheet.dart';
import 'package:cuore/screen/add_customer.dart';
import 'package:cuore/screen/otclist.dart';
import 'package:cuore/sl/googlesheets.dart';
import 'package:cuore/sl/helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Show customers list.
class HomeScreen extends StatefulWidget {
  HomeScreen();

  @override
  _WhatsAppHomeState createState() => new _WhatsAppHomeState();
}

class CustomerData {
  CustomerData({this.place, this.name, this.station});

  String? place;
  String? name;
  String? station;
  List<OtcData>? otcList = <OtcData>[];
  int sale = 0;
  int debt = 0;
  DateTime updated = DateTime.now();
  String? box;

  void log() {
    // print(name);
    // print(sale);
    // print(debt);
    // print(updated);
    // print(box);
    print('DuongTuan: $place $station');
  }
}

class _WhatsAppHomeState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  List<CustomerData> _customerList = [];
  List<String>? _failedMessages;

  TextEditingController _textEditingController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, initialIndex: 0, length: 2);

    reload();
  }

  // Google sheetからデータをロード
  Future reload() async {
    // プロファイル設定
    var user = await App.getProfile();
    if (user['name'] != null) {
      userName = user['name'];
    }
    _textEditingController.text = userName!;

    var items = await CustomerDb.loadItemFromSheets(false);
    var list = await CustomerDb.loadFromSheets(userName!, items, false);

    await reloadFailedMessage();

    setState(() {
      _customerList = list!;
      _searchedList = list;
    });
  }

  // Google sheetへデータをセーブ
  Future save() async {
    if (_customerList != null) {
      await CustomerDb.saveAsSheets(_customerList);
      await reload();
    }
  }

  Future reloadFailedMessage() async {
    final prefs = await SharedPreferences.getInstance();

    var failedMessages = prefs.getStringList('failedMessages');

    setState(() {
      _failedMessages = failedMessages;
    });
  }

  ///
  Future reloadAndSave() async {
    Sheets.clear('items');
    Sheets.clear('customers');
    var items = await CustomerDb.loadItemFromSheets(true);
    var list = await (CustomerDb.loadFromSheets(userName!, items, true)
        as FutureOr<List<CustomerData?>>);
    await CustomerDb.saveAsSheets(list);
  }

  void callback(String event) {
    save();
  }

  @override
  Widget build(BuildContext context) {
    return screen();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Widget screen() {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: appBar() as PreferredSizeWidget?,
      body: body(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AddNewCustomer(_customerList),
          ));
        },
        label:  Text(
          AppLocalizations.of(context)!.add,
          style: TextStyle(color: Colors.white),
        ),
        icon: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.greenAccent,
      ),
      drawer: showDrawer(context),
      // floatingActionButton: buildBottomNavigationBar(context, barcodeScanning),
    );
  }

  String? userName = "";
  String userNameTmp = "";

  Drawer showDrawer(context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _createHeader(context),
          TextField(
            controller: _textEditingController,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.user_name,
              hintText: AppLocalizations.of(context)!.user_name,
              icon: Icon(Icons.account_circle),
            ),
            autocorrect: false,
            autofocus: false,
            keyboardType: TextInputType.text,
          ),
          RaisedButton(
            child: Text(AppLocalizations.of(context)!.save),
            color: Colors.orange,
            textColor: Colors.white,
            onPressed: () async {
              setState(() {
                userName = _textEditingController.text;
              });
              var user = await App.getProfile();
              int now = DateTime.now().toUtc().millisecondsSinceEpoch;
              user['name'] = _textEditingController.text;
              user['ts'] = now;
              await App.setProfile(user);
            },
          ),
          // _createDrawerItem(
          //     context, Icons.person, SLMessage.of("Profile"), () => _handleProfile(context)),
          // _createDrawerItem(
          //     context,
          //     Icons.info,
          //     SLMessage.of("Version"),
          //     () => showAboutDialog(
          //           context: context,
          //           applicationIcon: Image.asset(
          //             'assets/icons/ic_launcher.png',
          //             width: 64,
          //           ),
          //           applicationName: "CUORE",
          //           applicationVersion: "Test version",
          //         )),
          Divider(),
          _showFailedMessages()
          // _createSignOutItem(context),
        ],
      ),
    );
  }

  _showFailedMessages() {
    if (_failedMessages != null && _failedMessages!.length > 0) {
      return Container(
          margin: EdgeInsets.all(10),
          height: 320,
          child: Column(
            children: [
              Text(
                AppLocalizations.of(context)!.failed_messages,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  reverse: false,
                  itemCount: _failedMessages!.length,
                  itemBuilder: (context, i) => _buildFailedMessageItem(i),
                ),
              )
            ],
          ));
    } else {
      return SizedBox();
    }
  }

  Widget _buildFailedMessageItem(int i) {
    var message = _failedMessages![i];

    return Card(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(children: [
          Text(message),
          OutlineButton(
              child: Text(AppLocalizations.of(context)!.resend),
              onPressed: () async {
                int result =
                    await (HelperFunction().sendSms(message));

                var isNetworkConnected =
                    await HelperFunction().checkDeviceNetwork();

                if (result != 200 || !isNetworkConnected) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => new CupertinoAlertDialog(
                      title: Text(AppLocalizations.of(context)!.resend_error),
                      content:
                          Text(AppLocalizations.of(context)!.resend_again),
                      actions: [
                        CupertinoDialogAction(
                          isDefaultAction: true,
                          child: Text(AppLocalizations.of(context)!.ok),
                          onPressed: () async {
                            Navigator.of(context).pop(false);
                          },
                        ),
                        CupertinoDialogAction(
                          child: Text(AppLocalizations.of(context)!.resend_by_sms),
                          onPressed: () async {
                            var address = "+1 619 357 4294";
                            // sendSms(address, text);
                            List<String> addresses = [address];

                            _sendSMS(message, addresses);
                          },
                        )
                      ],
                    ),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => new CupertinoAlertDialog(
                      title: Text(AppLocalizations.of(context)!.message_sent),
                      actions: [
                        CupertinoDialogAction(
                          isDefaultAction: true,
                          child: Text(AppLocalizations.of(context)!.ok),
                          onPressed: () async {
                            Navigator.of(context).pop(false);
                          },
                        )
                      ],
                    ),
                  );

                  dynamic updatedFailedMessages = _failedMessages!.where((e) {
                    return e != message;
                  }).toList();

                  final prefs = await SharedPreferences.getInstance();

                  prefs.setStringList('failedMessages', updatedFailedMessages);

                  setState(() {
                    _failedMessages = updatedFailedMessages;
                  });
                }
              })
        ]),
      ),
    );
  }

  void _sendSMS(String message, List<String> recipents) async {
    String _result = await sendSMS(message: message, recipients: recipents)
        .catchError((onError) {
      print(onError);
    });
    print(_result);
  }

  Widget _createHeader(context) {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(top: 20),
        child: Center(
          child: InkWell(
            onTap: () => _handleProfile(context),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // CircleAvatar(
                //   backgroundImage: NetworkImage(
                //     userImageUrl,
                //   ),
                //   radius: 30,
                //   backgroundColor: Colors.transparent,
                // ),
                Text(
                  userName!,
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.bold),
                ),
                // SizedBox(height: 10),
                // Text(
                //   userEmail,
                //   style: TextStyle(
                //       fontSize: 16,
                //       color: Colors.deepPurple,
                //       fontWeight: FontWeight.bold),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _createDrawerItem(context, icon, text, onTap) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(
            icon,
          ),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(text),
          )
        ],
      ),
      onTap: onTap,
    );
  }

  Widget _createSignOutItem(context) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(
            Icons.exit_to_app,
          ),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text("Sign Out"),
          )
        ],
      ),
      onTap: () {
        // Navigator.of(context).pushAndRemoveUntil(
        //     MaterialPageRoute(builder: (context) {
        //   return LoginPage();
        // }), ModalRoute.withName('/'));
      },
    );
  }

  void _handleProfile(context) {
    // Navigator.push(context,
    //     MaterialPageRoute(builder: (BuildContext context) => UserScreen()));
  }

  Widget buildBottomNavigationBar(context, run) {
    return Column(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            heroTag: 'scan',
            backgroundColor: Colors.pink,
            onPressed: () {
              run();
            },
            child: Icon(
              Icons.camera_alt,
              color: Colors.white,
            ),
          ),
        ],
      ),
      // SizedBox(
      //   height: 50.0,
      // ),
    ]);
  }

  // Scanned barcode data.
  String barcode = "";
  String message = "";
  List<CustomerData>? _searchedList = [];

// Method for scanning barcode....
  Future barcodeScanning() async {
    //   setState(() {
    //     loading = true;
    //   });
    //   this.barcode = "";
    //   try {
    //     String barcode = await BarcodeScanner.scan();
    //     _setBarcode(barcode);
    //   } on PlatformException catch (e) {
    //     if (e.code == BarcodeScanner.CameraAccessDenied) {
    //       setState(() {
    //         this.message = 'No camera permission!';
    //       });
    //     } else {
    //       setState(() => this.message = 'Unknown error: $e');
    //     }
    //   } on FormatException {
    //     setState(() => this.message = 'Nothing captured.');
    //   } catch (e) {
    //     setState(() => this.message = 'Unknown error: $e');
    //   }
    //   setState(() {
    //     loading = false;
    //   });
  }

  _setBarcode(barcode) {
    setState(() => this.barcode = barcode);
    if (_customerList != null) {
      for (int i = 0; i < _customerList.length; i++) {
        var customer = _customerList[i];
        if (customer.box == barcode) {
          _onTap(i);
        }
      }
    }
  }

  Widget appBar() {
    return new AppBar(
      title: new GestureDetector(
        onTap: () {},
        child: Center(
          child: Text(userName!),
        ),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.cached),
          onPressed: () {
            final snackBar = SnackBar(content: Text(AppLocalizations.of(context)!.reloading));
            _scaffoldKey.currentState!.showSnackBar(snackBar);
            reloadAndSave();
          },
        ),
      ],
      elevation: 0.7,
    );
  }

  Widget body() {
    if (loading) {
      return Text(AppLocalizations.of(context)!.processing);
    }
    if (_searchedList == null) {
      return Text('No user data: ' + userName!);
    }
    int len = _searchedList != null ? _searchedList!.length : 0;
    return new Column(children: <Widget>[
      _inputLine(),
      Text(barcode),
      new Flexible(
        child: new ListView.builder(
          physics: BouncingScrollPhysics(),
          reverse: false,
          itemCount: len,
          itemBuilder: (context, i) => _buildCustomerItem(i),
        ),
      ),
    ]);
  }

  final TextEditingController _mainInputController =
      new TextEditingController();

  String? _selectedVillage;
  String? _selectedStation;
  String? _searchText;

  Widget _inputLine() {
    if (_customerList.length <= 0) {
      return Text(AppLocalizations.of(context)!.processing);
    }

    List<String> _customerVillages = [];
    List<String> _customerStation = [];

    _customerVillages = LinkedHashSet<String>.from(_customerList
        .where((element) => (element.place?.isNotEmpty ?? false))
        .map((e) => e.place)
        .toList()).toList();

    _customerStation = LinkedHashSet<String>.from(_customerList
        .where((element) => (element.station?.isNotEmpty ?? false))
        .map((e) => e.station?.toUpperCase())
        .toList()).toList();

    _customerVillages.forEach((element) {print(element);});

    return (Column(
      children: [
        Padding(
            padding: new EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: TextField(
              decoration: InputDecoration(hintText: AppLocalizations.of(context)!.search),
              controller: _mainInputController,
              onChanged: _handleMainInputChanged,
            )),
        Padding(
            padding: new EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Row(
              children: [
                Text(
                  AppLocalizations.of(context)!.village,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  width: 20,
                ),
                GestureDetector(
                  // behavior: HitTestBehavior.opaque,
                  child: DropdownButton<String>(
                    icon: Icon(Icons.filter_alt_rounded),
                    elevation: 10,
                    hint: Text(_selectedVillage != null
                        ? _selectedVillage!
                        : AppLocalizations.of(context)!.choose_an_option),
                    items: [
                      DropdownMenuItem<String>(
                        value: 'ALL',
                        child: new Text(AppLocalizations.of(context)!.all_villages),
                      ),
                      ...(_customerVillages.map((village) {
                        return new DropdownMenuItem<String>(
                          value: village,
                          child: new Text(village),
                        );
                      }).toList())
                    ],
                    onChanged: _handleVillageChanged,
                  ),
                ),
              ],
            )),
        Padding(
            padding: new EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Row(
              children: [
                Text(
                  AppLocalizations.of(context)!.station,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  width: 20,
                ),
                GestureDetector(
                  // behavior: HitTestBehavior.opaque,
                  child: DropdownButton<String>(
                    icon: Icon(Icons.filter_alt_rounded),
                    elevation: 10,
                    hint: Text(_selectedStation != null
                        ? _selectedStation!
                        : AppLocalizations.of(context)!.choose_an_option),
                    items: [
                      DropdownMenuItem<String>(
                        value: 'ALL',
                        child: new Text(AppLocalizations.of(context)!.all_stations),
                      ),
                      ...(_customerStation.map((village) {
                        return new DropdownMenuItem<String>(
                          value: village,
                          child: new Text(village),
                        );
                      }).toList())
                    ],
                    onChanged: _handleStationChange,
                  ),
                ),
              ],
            ))
      ],
    ));
  }

  void _handleMainInputChanged(String text) async {
    // _mainInputController.text = text;
    List<CustomerData> searchedList = [];

    for (int i = 0; i < _customerList.length; i++) {
      var customer = _customerList[i];
      if (customer.name!.toLowerCase().indexOf(text.toLowerCase()) != -1) {
        searchedList.add(customer);
      }
    }
    if (text.length == 0 && searchedList.length == 0) {
      searchedList = _customerList;
    }
    setState(() {
      _searchedList = searchedList;
      _searchText = text;
    });
  }

  String date(CustomerData customer) {
    final _formatter = DateFormat("MM/dd HH:mm");
    return _formatter.format(customer.updated.toLocal());
  }

  Widget _buildCustomerItem(int i) {
    var customer = _searchedList![i];
    // print("customer");
    // customer.log();
    return Padding(
      padding: new EdgeInsets.all(4.0),
      child: new Container(
        decoration: new BoxDecoration(color: Colors.yellowAccent),
        child: OutlineButton(
          onPressed: () {
            _onTap(i);
          },
          padding:
              EdgeInsets.only(top: 4.0, right: 4.0, bottom: 0.0, left: 4.0),
          child: new Column(
            children: <Widget>[
              new ListTile(
                title: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Text(
                      customer.name ?? '',
                      style: new TextStyle(fontWeight: FontWeight.bold),
                    ),
                    new Text(
                      customer.debt.toString(),
                      style: new TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red[300],
                      ),
                    ),
                    new Text(
                      date(customer),
                      style: new TextStyle(color: Colors.grey, fontSize: 14.0),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool loading = false;

  void _onTap(int index) async {
    if (this.barcode.length > 0) {
      _searchedList![index].box = this.barcode;
    }
    setState(() {
      this.barcode = "";
    });
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => new OtcListScreen(
                customer: _searchedList![index], callback: callback)));
  }

  void _handleStationChange(String? value) {
    setState(() {
      _selectedStation = value ?? 'ALL';
      _searchedList =
          filterList(_selectedVillage ?? 'ALL', _selectedStation ?? 'ALL');
      print('DuongTuan: $_searchedList');
    });
    _searchedList?.forEach((element) {
      element.log();
    });
  }

  List<CustomerData> filterList(String village, String station) {
    if (village.toUpperCase() == 'ALL' && station.toUpperCase() == 'ALL') {
      return _customerList;
    }

    if (village.toUpperCase() == 'ALL' && station.toUpperCase() != 'ALL') {
      return _customerList
          .where(
              (element) => element.station?.toUpperCase() == _selectedStation)
          .toList();
    }

    if (village.toUpperCase() != 'ALL' && station.toUpperCase() == 'ALL') {
      return _customerList
          .where((element) => element.place?.toUpperCase() == _selectedVillage)
          .toList();
    }

    if (village.toUpperCase() != 'ALL' && station.toUpperCase() != 'ALL') {
      return _customerList
          .where((element) =>
              element.place?.toUpperCase() == _selectedVillage &&
              element.station?.toUpperCase() == _selectedStation)
          .toList();
    }
    return [];
  }

  void _handleVillageChanged(String? village) async {
    setState(() {
      _selectedVillage = village ?? 'ALL';
      _searchedList =
          filterList(_selectedVillage ?? 'ALL', _selectedStation ?? 'ALL');
      _searchedList?.forEach((element) {
        element.log();
      });
    });
  }
}
