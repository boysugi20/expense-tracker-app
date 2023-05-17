import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:expense_tracker/database/connection.dart';
import 'package:expense_tracker/general/functions.dart';
import 'package:expense_tracker/general/widgets.dart';
import 'package:expense_tracker/main.dart';
import 'package:expense_tracker/notification.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class MoreSettingPage extends StatelessWidget {
  const MoreSettingPage({Key? key}) : super(key: key);

  void _handleTap(BuildContext context) async {

    final androidInfo = await DeviceInfoPlugin().androidInfo;
    late final Map<Permission, PermissionStatus> statusess;

    if (androidInfo.version.sdkInt <= 32) {
      statusess = await [Permission.storage,].request();
    } else {
      statusess = await [Permission.notification].request();
    }

    var allAccepted = true;
    statusess.forEach((permission, status) {
      if (status != PermissionStatus.granted) {
        allAccepted = false;
      }
    });

    if (allAccepted) {
      DatabaseHelper db = DatabaseHelper();
      var queryResult = await db.accessDatabase('SELECT A.*, B.name FROM Transactions AS A JOIN ExpenseCategories AS B ON A.expenseCategoryID = B.id');

      List<String> csvData = [];
      // Add headers to the CSV data
      csvData.add(queryResult[0].keys.join(','));
      // Add rows to the CSV data
      for (var row in queryResult) {
        csvData.add(row.values.map((value) => value.toString()).join(','));
      }
      String csvString = csvData.join('\n');

      // Get Downloads path
      final downloadPath = await getDownloadPath();
      String fileName = 'TransactionData.csv';
      final filepath = '$downloadPath${Platform.pathSeparator}$fileName';

      // Save the CSV data to a file
      File file = File(filepath);
      await file.writeAsString(csvString);
      
      NotificationService.showNotification(title: 'Success', body: 'Your CSV file have been downloaded', fln: flutterLocalNotificationsPlugin);
    }

    // DatabaseHelper db = DatabaseHelper();
    // var queryResult = await db.accessDatabase('SELECT A.*, B.name FROM Transactions AS A JOIN ExpenseCategories AS B ON A.expenseCategoryID = B.id');

    // List<String> csvData = [];
    // // Add headers to the CSV data
    // csvData.add(queryResult[0].keys.join(','));
    // // Add rows to the CSV data
    // for (var row in queryResult) {
    //   csvData.add(row.values.map((value) => value.toString()).join(','));
    // }
    // String csvString = csvData.join('\n');

    // // Get Downloads path
    // final downloadPath = await getDownloadPath();
    // final filepath = '$downloadPath/output.csv';

    // // Save the CSV data to a file
    // File file = File(filepath);

    // await file.writeAsString(csvString);
    
    // // String jsonString = json.encode(queryResult);
    // NotificationService.showNotification(title: 'Success', body: 'Your CSV file have been downloaded', fln: flutterLocalNotificationsPlugin);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 32, right: 32, top: MediaQuery.of(context).viewPadding.top + 24, bottom: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(text: 'Tools:', firstChild: true,),
          GestureDetector(
            onTap: () {
              _handleTap(context);
            },
            child: CardContainer(
              paddingBottom: 16,
              paddingTop: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Export transactions to CSV'),
                  Icon(Icons.outbond)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
