import 'dart:async';
import 'dart:io';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:ghala/repository/otc.dart';
import 'package:ghala/screen/components/parts.dart';
import 'package:ghala/screen/home.dart';
import 'package:ghala/screen/otc.dart';
import 'package:ghala/screen/ringup.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

/// Show Otc list which customer has.
class OtcListScreen2 extends StatefulWidget {
  OtcListScreen2({this.customer});

  CustomerData customer;

  @override
  OtcListState2 createState() => new OtcListState2(customer: this.customer);
}

class OtcListState2 extends State<OtcListScreen2>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  List<OtcData> _otcList;
  CustomerData customer;

  OtcListState2({this.customer});

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, initialIndex: 0, length: 2);

    reload();
  }

  void reload() async {
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
      appBar: appBar(),
      body: body(),
      floatingActionButton: buildBottomNavigationBar(context, _handleDone),
    );
  }

  Widget buildBottomNavigationBar(context, run) {
    return Column(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            heroTag: 'scan',
            backgroundColor: Colors.blueAccent,
            onPressed: () {
              run();
            },
            child: Icon(
              Icons.monetization_on,
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

  Widget appBar() {
    return new AppBar(
      title: new GestureDetector(
        onTap: () {
          // reload();
        },
        child: Text(customer.name + ' (Add)'),
      ),
      elevation: 0.7,
    );
  }

  Widget body() {
    if (loading) {
      return Text("Processing...");
    }
    if (_otcList == null) {
      _otcList = List<OtcData>();
    }
    return new Column(children: <Widget>[
      new Flexible(
        child: new ListView.builder(
          physics: BouncingScrollPhysics(),
          reverse: false,
          itemCount: _otcList.length,
          itemBuilder: (context, i) => _buildCustomerItem(i),
        ),
      ),
      new Divider(height: 1.0),
      // Parts().buildBottomButton(context, barcodeScanning),
      Parts().buildBottomButton3(context, _handleCamera)
    ]);
  }

  bool loading = false;

  _handleCamera() async {
    setState(() {
      loading = true;
    });
    // 撮影/選択したFileが返ってくる
    var imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
    // Androidで撮影せずに閉じた場合はnullになる
    if (imageFile != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => new RingupScreen(customer: customer)));
    }
    setState(() {
      loading = false;
    });
  }

  _handleDone() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => new RingupScreen(customer: customer)));
  }

  _onBack() {
    Navigator.pop(context, false);
  }

  _add(otc) {
    otc.add++;
    reload();
  }

  _remove(otc) {
    if (otc.add > 0) {
      otc.add--;
      reload();
    }
  }

  Widget _buildCustomerItem(int i) {
    var otc = _otcList[i];
    return Padding(
      padding: new EdgeInsets.all(4.0),
      child: new Container(
        decoration: new BoxDecoration(
            color: (otc.add > 0 ? Colors.greenAccent : Colors.white)),
        child: OutlineButton(
          padding:
              EdgeInsets.only(top: 0.0, right: 0.0, bottom: 0.0, left: 0.0),
          child: new Column(
            children: <Widget>[
              new ListTile(
                title: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Flexible(
                      flex: 1,
                      child: Text("+" + otc.add.toString()),
                    ),
                    new Flexible(
                      flex: 1,
                      child: CircleAvatar(
                        backgroundImage: Image.asset(
                                "assets/animals/" + otc.key + ".png",
                                height: 100)
                            .image,
                        radius: 30,
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                    new Flexible(
                      flex: 1,
                      child: new Text(
                        otc.name,
                        style: new TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20.0),
                      ),
                    ),
                    new Flexible(
                      flex: 1,
                      child: new Text(
                        (otc.count + otc.add).toString(),
                        style: new TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 28.0),
                      ),
                    ),
                    // new Text(
                    //   'add: ' + otc.add.toString(),
                    //   style: new TextStyle(color: Colors.black, fontSize: 16.0),
                    // ),
                    new Flexible(
                      flex: 1,
                      child: SizedBox(
                        width: 80, // specific value
                        height: 60,
                        child: RaisedButton.icon(
                          icon: Icon(
                            Icons.remove,
                            color: Colors.white,
                          ),
                          label: Text(
                            "1",
                            style: new TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 24.0),
                          ),
                          onPressed: () {
                            _remove(otc);
                          },
                          color: Colors.lightGreen,
                          textColor: Colors.white,
                        ),
                      ),
                    ),
                    new Flexible(
                      flex: 1,
                      child: SizedBox(
                        width: 80, // specific value
                        height: 60,
                        child: RaisedButton.icon(
                          icon: Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                          label: Text(
                            "1",
                            style: new TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 24.0),
                          ),
                          onPressed: () {
                            _add(otc);
                          },
                          color: Colors.green,
                          textColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                // subtitle: Text(otc.base.toString()),
              ),
            ],
          ),
          onPressed: () {},
        ),
      ),
    );
  }
}
