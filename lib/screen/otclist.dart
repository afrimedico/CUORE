import 'package:cuore/repository/otc.dart';
import 'package:cuore/screen/components/parts.dart';
import 'package:cuore/screen/home.dart';
import 'package:cuore/screen/otclist2.dart';
import 'package:cuore/screen/ringup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Show Otc list which customer has.
class OtcListScreen extends StatefulWidget {
  OtcListScreen({this.customer, this.callback});
  Function(String)? callback;

  CustomerData? customer;

  @override
  OtcListState createState() => new OtcListState(customer: this.customer);
}

class OtcListState extends State<OtcListScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  List<OtcData>? _otcList;
  CustomerData? customer;

  OtcListState({this.customer});

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, initialIndex: 0, length: 2);

    reload();
  }

  void reload() async {
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
      appBar: appBar() as PreferredSizeWidget?,
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
        child: Text(customer!.name! + ' (Count)'),
      ),
      elevation: 0.7,
    );
  }

  Widget body() {
    if (loading) {
      return Text("Processing...");
    }
    if (_otcList == null) {
      _otcList = <OtcData>[];
    }
    return new Column(children: <Widget>[
      new Flexible(
        child: new ListView.builder(
          physics: BouncingScrollPhysics(),
          reverse: false,
          itemCount: _otcList!.length,
          itemBuilder: (context, i) => _buildCustomerItem(i),
        ),
      ),
      new Divider(height: 1.0),
      // Parts().buildBottomButton(context, barcodeScanning),
      Parts().buildBottomButton3(context, _handleCamera, 0)
    ]);
  }

  bool loading = false;
  bool useCamera = false;

  _handleCamera() async {
    setState(() {
      loading = true;
    });
    if (useCamera) {
      // // 撮影/選択したFileが返ってくる
      // var imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
      // // Androidで撮影せずに閉じた場合はnullになる
      // if (imageFile != null) {
      //   Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //           builder: (context) => new OtcListScreen2(
      //               customer: customer, callback: widget.callback)));
      // }
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => new OtcListScreen2(
                  customer: customer, callback: widget.callback)));
    }
    setState(() {
      loading = false;
    });
  }

  _handleDone() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => new RingupScreen(
                  customer: customer,
                  callback: widget.callback,
                  status: 1,
                )));
  }

  _onBack() {
    Navigator.pop(context, false);
  }

  _add(otc) {
    otc.count++;
    reload();
  }

  _remove(otc) {
    if (otc.count > 0) {
      otc.count--;
      reload();
    }
  }

  Widget _buildCustomerItem(int i) {
    var otc = _otcList![i];
    return Padding(
      padding: new EdgeInsets.all(4.0),
      child: new Container(
        decoration: new BoxDecoration(
            color: (otc.base > 0 && otc.count == 0
                ? Colors.orangeAccent
                : otc.count > otc.base
                    ? Colors.lightBlueAccent
                    : Colors.white)),
        child: OutlineButton(
          padding: EdgeInsets.only(top: 5, right: 0.0, bottom: 5, left: 0.0),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new ListTile(
                title: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Flexible(
                      flex: 1,
                      child: new Text(
                        otc.name,
                        style: new TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.0),
                      ),
                    ),
                  ],
                ),
                leading: SizedBox(
                  width: 75,
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        (i + 1).toString(),
                        textAlign: TextAlign.left,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      CircleAvatar(
                        backgroundImage: Image.asset(
                                "assets/animals/" + otc.key + ".png",
                                height: 100)
                            .image,
                        radius: 25,
                        backgroundColor: Colors.transparent,
                      ),
                    ],
                  ),
                ),
                subtitle: Container(
                  margin: EdgeInsets.only(top: 5, bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(otc.base.toString() + "→"),
                          Text(
                            otc.count.toString(),
                            style: new TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 28.0),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 50,
                            child: CupertinoButton(
                              child: Text('-'),
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              borderRadius: BorderRadius.zero,
                              minSize: 0,
                              color: Colors.pinkAccent,
                              onPressed: () => _remove(otc),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            width: 50,
                            child: CupertinoButton(
                              child: Text('+'),
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              borderRadius: BorderRadius.zero,
                              minSize: 0,
                              color: Colors.pinkAccent,
                              onPressed: () => _add(otc),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
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
