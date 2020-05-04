import 'dart:async';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:cuore/repository/otc.dart';
import 'package:cuore/screen/otclist.dart';
import 'package:cuore/profile/drawer.dart';
import 'package:cuore/profile/signin.dart';
import 'package:cuore/secret.dart';
import 'package:cuore/repository/sheet.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:sms/sms.dart';

/// Show customers list.
class HomeScreen extends StatefulWidget {
  HomeScreen();

  @override
  _WhatsAppHomeState createState() => new _WhatsAppHomeState();
}

class CustomerData {
  CustomerData({this.name});

  String name;
  List<OtcData> otcList = List<OtcData>();
  int sale;
  int debt;
  DateTime updated;
  String box;
}

class _WhatsAppHomeState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  List<CustomerData> _customerList;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, initialIndex: 0, length: 2);

    reload();
  }

  // Google sheetからデータをロード
  Future reload() async {
    print(userEmail);
    var items = await CustomerDb.loadItemFromSheets();
    var list = await CustomerDb.loadFromSheets(userEmail, items);

    setState(() {
      _customerList = list;
    });
  }

  // Google sheetへデータをセーブ
  Future save() async {
    if (_customerList != null) {
      await CustomerDb.saveAsSheets(_customerList);
      await reload();
    }
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
      drawer: AppDrawer.showDrawer(context),
      floatingActionButton: buildBottomNavigationBar(context, barcodeScanning),
    );
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

// Method for scanning barcode....
  Future barcodeScanning() async {
    setState(() {
      loading = true;
    });
    this.barcode = "";
    try {
      String barcode = await BarcodeScanner.scan();
      _setBarcode(barcode);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.message = 'No camera permission!';
        });
      } else {
        setState(() => this.message = 'Unknown error: $e');
      }
    } on FormatException {
      setState(() => this.message = 'Nothing captured.');
    } catch (e) {
      setState(() => this.message = 'Unknown error: $e');
    }
    setState(() {
      loading = false;
    });
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
          child: Text("Customers"),
        ),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.cached),
          onPressed: () {
            final snackBar = SnackBar(content: Text('Uploading...'));
            _scaffoldKey.currentState.showSnackBar(snackBar);
            save();
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
    if (_customerList == null) {
      return Text('No user data: ' + userName);
    }
    int len = _customerList != null ? _customerList.length : 0;
    return new Column(children: <Widget>[
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

  String date(customer) {
    final _formatter = DateFormat("MM/dd HH:mm");
    return _formatter.format(customer.updated.toLocal());
  }

  Widget _buildCustomerItem(int i) {
    var customer = _customerList[i];
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
      _customerList[index].box = this.barcode;
    }
    setState(() {
      this.barcode = "";
    });
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                new OtcListScreen(customer: _customerList[index])));
  }
}
