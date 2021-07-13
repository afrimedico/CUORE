import 'dart:collection';

import 'package:cuore/data/master_data.dart';
import 'package:cuore/repository/home_repository.dart';
import 'package:cuore/screen/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
        title: Text(AppLocalizations.of(context).ok),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  AppLocalizations.of(context).user_name,
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
                  AppLocalizations.of(context).village,
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
                  AppLocalizations.of(context).place,
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
                  AppLocalizations.of(context).box,
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
                child: Text(AppLocalizations.of(context).add),
              ),
            )
          ],
        ),
      ),
    );
  }
}
