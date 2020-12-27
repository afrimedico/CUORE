import 'dart:async';
// import 'package:barcode_scan/barcode_scan.dart';
import 'package:cuore/sl/googlesheets.dart';
import 'package:cuore/profile/app.dart';
import 'package:cuore/sl/message.dart';
import 'package:flutter/material.dart';
import 'package:cuore/repository/otc.dart';
import 'package:cuore/screen/otclist.dart';
import 'package:cuore/repository/sheet.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

/// Show customers list.
class HomeScreen extends StatefulWidget {
  HomeScreen();

  @override
  _WhatsAppHomeState createState() => new _WhatsAppHomeState();
}

class CustomerData {
  CustomerData({this.place, this.name});

  String place;
  String name;
  List<OtcData> otcList = List<OtcData>();
  int sale;
  int debt;
  DateTime updated;
  String box;

  void log() {
    print(name);
    print(sale);
    print(debt);
    print(updated);
    print(box);
  }
}

class _WhatsAppHomeState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  List<CustomerData> _customerList;

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
    _textEditingController.text = userName;

    var items = await CustomerDb.loadItemFromSheets(false);
    var list = await CustomerDb.loadFromSheets(userName, items, false);

    setState(() {
      _customerList = list;
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

  ///
  Future reloadAndSave() async {
    Sheets.clear('items');
    Sheets.clear('customers');
    var items = await CustomerDb.loadItemFromSheets(true);
    var list = await CustomerDb.loadFromSheets(userName, items, true);
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
      appBar: appBar(),
      body: body(),
      drawer: showDrawer(context),
      // floatingActionButton: buildBottomNavigationBar(context, barcodeScanning),
    );
  }

  String userName = "";
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
              labelText: 'Username',
              hintText: 'Username',
              icon: Icon(Icons.account_circle),
            ),
            autocorrect: false,
            autofocus: true,
            keyboardType: TextInputType.text,
          ),
          RaisedButton(
            child: const Text('Save'),
            color: Colors.orange,
            textColor: Colors.white,
            onPressed: () async {
              setState(() {
                userName = _textEditingController.text;
              });
              var user = await App.getProfile();
              user.update('name', (val) => _textEditingController.text);
              int now = DateTime.now().toUtc().millisecondsSinceEpoch;
              user.update("ts", (val) => now);
              await App.setProfile(user);
            },
          ),
          // _createDrawerItem(
          //     context, Icons.person, SLMessage.of("Profile"), () => _handleProfile(context)),
          _createDrawerItem(
              context,
              Icons.info,
              SLMessage.of("Version"),
              () => showAboutDialog(
                    context: context,
                    applicationIcon: Image.asset(
                      'assets/icons/ic_launcher.png',
                      width: 64,
                    ),
                    applicationName: "CUORE",
                    applicationVersion: "Test version",
                  )),
          Divider(),
          // _createSignOutItem(context),
        ],
      ),
    );
  }

  Widget _createHeader(context) {
    return DrawerHeader(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
      ),
      child: Center(
        child: InkWell(
          onTap: () => _handleProfile(context),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              SizedBox(height: 10),
              // CircleAvatar(
              //   backgroundImage: NetworkImage(
              //     userImageUrl,
              //   ),
              //   radius: 30,
              //   backgroundColor: Colors.transparent,
              // ),
              SizedBox(height: 10),
              Text(
                userName,
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
  var _searchedList = [];

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
          child: Text(userName),
        ),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.cached),
          onPressed: () {
            final snackBar = SnackBar(content: Text('Reloading...'));
            _scaffoldKey.currentState.showSnackBar(snackBar);
            reloadAndSave();
          },
        ),
      ],
      elevation: 0.7,
    );
  }

  Widget body() {
    if (loading) {
      return Text("Processing...");
    }
    if (_searchedList == null) {
      return Text('No user data: ' + userName);
    }
    int len = _searchedList != null ? _searchedList.length : 0;
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

  Widget _inputLine() {
    return (Padding(
        padding: new EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: TextField(
          decoration: InputDecoration(hintText: 'Search'),
          controller: _mainInputController,
          onChanged: _handleMainInputChanged,
        )));
  }

  void _handleMainInputChanged(String text) async {
    // _mainInputController.text = text;
    var searchedList = [];
    for (int i = 0; i < _customerList.length; i++) {
      var customer = _customerList[i];
      if (customer.name.toLowerCase().indexOf(text.toLowerCase()) != -1) {
        searchedList.add(customer);
      }
    }
    if (text.length == 0 && searchedList.length == 0) {
      searchedList = _customerList;
    }
    setState(() {
      _searchedList = searchedList;
    });
  }

  String date(customer) {
    final _formatter = DateFormat("MM/dd HH:mm");
    return _formatter.format(customer.updated.toLocal());
  }

  Widget _buildCustomerItem(int i) {
    var customer = _searchedList[i];
    print("customer");
    customer.log();
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
                      customer.name,
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
      _searchedList[index].box = this.barcode;
    }
    setState(() {
      this.barcode = "";
    });
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => new OtcListScreen(
                customer: _searchedList[index], callback: callback)));
  }
}
