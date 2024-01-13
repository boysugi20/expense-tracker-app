import 'package:expense_tracker/bloc/expenseCategory/expenseCategory_bloc.dart';
import 'package:expense_tracker/bloc/goal/goal_bloc.dart';
import 'package:expense_tracker/bloc/incomeCategory/incomeCategory_bloc.dart';
import 'package:expense_tracker/bloc/subscription/subscription_bloc.dart';
import 'package:expense_tracker/bloc/tag/tag_bloc.dart';
import 'package:expense_tracker/bloc/transaction/transaction_bloc.dart';
import 'package:expense_tracker/navbar.dart';
import 'package:expense_tracker/notification.dart';
import 'package:expense_tracker/screens/login.dart';
import 'package:expense_tracker/styles/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService.initialize(flutterLocalNotificationsPlugin);

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<ExpenseCategoryBloc>(
        create: (BuildContext context) => ExpenseCategoryBloc(),
      ),
      BlocProvider<IncomeCategoryBloc>(
        create: (BuildContext context) => IncomeCategoryBloc(),
      ),
      BlocProvider<TransactionBloc>(
        create: (BuildContext context) => TransactionBloc(),
      ),
      BlocProvider<GoalBloc>(
        create: (BuildContext context) => GoalBloc(),
      ),
      BlocProvider<TagBloc>(
        create: (BuildContext context) => TagBloc(),
      ),
      BlocProvider<SubscriptionBloc>(
        create: (BuildContext context) => SubscriptionBloc(),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: AppColors.primary,
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: AppColors.accent),
      ),
      debugShowCheckedModeBanner: false,
      home: const MyBottomNavigationBar(),
      // home: const LoginPage(),
    );
  }
}
