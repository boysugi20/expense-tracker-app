import 'package:expense_tracker/styles/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'navbar.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
  //    SystemUiOverlay.bottom, //This line is used for showing the bottom bar
  // ]);
  // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
  //   statusBarColor: Colors.black, //or set color with: Color(0xFF0000FF)
  // ));

  runApp(const MaterialApp(
    home: MyBottomNavigationBar(),
  ));
}