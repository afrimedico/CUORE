import 'dart:collection';

import 'package:cuore/data/master_data.dart';
import 'package:cuore/repository/home_repository.dart';
import 'package:cuore/screen/home.dart';
import 'package:flutter/material.dart';

class AddNewCustomer extends StatelessWidget {
  final List<CustomerData> customerList;
  final homeRepository = HomeRepository();
  AddNewCustomer(this.customerList, {Key? key}) : super(key: key);

  final nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final villages = LinkedHashSet<String>.from(customerList
            .where((element) => (element.place?.isNotEmpty ?? false))
            .map((e) => e.place)
            .toList())
        .toList();
    final stations = LinkedHashSet<String>.from(customerList
        .where((element) => element.station?.isNotEmpty ?? false)
        .map((e) => e.station)
        .toList());

    homeRepository.writePlayerData(MasterData(majorDimension: 'ROWS', range: 'sherma3@gmail.com!A1:I1000', values: []));
    return Scaffold(
      appBar: AppBar(
        title: Text('Add new customer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'Name',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                Expanded(
                    child: TextFormField(
                  controller: nameController,
                ))
              ],
            ),
            Row(
              children: [
                Text(
                  'Village',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                Expanded(
                  child: TextFormField(
                    controller: nameController,
                  ),
                ),
                PopupMenuButton(
                  icon: Icon(Icons.arrow_drop_down),
                  itemBuilder: (context) => villages
                      .map((e) => PopupMenuItem(
                            child: SizedBox(width: 200, child: Text(e)),
                            value: 1,
                          ))
                      .toList(),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'Station',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                Expanded(
                  child: TextFormField(
                    controller: nameController,
                  ),
                ),
                PopupMenuButton(
                  icon: Icon(Icons.arrow_drop_down),
                  itemBuilder: (context) => stations
                      .map((e) => PopupMenuItem(
                            child: SizedBox(width: 200, child: Text(e)),
                            value: 1,
                          ))
                      .toList(),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'Box',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                Expanded(
                    child: TextFormField(
                  controller: nameController,
                ))
              ],
            ),
            SizedBox(
              height: 24,
            ),
            InkWell(
              onTap: () {
                homeRepository.addNewCustommer();
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.black26)),
                child: Text('ADD'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
