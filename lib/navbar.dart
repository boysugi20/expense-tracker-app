import 'package:expense_tracker/styles/color.dart';
import 'package:flutter/material.dart';

import 'package:expense_tracker/screens/dashboard.dart';
import 'package:expense_tracker/screens/transaction.dart';
import 'package:expense_tracker/screens/configuration.dart';
import 'package:expense_tracker/screens/more_setting.dart';

import 'general/functions.dart';

class MyBottomNavigationBar extends StatefulWidget {
  const MyBottomNavigationBar({Key? key}) : super(key: key);

  @override
  MyBottomNavigationBarState createState() => MyBottomNavigationBarState();
}

class MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  int _currentIndex = 0;

  List<Widget> _children = [];

  @override
  void initState() {
    _children = [
      const DashboardPage(),
      const TransactionPage(),
      const TransactionPage(),
      const ConfigurationPage(),
      const MoreSettingPage()
    ];
    super.initState();
  }

  void changeScreen(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(child: _children[_currentIndex]),
      ),
      extendBody: true,
      resizeToAvoidBottomInset: false,
      floatingActionButtonAnimator: null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 25),
        child: SizedBox(
          height: 64,
          width: 64,
          child: FittedBox(
            child: FloatingActionButton(
              onPressed: () {
                openBottomModalCategory(context, changeScreen);
              },
              backgroundColor: AppColors.accent,
              child: const Icon(Icons.add),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(left: 24, right: 24, bottom: 12),
        height: 72,
        child: Container(
          decoration: BoxDecoration(
              color: AppColors.neutral,
              borderRadius: const BorderRadius.all(Radius.circular(64)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(2, 2), // changes position of shadow
                ),
              ]),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(64),
            child: Container(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Theme(
                data: ThemeData(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
                child: BottomNavigationBar(
                  iconSize: 18,
                  elevation: 1,
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                  selectedItemColor: AppColors.accent,
                  unselectedItemColor: AppColors.base300,
                  backgroundColor: AppColors.neutral,
                  currentIndex: _currentIndex,
                  onTap: changeScreen,
                  type: BottomNavigationBarType.fixed,
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.bar_chart),
                      label: 'Dashboard',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.receipt),
                      label: 'Transaction',
                    ),
                    BottomNavigationBarItem(
                      icon: SizedBox.shrink(),
                      label: '',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.tune),
                      label: 'Configuration',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.more_horiz),
                      label: 'More',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
