import 'package:expense_tracker/bloc/category/category_bloc.dart';
import 'package:expense_tracker/bloc/goal/goal_bloc.dart';
import 'package:expense_tracker/bloc/transaction/bloc/transaction_bloc.dart';
import 'package:expense_tracker/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


// void main() {
//   runApp(const MyApp());
// }

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<CategoryBloc>(create: (_) => CategoryBloc()),
        Provider<TransactionBloc>(create: (_) => TransactionBloc()),
        Provider<GoalBloc>(create: (_) => GoalBloc()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: MyBottomNavigationBar(),
      home: LoginPage(),
    );
  }
}