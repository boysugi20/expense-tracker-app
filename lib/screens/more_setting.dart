
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:expense_tracker/bloc/transaction/bloc/transaction_bloc.dart';
import 'package:expense_tracker/database/category_dao.dart';
import 'package:expense_tracker/database/connection.dart';
import 'package:expense_tracker/general/widgets.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/models/transaction.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MoreSettingPage extends StatefulWidget {
  const MoreSettingPage({Key? key}) : super(key: key);

  @override
  State<MoreSettingPage> createState() => _MoreSettingPageState();
}

class _MoreSettingPageState extends State<MoreSettingPage> {

  Future<void> _addTransactionDB(ExpenseCategory expenseCategory, DateTime date, double amount, String note) async {
    if (expenseCategory.id == 0) {
      final db = await DatabaseHelper.initializeDB();
      final int categoryId = await db.insert('ExpenseCategories', expenseCategory.toMap());
      expenseCategory = expenseCategory.copyWith(id: categoryId);
    }
    if (context.mounted){
      context.read<TransactionBloc>().add(AddTransaction(transaction: Transaction(id: 0, category: expenseCategory, date: date, amount: amount, note: note)));
    }
  }
  

  void _exportTransToCSV(BuildContext context) async {

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
      String? saveDirectory = await FilePicker.platform.getDirectoryPath();
      if (saveDirectory != null) {
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

        // final downloadPath = await getDownloadPath();
        String fileName = 'TransactionData.csv';
        final filepath = '$saveDirectory${Platform.pathSeparator}$fileName';

        try{
          // Save the CSV data to a file
          File file = File(filepath);
          await file.writeAsString(csvString, mode: FileMode.write);

          if (context.mounted){
            _showPopup(context, 'Export Success', 'CSV file exported');
          }
          // NotificationService.showNotification(title: 'Success', body: 'CSV file exported', fln: flutterLocalNotificationsPlugin);
        }catch (e){
          if (context.mounted){
            _showPopup(context, 'Export Failed', 'CSV file failed to export');
          }
        }
      } else {
        if (context.mounted){
          _showPopup(context, 'Export Failed', 'CSV file failed to export');
        }
      }
    }

  }

  void _importTransFromCSV(BuildContext context) async {

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

      final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['csv']);
      if (result != null && result.files.isNotEmpty) {
        final file = File(result.files.first.path!);
        final lines = await file.readAsLines();

        final header = lines[0].split(',');

        List<Map> listOfMap = [];

        for (var i = 1; i < lines.length; i++) {
          final values = lines[i].split(',');
          var map = {};
          for (var j = 0; j < header.length; j++) {
            map[header[j]] = values[j];
          }
          listOfMap.add(map);
        }

        try{
          for (var i = 0; i < listOfMap.length; i++){
            var map = listOfMap[i];
            var expenseCategories = await CategoryDAO.getExpenseCategoryIDbyName(map['name']);
            if (expenseCategories.isNotEmpty) {
              _addTransactionDB(expenseCategories.first, DateTime.parse(map['date']), double.parse(map['amount']), map['note']);
            } else {
              _addTransactionDB(ExpenseCategory(id: 0, name: map['name']), DateTime.parse(map['date']), double.parse(map['amount']), map['note']);
            }
          }

          if (context.mounted){
            _showPopup(context, 'Import Success', 'Transaction data imported');
          }
        }catch (e){
          if (context.mounted){
            _showPopup(context, 'Import Failed', 'Transaction data import failed');
          }
        }

      }
    }
  }

  void _showPopup(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
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
              _exportTransToCSV(context);
            },
            child: CardContainer(
              paddingBottom: 16,
              paddingTop: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Export transactions to CSV'),
                  Icon(Icons.upload_rounded)
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              _importTransFromCSV(context);
            },
            child: CardContainer(
              paddingBottom: 16,
              paddingTop: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Import transactions from CSV'),
                  Icon(Icons.download_rounded)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
