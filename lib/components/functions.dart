import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/screens/modal_category.dart';
import 'package:flutter/material.dart';

import '../screens/modal_amount.dart';

void openBottomModalCategory(BuildContext context) {
  showModalBottomSheet(
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    context: context,
    builder: (context) {
      return const BottomModalCategory();
    }
  );
}

void openBottomModalamount(BuildContext context, TransactionCategory category) {
  showModalBottomSheet(
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    context: context,
    builder: (context) {
      return BottomModalamount(
        category: category,
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

  final double finalDouble;

  finalDouble = double.parse(value.replaceAll(',', ''));

  return finalDouble;
}