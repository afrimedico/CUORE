import 'dart:convert';
import 'dart:io';
import 'dart:developer';

import 'package:cuore/data/master_data.dart';
import 'package:cuore/data/value.dart';
import 'package:cuore/profile/app.dart';
import 'package:cuore/repository/otc.dart';
import 'package:cuore/repository/sheet.dart';
import 'package:cuore/screen/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';


class HomeRepository {

  List<CustomerData> _customerList = [];
  
  String userName = '';
  
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/customers.json');
  }

  Future<File> writeCustomerData(List<CustomerData> customers) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString('asd');
  }

  Future<List<CustomerData>?> readCustomerData() async {
    try {
      final file = await _localFile;
      final contents = await file.readAsString();

      final jsonResponse = jsonDecode(contents);

      print('asd'+jsonResponse);

    } catch (e) {
      print(json.decode(e.toString()));
      // If encountering an error, return 0
      return null;
    }
  }

  Future<MasterData> readPlayerData() async {
    try {
      final file = await _localFile;
      String contents = await file.readAsString();
      final jsonResponse = jsonDecode(contents);
      MasterData data = MasterData.fromJson(jsonResponse);
      return data;
    } catch (e) {
      throw e;
    }
    // String fileText = await rootBundle.loadString('assets/file.txt');
    // print(fileText);
    // return fileText;
  }

  void addNewCustommer(name,place,station,context) async {
    var user = await App.getProfile();
    
    if (user['name'] != null) {
      userName = user['name'];
    }

    var items = await CustomerDb.loadItemFromSheets(false);
    
    this._customerList = (await CustomerDb.loadFromSheets(userName, items, false))!;

    CustomerData? newCustomer;

    newCustomer = CustomerData(place: place, name: name, station: station);

    items.forEach((k,item){
        var otc = OtcData(
          key: item.key,
          name: item.name,
          code: item.code,
          price: item.price ?? 0,
          base: 0,
          preuse: 0,
          preadd: 0,
          useall: 0,
          addall: 0
        );
        newCustomer!.otcList?.add(otc);
    });

    this._customerList.add(newCustomer);

    await CustomerDb.saveAsSheets(this._customerList);

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => HomeScreen()),
            (Route<dynamic> route) => false);
  }
}
