import 'package:expense_tracker/bloc/expenseCategory/expenseCategory_bloc.dart';
import 'package:expense_tracker/bloc/goal/goal_bloc.dart';
import 'package:expense_tracker/bloc/incomeCategory/incomeCategory_bloc.dart';
import 'package:expense_tracker/bloc/subscription/subscription_bloc.dart';
import 'package:expense_tracker/bloc/tag/tag_bloc.dart';
import 'package:expense_tracker/bloc/transaction/transaction_bloc.dart';
import 'package:expense_tracker/general/functions.dart';
import 'package:expense_tracker/navbar.dart';
import 'package:expense_tracker/notification.dart';
import 'package:expense_tracker/styles/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) {
    switch (task) {
      case 'subscription_reminder':
        String name = inputData?['name'];
        int paymentDay = inputData?['paymentDate'];
        String startDateString = inputData?['startDate'];
        String endDateString = inputData?['endDate'];
        DateTime startDate = DateTime.parse(startDateString);
        DateTime endDate = DateTime.parse(endDateString);
        sendSubscriptionPaymentReminder(name, startDate, endDate, paymentDay);
        break;
    }
    return Future.value(true);
  });
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService.initialize(flutterLocalNotificationsPlugin);
  Workmanager().initialize(callbackDispatcher, isInDebugMode: false);

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
      ),
      debugShowCheckedModeBanner: false,
      home: const MyBottomNavigationBar(),
      // home: const LoginPage(),
    );
  }
}
