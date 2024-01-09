import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/screens/modal_category.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' show Directory, Platform;

import '../screens/modal_amount.dart';

void openBottomModalCategory(
    BuildContext context, Function(int index) changeScreen) {
  showMaterialModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => BottomModalCategory(changeScreen: changeScreen));
}

void openBottomModalAmount(BuildContext context, Object categoryOrGoal,
    {Function(int index)? changeScreen, Transaction? initialTransaction}) {
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

String addThousandSeperatorToString(String string) {
  String result;

  result = string.replaceAll(",", "").replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');

  return result;
}

String monthIntToString(int value) {
  List<Map<String, dynamic>> months = [
    {'index': 1, 'label': 'Jan'},
    {'index': 2, 'label': 'Feb'},
    {'index': 3, 'label': 'Mar'},
    {'index': 4, 'label': 'Apr'},
    {'index': 5, 'label': 'May'},
    {'index': 6, 'label': 'Jun'},
    {'index': 7, 'label': 'Jul'},
    {'index': 8, 'label': 'Aug'},
    {'index': 9, 'label': 'Sep'},
    {'index': 10, 'label': 'Oct'},
    {'index': 11, 'label': 'Nov'},
    {'index': 12, 'label': 'Dec'},
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

String amountDoubleToString(double value) {
  final finalString = addThousandSeperatorToString(
      value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 1));

  return finalString;
}

double amountStringToDouble(String value) {
  double finalDouble;

  try {
    finalDouble = double.parse(value.replaceAll(',', ''));
  } catch (e) {
    finalDouble = double.parse('0');
  }

  return finalDouble;
}

Future<String> getDownloadPath() async {
  bool dirDownloadExists = true;
  String directory;

  if (Platform.isIOS) {
    final directorytemp = await getDownloadsDirectory();
    directory = directorytemp!.path;
  } else {
    dirDownloadExists =
        await Directory("/storage/emulated/0/Download/").exists();
    if (dirDownloadExists) {
      directory = "/storage/emulated/0/Download/";
    } else {
      directory = "/storage/emulated/0/Downloads/";
    }
  }
  return directory;

  // return '/storage/emulated/0/Download';
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

saveConfiguration(String title, Object value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  if (value is bool) {
    prefs.setBool(title, value);
  } else if (value is String) {
    prefs.setString(title, value);
  } else if (value is int) {
    prefs.setInt(title, value);
  } else if (value is double) {
    prefs.setDouble(title, value);
  }
}

Future<bool?> getConfigurationBool(String title) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool(title);
}

Future<String?> getConfigurationString(String title) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(title);
}

Future<int?> getConfigurationInt(String title) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getInt(title);
}

Future<double?> getConfigurationDouble(String title) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getDouble(title);
}

String colorToHex(Color color) {
  return '#${color.value.toRadixString(16).padLeft(8, '0').substring(2)}';
}

Color hexToColor(String hexColor) {
  try {
    String formattedHex = hexColor.replaceAll("#", "");
    int parsedColor = int.parse(formattedHex, radix: 16);
    return Color(parsedColor | 0xFF000000);
  } catch (e) {
    return Colors.red;
  }
}

Color getTextColorForBackground(Color backgroundColor) {
  // Calculate the luminance of the background color
  double luminance = backgroundColor.computeLuminance();

  // Use black or white text depending on the brightness of the background color
  return luminance > 0.5 ? Colors.black : Colors.white;
}
