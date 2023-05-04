import 'package:expense_tracker/screens/add_transaction.dart';
import 'package:flutter/material.dart';
import 'package:circle_nav_bar/circle_nav_bar.dart';

import 'package:expense_tracker/styles/color.dart';
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
    const AddTransactionPage(),
    const ConfigurationPage(),
    const MoreSettingPage()
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   bottomNavigationBar: Container(
    //     margin: const EdgeInsets.only(left: 24, right: 24, bottom: 12),
    //     height: 64,
    //     child: ClipRRect(
    //       borderRadius: BorderRadius.circular(200),
    //       child: BottomAppBar(
    //         color: AppColors.darkest,
    //         shape: CircularNotchedRectangle(),
    //         child: Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //           children: [
    //             IconButton(icon: Icon(Icons.bar_chart), onPressed: () {}),
    //             IconButton(icon: Icon(Icons.search), onPressed: () {}),
    //             SizedBox(width: 64,),
    //             IconButton(icon: Icon(Icons.search), onPressed: () {}),
    //             IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    //   floatingActionButton:
    //     FloatingActionButton(child: Icon(Icons.add), onPressed: () {}),
    //   floatingActionButtonLocation: 
    //     FloatingActionButtonLocation.centerDocked,
    // );
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(top: 25),
          child: Container(
            height: 64,
            width: 64,
            child: FittedBox(
              child: FloatingActionButton(
                child: const Icon(Icons.add), 
                onPressed: () {},
                backgroundColor: AppColors.accent,
              ),
            ),
          ),
        ),
        body: _children[_currentIndex],
        bottomNavigationBar: Container(
          margin: const EdgeInsets.only(left: 24, right: 24, bottom: 12),
          height: 64,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(200),
            child: Container(
              padding: const EdgeInsets.only(left: 24, right: 24),
              color: AppColors.darkest,
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
                  unselectedItemColor: AppColors.white,
                  backgroundColor: AppColors.darkest,
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
    );
  }
}