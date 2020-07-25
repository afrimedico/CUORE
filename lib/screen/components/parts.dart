import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cuore/repository/otc.dart';
import 'package:cuore/screen/otclist.dart';
import 'package:cuore/screen/ringup.dart';

class Parts {
  static final Parts _instance = Parts._internal();

  Parts._internal();

  factory Parts() {
    return _instance;
  }

  buildBottomButton(context, onScan) {
    return Padding(
      padding: new EdgeInsets.all(10.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 100.0,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Flexible(
              fit: FlexFit.tight,
              flex: 2,
              child: RaisedButton(
                onPressed: onScan,
                color: Colors.blue,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.camera,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 4.0,
                      ),
                      Text(
                        "Scan",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget newResultItem(OtcData otc) {
    return Padding(
        padding: new EdgeInsets.all(4.0),
        child: OutlineButton(
          padding:
              EdgeInsets.only(top: 4.0, right: 4.0, bottom: 0.0, left: 4.0),
          child: Column(
            children: [
              ListTile(
                leading: Container(
                  child: _loadImage(''),
                ),
                title: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        otc.name,
                        // overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20.0),
                      ),
                      Text(
                        otc.price.toString(),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.red[300],
                            fontWeight: FontWeight.w700,
                            fontSize: 20.0),
                      ),
                    ],
                  ),
                ),
              ),
              // _buildButton1(otc),
              // _buildButton2(otc),
            ],
          ),
          onPressed: () async {
            // _openDetail(context, otc);
          },
        ));
  }

  Widget _loadImage(String name) {
    return Image.asset("assets/mdb/noimage.png", height: 100);
  }

  Widget _label(String label) {
    return Text(label, style: TextStyle(color: Colors.black, fontSize: 20.0));
  }

  Widget _labelColor(String label, Color color) {
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

  buildBottomButton2(context, onDone, onBack, back) {
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
              onPressed: onBack,
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
                      back,
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
              onPressed: onDone,
              color: Colors.pink,
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
                      "Collect monery",
                      style: TextStyle(color: Colors.white),
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

  buildBottomButton3(context, onDone, stage) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50.0,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Flexible(
            fit: FlexFit.tight,
            flex: 2,
            child: RaisedButton(
              onPressed: onDone,
              color: Colors.pink,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 4.0,
                    ),
                    Text(
                      stage == 0 ? "Add" : "Collect",
                      style: TextStyle(color: Colors.white),
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

  final TextEditingController textController1 = new TextEditingController();

  // 送信したテキストでシナリオを実行する
  void handleSubmitted1(otc, String text) {
    otc.count = int.parse(text);
  }

  final TextEditingController textController2 = new TextEditingController();

  // 送信したテキストでシナリオを実行する
  void handleSubmitted2(otc, String text) {
    otc.add = int.parse(text);
  }

  Widget renderIconButton(icon, onPressed) {
    return Ink(
      decoration: const BoxDecoration(
        color: Colors.green,
      ),
      child: IconButton(
        icon: Icon(icon),
        color: Colors.white,
        onPressed: onPressed,
      ),
    );
  }
}
