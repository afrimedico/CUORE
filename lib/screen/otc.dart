import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ghala/repository/otc.dart';
import 'package:ghala/screen/components/parts.dart';
import 'package:ghala/screen/otclist.dart';
import 'package:ghala/screen/ringup.dart';

/// Show Otc count.
class OtcScreen extends StatefulWidget {
  OtcScreen({this.state, this.otc});

  OtcListState state;
  OtcData otc;

  @override
  _OtcState createState() => new _OtcState(state: this.state, otc: this.otc);
}

class _OtcState extends State<OtcScreen> with SingleTickerProviderStateMixin {
  OtcListState state;
  OtcData otc;

  _OtcState({this.state, this.otc});

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _otc(otc);
  }

  Widget _otc(otc) {
    var list = List<Widget>();
    list.add(Padding(
      padding: EdgeInsets.all(10.0),
      child: _loadImage(''),
    ));
    list.add(Padding(
      padding: EdgeInsets.all(20.0),
      child: new Text(
        otc.name,
        style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
      ),
    ));
    list.add(_show(
        'Remaining', otc, Parts().textController1, Parts().handleSubmitted1));
    list.add(_show('Add            ', otc, Parts().textController2,
        Parts().handleSubmitted2));
    list.add(Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(8.0),
        ),
        _label('Total'),
        Padding(
          padding: EdgeInsets.all(8.0),
        ),
        _labelColor((otc.count + otc.add).toString(), Colors.red[300]),
        Padding(
          padding: EdgeInsets.all(8.0),
        ),
      ],
    ));
    return new Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          new Flexible(
            child: new ListView.builder(
              physics: BouncingScrollPhysics(),
              reverse: false,
              itemCount: list.length,
              itemBuilder: (context, i) => list[i],
            ),
          ),
          // Parts().buildBottomButton(context, this.state.barcodeScanning),
          Parts().buildBottomButton2(context, _handleDone, _onBack, 'List'),
        ]);
  }

  void _handleDone() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                new RingupScreen(customer: this.state.customer)));
  }

  _onBack() {
    // this.state.setState(() => this.state.barcode = '');
  }

  Widget _show(label, otc, textController, handleSubmitted) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(8.0),
        ),
        _label(label),
        Padding(
          padding: EdgeInsets.all(8.0),
        ),
        _buildTextComposer("", otc, textController, handleSubmitted),
        Padding(
          padding: EdgeInsets.all(8.0),
        ),
      ],
    );
  }

  // 自由入力フィールド
  Widget _buildTextComposer(label, otc, textController, handleSubmitted) {
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
            controller: textController,
            onChanged: (String t) {
              if (t.length > 0) {
                handleSubmitted(otc, t);
              }
            },
            // onSubmitted: _isComposing ? handleSubmitted : null,
            onSubmitted: (t) => handleSubmitted(otc, t),
            decoration: new InputDecoration.collapsed(hintText: label),
          ),
          onPressed: () async {},
        ),
      ),
    );
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
}
