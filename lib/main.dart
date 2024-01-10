import 'package:expense_tracker/bloc/category/category_bloc.dart';
import 'package:expense_tracker/bloc/goal/goal_bloc.dart';
import 'package:expense_tracker/bloc/tag/tag_bloc.dart';
import 'package:expense_tracker/bloc/transaction/transaction_bloc.dart';
import 'package:expense_tracker/navbar.dart';
import 'package:expense_tracker/notification.dart';
import 'package:expense_tracker/styles/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService.initialize(flutterLocalNotificationsPlugin);

  runApp(
    MultiProvider(
      providers: [
        Provider<CategoryBloc>(create: (BuildContext context) => CategoryBloc()),
        Provider<TransactionBloc>(create: (BuildContext context) => TransactionBloc()),
        Provider<GoalBloc>(create: (BuildContext context) => GoalBloc()),
        Provider<TagBloc>(create: (BuildContext context) => TagBloc()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: AppColors.main,
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: AppColors.accent),
      ),
      debugShowCheckedModeBanner: false,
      home: const MyBottomNavigationBar(),
      // home: LoginPage(),
    );
  }
}
