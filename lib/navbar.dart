import 'package:expense_tracker/screens/modal_choose_category.dart';
import 'package:expense_tracker/styles/color.dart';
import 'package:flutter/material.dart';

import 'package:expense_tracker/screens/dashboard.dart';
import 'package:expense_tracker/screens/transaction.dart';
import 'package:expense_tracker/screens/configuration.dart';
import 'package:expense_tracker/screens/more_setting.dart';

class MyBottomNavigationBar extends StatefulWidget {
  const MyBottomNavigationBar({Key? key}) : super(key: key);

  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    const DashboardPage(),
    const TransactionPage(),
    const TransactionPage(),
    const ConfigurationPage(),
    const MoreSettingPage()
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
  
  void openBottomModal(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.6,
          child: BottomPopupModal()
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    child: _children[_currentIndex]
                  ),

                  // Gradient on top (at status bar)
                  // Container(
                  //   height: 64,
                  //   decoration: BoxDecoration(
                  //     color: AppColors.neutralLight,
                  //     gradient: const LinearGradient(
                  //       colors: <Color>[Colors.black, Color.fromRGBO(0, 0, 0, 0)],
                  //       begin: Alignment.topCenter,
                  //       end: Alignment(0.0, 1.0),
                  //       tileMode: TileMode.clamp,
                  //       stops: [0.0, 0.8],
                  //     ),
                  //   ),
                  // ),
                ]
              ),
            ],
          ),
        ),
        extendBody: true,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(top: 25),
          child: SizedBox(
            height: 64,
            width: 64,
            child: FittedBox(
              child: FloatingActionButton(
                onPressed: (){ openBottomModal(context); },
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
            color: AppColors.neutralDark,
            borderRadius: const BorderRadius.all(Radius.circular(64)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(2, 2), // changes position of shadow
              ),
            ]
            ),
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
                    unselectedItemColor: AppColors.neutralLight,
                    backgroundColor: AppColors.neutralDark,
                    currentIndex: _currentIndex,
                    onTap: onTabTapped,
                    type: BottomNavigationBarType.fixed,
                    items: const [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.bar_chart),
                        label: 'Dashboard',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.account_balance_wallet),
                        label: 'Transaction',
                      ),
                      BottomNavigationBarItem(
                        icon: SizedBox.shrink(),
                        label: '',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.build),
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