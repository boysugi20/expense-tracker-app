
import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/screens/modal_category.dart';
import 'package:flutter/material.dart';

import '../screens/modal_amount.dart';

void openBottomModalCategory(BuildContext context, Function(int index) changeScreen) {
  showModalBottomSheet(
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    context: context,
    builder: (context) {
      return BottomModalCategory(changeScreen: changeScreen);
    }
  );
}

void openBottomModalAmount(BuildContext context, Object categoryOrGoal, {Function(int index)? changeScreen, Transaction? initialTransaction}) {
  showModalBottomSheet(
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    context: context,
    builder: (context) {
      return BottomModalamount(
        categoryOrGoal: categoryOrGoal,
        changeScreen: changeScreen ?? (int index) {},
        initialTransaction: initialTransaction,
      );
    },
  );
}

String addThousandSeperatorToString (String string) {

  String result;

  result = string.replaceAll(",", "").replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');

  return result;
}

String monthIntToString (int value){
  
  List<Map<String, dynamic>> months = [  
    {'index': 0, 'label': 'Jan'},  
    {'index': 1, 'label': 'Feb'},  
    {'index': 2, 'label': 'Mar'},  
    {'index': 3, 'label': 'Apr'},  
    {'index': 4, 'label': 'May'},  
    {'index': 5, 'label': 'Jun'},  
    {'index': 6, 'label': 'Jul'},  
    {'index': 7, 'label': 'Aug'},  
    {'index': 8, 'label': 'Sep'},  
    {'index': 9, 'label': 'Oct'},  
    {'index': 10, 'label': 'Nov'},  
    {'index': 11, 'label': 'Dec'},
  ];
  
  String monthText = '';

  for (var i = 0; i < months.length; i++) {
    if (value == months[i]['index']) {
      monthText = months[i]['label'];
    break;
    } else {
      monthText = '';
    }
  }

  return monthText;
}

String amountDoubleToString(double value){

  final finalString = addThousandSeperatorToString(value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 1));

  return finalString;
}

double amountStringToDouble(String value) {

  double finalDouble;

  try{
    finalDouble = double.parse(value.replaceAll(',', ''));
  }catch (e){
    finalDouble = double.parse('0');
  }

  return finalDouble;
}

Future<String> getDownloadPath() async {

  // final directorytemp = await getApplicationDocumentsDirectory();
  // String localPath = '${directorytemp.path}${Platform.pathSeparator}Download';
  // final savedDir = Directory(localPath);
  // bool hasExisted = await savedDir.exists();
  // if (!hasExisted) {
  //   savedDir.create();
  // }

  // return localPath;
  return '/storage/emulated/0/Download';
}

void showAlert(BuildContext context, String textBody, String textHeader) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(textHeader),
        content: Text(textBody),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}