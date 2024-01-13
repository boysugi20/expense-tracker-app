import 'dart:convert';
import 'dart:math';

import 'package:expense_tracker/bloc/goal/goal_bloc.dart';
import 'package:expense_tracker/database/connection.dart';
import 'package:expense_tracker/general/functions.dart';
import 'package:expense_tracker/screens/login.dart';

import 'package:expense_tracker/styles/color.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/general/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconpicker/Serialization/iconDataSerialization.dart';
import 'package:intl/intl.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  DatabaseHelper db = DatabaseHelper();

  bool budgetMode = true;
  double budgetAmount = 0;
  String userName = '';

  String dropdownText = 'This Month';
  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(value: "All", child: Text("All")),
      const DropdownMenuItem(value: "This Month", child: Text("This Month")),
      const DropdownMenuItem(value: "Last Month", child: Text("Last Month")),
    ];
    return menuItems;
  }

  List<FlSpot> chartData = [];

  Future<List<FlSpot>> getChartData() async {
    List<Map<String, Object?>> monthlyAmounts = await db.accessDatabase('''
      SELECT strftime('%Y-%m', date) AS yearMonth, SUM(amount) AS totalAmount
      FROM Transactions
      GROUP BY yearMonth
      ORDER BY yearMonth ASC
    ''');

    chartData = monthlyAmounts.map((row) {
      String yearMonth = row['yearMonth'] as String;
      double y = row['totalAmount'] as double;
      return FlSpot(_parseYearMonth(yearMonth), y);
    }).toList();

    return chartData;
  }

  Future<List<Map<String, Object?>>> getTransactionsFiltered() async {
    List<Map<String, Object?>> transactions = [];

    if (dropdownText == 'This Month') {
      DateTime now = DateTime.now();
      String currentMonth = DateFormat('yyyy-MM').format(now);

      transactions = await db.accessDatabase('''
        SELECT 
          A.*, 
          B.id as expenseCategoryId, B.name as expenseCategoryName, B.icon as expenseCategoryIcon, 
          C.id as incomeCategoryId, C.name as incomeCategoryName, C.icon as incomeCategoryIcon
        FROM 
          Transactions AS A 
          LEFT JOIN ExpenseCategories AS B ON A.ExpenseCategoryId = B.id 
          LEFT JOIN IncomeCategories AS C ON A.IncomeCategoryId = C.id
        WHERE 
          strftime('%Y-%m', date) = '$currentMonth'
      ''');
    } else if (dropdownText == 'Last Month') {
      DateTime now = DateTime.now();
      DateTime previousMonthDate = DateTime(now.year, now.month - 1, now.day);
      String previousMonth = DateFormat('yyyy-MM').format(previousMonthDate);

      transactions = await db.accessDatabase('''
        SELECT 
          A.*, 
          B.id as expenseCategoryId, B.name as expenseCategoryName, B.icon as expenseCategoryIcon, 
          C.id as incomeCategoryId, C.name as incomeCategoryName, C.icon as incomeCategoryIcon
        FROM 
          Transactions AS A 
          LEFT JOIN ExpenseCategories AS B ON A.ExpenseCategoryId = B.id 
          LEFT JOIN IncomeCategories AS C ON A.IncomeCategoryId = C.id
        WHERE 
          strftime('%Y-%m', date) = '$previousMonth'
      ''');
    } else {
      transactions = await db.accessDatabase('''
        SELECT
          A.*, 
          B.id as expenseCategoryId, B.name as expenseCategoryName, B.icon as expenseCategoryIcon, 
          C.id as incomeCategoryId, C.name as incomeCategoryName, C.icon as incomeCategoryIcon
        FROM 
          Transactions AS A 
          LEFT JOIN ExpenseCategories AS B ON A.ExpenseCategoryId = B.id 
          LEFT JOIN IncomeCategories AS C ON A.IncomeCategoryId = C.id
      ''');
    }

    return transactions;
  }

  double _parseYearMonth(String yearMonth) {
    List<String> parts = yearMonth.split('-');
    int year = int.tryParse(parts[0]) ?? 0;
    int month = int.tryParse(parts[1]) ?? 0;

    return (((month) * 10000) + year).toDouble();
  }

  void _redirectToLogin(userName) {
    if (userName == null || userName.isEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  void initializeValues() async {
    bool? budgetModeValue = await getConfigurationBool('budget_mode');
    double? budgetAmountValue = await getConfigurationDouble('budget_amount');
    String? fetchedUserName = await getConfigurationString('user_name');

    _redirectToLogin(fetchedUserName);

    setState(() {
      budgetMode = budgetModeValue ?? true;
      budgetAmount = budgetAmountValue ?? 0;
      userName = fetchedUserName ?? '';
    });
  }

  @override
  void initState() {
    super.initState();
    initializeValues();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 100),
      child: Stack(children: [
        CustomPaint(
          painter: _WaveCustomPaint(backgroundColor: AppColors.primary),
          size: MediaQuery.of(context).size,
        ),
        Container(
          padding: EdgeInsets.only(left: 32, right: 32, top: MediaQuery.of(context).viewPadding.top + 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      text: 'Hello,\n',
                      style: const TextStyle(color: Colors.white),
                      children: <TextSpan>[
                        TextSpan(text: userName, style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.base200),
                      borderRadius: BorderRadius.circular(4),
                      color: AppColors.base100,
                    ),
                    child: DropdownButton(
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownText = newValue!;
                        });
                      },
                      value: dropdownText,
                      items: dropdownItems,
                      style: TextStyle(color: AppColors.primary, fontSize: 12),
                      underline: const SizedBox(),
                      isDense: true,
                    ),
                  ),
                ],
              ),

              FutureBuilder<List<Map<String, Object?>>>(
                future: getTransactionsFiltered(),
                builder: (context, snapshot) {
                  List<Map<String, Object?>> transactions = snapshot.data ?? [];

                  double balance = 0;
                  double income = 0;
                  double expense = 0;

                  for (var transaction in transactions) {
                    double amount = transaction['amount'] as double;

                    if (transaction['expenseCategoryId'] != null) {
                      expense += amount;
                    } else {
                      income += amount;
                    }
                  }

                  if (budgetMode) {
                    balance = budgetAmount - expense;
                  } else {
                    balance = income - expense;
                  }

                  return BalanceCard(balance: balance, income: income, expense: expense);
                },
              ),

              // const SectionTitle(text: 'Notifications'),

              // const SingleChildScrollView(
              //   scrollDirection: Axis.horizontal,
              //   child: Row(
              //     children: [
              //       NotificationCard(),
              //       NotificationCard(),
              //     ],
              //   ),
              // ),

              const SectionTitle(text: 'Monthly Expense'),

              FutureBuilder<List<FlSpot>>(
                future: getChartData(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    chartData = snapshot.data!;
                    if (chartData.isEmpty) {
                      return const NoDataWidget(text: 'No Transactions yet');
                    }
                    return ExpenseChart(
                        data: chartData.length > 6
                            ? chartData.sublist(
                                chartData.length - 6,
                                chartData.length,
                              )
                            : chartData);
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),

              BlocBuilder<GoalBloc, GoalState>(
                builder: (context, state) {
                  if (state is GoalInitial || state is GoalUpdated) {
                    context.read<GoalBloc>().add(const GetGoals());
                  }
                  if (state is GoalLoaded) {
                    if (state.goal.isNotEmpty) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SectionTitle(text: 'Goals'),
                          ...state.goal.map((goalItem) => GoalsCard(
                                title: goalItem.name,
                                progressAmount: goalItem.progressAmount,
                                totalAmount: goalItem.totalAmount,
                                progress: goalItem.totalAmount != 0
                                    ? (goalItem.progressAmount != null
                                        ? (goalItem.progressAmount! / goalItem.totalAmount) * 100
                                        : 0)
                                    : 0,
                              )),
                        ],
                      );
                    }
                  }
                  return Container();
                },
              ),

              const SectionTitle(text: 'Expenses'),

              FutureBuilder<List<Map<String, Object?>>>(
                future: getTransactionsFiltered(),
                builder: (context, snapshot) {
                  List<Map<String, Object?>> transactions = snapshot.data ?? [];

                  // Calculate the total amount for each category
                  final categoryTotalMap = <String, Map<String, dynamic>>{};
                  double totalAmount = 0;

                  for (var transaction in transactions) {
                    if (transaction['expenseCategoryId'] != null) {
                      final category = transaction['expenseCategoryName'].toString();
                      final amount = double.parse(transaction['amount'].toString());
                      final icon = transaction['expenseCategoryIcon'].toString();

                      totalAmount += amount;

                      if (!categoryTotalMap.containsKey(category)) {
                        categoryTotalMap[category] = {
                          'amount': amount,
                          'icon': icon,
                        };
                      } else {
                        categoryTotalMap[category]!['amount'] += amount;
                      }
                    }
                  }

                  // Generate a list of Expenses widgets based on the category totals
                  final expenseWidgets = categoryTotalMap.entries.map((entry) {
                    final category = entry.key;
                    final amount = entry.value['amount'] as double;
                    final icon = entry.value['icon'] as String;

                    return Expenses(text: category, amount: amount, icon: icon, totalAmount: totalAmount);
                  }).toList();

                  // Sort the expenseWidgets list by amount in descending order
                  expenseWidgets.sort((a, b) => b.amount.compareTo(a.amount));

                  if (expenseWidgets.isNotEmpty) {
                    return Column(
                      children: expenseWidgets,
                    );
                  } else {
                    return const NoDataWidget(text: 'No Transactions yet');
                  }
                },
              ),
            ],
          ),
        ),
      ]),
    );
  }
}

class NotificationCard extends StatelessWidget {
  const NotificationCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CardContainer(
      child: IntrinsicWidth(
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(right: 12),
              child: CircleAvatar(
                backgroundColor: AppColors.base300,
              ),
            ),
            RichText(
              text: const TextSpan(
                text: 'Warning\n',
                style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                    text: 'Lorem ipsum dolor sit amet',
                    style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ExpenseChart extends StatelessWidget {
  ExpenseChart({
    Key? key,
    required this.data,
  }) : super(key: key);

  final List<FlSpot> data;

  late final double maxY = data.reduce((value, element) => value.y > element.y ? value : element).y;
  late final double minY = data.reduce((value, element) => value.y < element.y ? value : element).y;

  @override
  Widget build(BuildContext context) {
    return CardContainer(
      height: 240,
      paddingTop: 24,
      paddingRight: 24,
      paddingLeft: 8,
      paddingBottom: 8,
      child: BarChart(
        BarChartData(
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              tooltipBgColor: AppColors.base100,
              tooltipBorder: BorderSide(color: AppColors.primary, width: 1),
              tooltipPadding: const EdgeInsets.all(8),
              tooltipRoundedRadius: 2,
              tooltipMargin: 2,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                TextStyle textStyle = TextStyle(color: AppColors.neutral);
                return BarTooltipItem(
                  '${valueToTitle(group.x.toDouble())}\nRp ${addThousandSeperatorToString((rod.toY).toInt().toString())}',
                  textStyle,
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 45,
                interval: 0.1,
                getTitlesWidget: bottomTitleWidgets,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: ((maxY + minY) / 2) * 0.5,
                getTitlesWidget: leftTitleWidgets,
                reservedSize: 42,
              ),
            ),
          ),
          borderData: FlBorderData(
            show: false,
          ),
          minY: max(minY - (maxY * 0.25), 0),
          maxY: maxY + (maxY * 0.25),
          barGroups: data.map((item) {
            return BarChartGroupData(
              x: item.x.toInt(),
              barRods: [
                BarChartRodData(
                  toY: item.y,
                  color: AppColors.primary,
                  width: 18,
                  borderRadius: BorderRadius.circular(2),
                ),
              ],
            );
          }).toList(),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: ((maxY + minY) / 2) * 0.5,
            verticalInterval: 1,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: AppColors.base200,
                strokeWidth: 1,
              );
            },
          ),
        ),
        swapAnimationDuration: const Duration(milliseconds: 150),
        swapAnimationCurve: Curves.linear,
      ),
      // child: LineChart(
      //     LineChartData(
      //       lineTouchData: LineTouchData(
      //         touchTooltipData: LineTouchTooltipData(
      //           tooltipBgColor: AppColors.base100,
      //           tooltipBorder: BorderSide(color: AppColors.accent, width: 2),
      //           getTooltipItems: (List<LineBarSpot> touchedSpots) {
      //             TextStyle tooltipStyle = TextStyle(color: AppColors.accent);
      //             return touchedSpots.map((LineBarSpot touchedSpot) {
      //               return LineTooltipItem(
      //                 '${monthIntToString((touchedSpot.x).toInt())}\nRp ${addThousandSeperatorToString((touchedSpot.y).toInt().toString())}',
      //                 tooltipStyle,
      //               );
      //             }).toList();
      //           },
      //         ),
      //       ),
      //       titlesData: FlTitlesData(
      //         show: true,
      //         rightTitles: AxisTitles(
      //           sideTitles: SideTitles(showTitles: false),
      //         ),
      //         topTitles: AxisTitles(
      //           sideTitles: SideTitles(showTitles: false),
      //         ),
      //         bottomTitles: AxisTitles(
      //           sideTitles: SideTitles(
      //             showTitles: true,
      //             reservedSize: 30,
      //             interval: 1,
      //             getTitlesWidget: bottomTitleWidgets,
      //           ),
      //         ),
      //         leftTitles: AxisTitles(
      //           sideTitles: SideTitles(
      //             showTitles: true,
      //             interval: ((maxY+minY)/2) * 0.5,
      //             getTitlesWidget: leftTitleWidgets,
      //             reservedSize: 42,
      //           ),
      //         ),
      //       ),
      //       borderData: FlBorderData(
      //         show: false,
      //         border: Border.all(color: const Color(0xff37434d)),
      //       ),
      //       // minX: 0,
      //       // maxX: 11,
      //       // baselineY: minY,
      //       minY: max(minY - (maxY * 0.25), 0),
      //       maxY: maxY + (maxY * 0.25),
      //       lineBarsData: [
      //         LineChartBarData(
      //           spots: data,
      //           curveSmoothness: 0.3,
      //           dotData: FlDotData(
      //             show: true,
      //             getDotPainter: (spot, percent, barData, index) =>  FlDotCirclePainter(
      //               radius: 3,
      //               color: AppColors.accent,
      //             ),
      //           ),
      //           isCurved: true,
      //           barWidth: 1,
      //           isStrokeCapRound: true,
      //           belowBarData: BarAreaData(
      //             show: true,
      //             gradient: LinearGradient(
      //               colors: [AppColors.primary,AppColors.accent].map((color) => color.withOpacity(0.3)).toList(),
      //             ),
      //           ),
      //           gradient: LinearGradient(
      //             colors: [
      //               ColorTween(begin: AppColors.primary, end: AppColors.accent).lerp(0.2)!,
      //               ColorTween(begin: AppColors.primary, end: AppColors.accent).lerp(0.2)!,
      //             ],
      //           ),
      //         ),
      //       ],
      //       gridData: FlGridData(
      //         show: true,
      //         drawVerticalLine: true,
      //         horizontalInterval: maxY * 0.25,
      //         verticalInterval: 1,
      //         getDrawingHorizontalLine: (value) {
      //           return FlLine(
      //             color: AppColors.base200,
      //             strokeWidth: 1,
      //           );
      //         },
      //         getDrawingVerticalLine: (value) {
      //           return FlLine(
      //             color: AppColors.base200,
      //             strokeWidth: 1,
      //           );
      //         },
      //       ),
      //     ),
      //     swapAnimationDuration: const Duration(milliseconds: 150), // Optional
      //     swapAnimationCurve: Curves.linear, // Optional
      //   ),
    );
  }
}

class GoalsCard extends StatelessWidget {
  final double progress;
  final double? progressAmount;
  final double totalAmount;
  final String title;

  const GoalsCard(
      {required this.title, required this.progress, this.progressAmount, required this.totalAmount, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1,
      child: CardContainer(
        paddingTop: 16,
        paddingBottom: 16,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text(title, style: TextStyle(color: AppColors.neutral)),
                ),
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  progressAmount != null
                      ? Text(
                          '${amountDoubleToString(progressAmount!)} / ${amountDoubleToString(totalAmount)} ( ${progress.toStringAsFixed(1)}% )',
                          style: TextStyle(color: AppColors.base300, fontSize: 12),
                        )
                      : Text(
                          '0 / ${amountDoubleToString(totalAmount)} ( 0% )',
                          style: TextStyle(color: AppColors.base300, fontSize: 12),
                        ),
                ]),
              ],
            ),
            const Divider(),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      minHeight: 8,
                      value: progress / 100,
                      color: progress >= 100 ? AppColors.success : AppColors.primary,
                      backgroundColor: AppColors.primary.withOpacity(0.2),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Expenses extends StatelessWidget {
  final String text;
  final String? icon;
  final double amount, totalAmount;

  const Expenses({required this.text, required this.amount, required this.totalAmount, this.icon, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CardContainer(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 12),
                    child: CircleAvatar(
                      backgroundColor: Colors.grey.shade200,
                      child: icon != null
                          ? Icon(
                              deserializeIcon(jsonDecode(icon!)),
                              color: AppColors.primary,
                            )
                          : Text(
                              text.isNotEmpty ? text.split(" ").map((e) => e[0]).take(2).join().toUpperCase() : "",
                              style: TextStyle(color: AppColors.primary),
                            ),
                    ),
                  ),
                  RichText(
                    text: TextSpan(text: text, style: const TextStyle(color: Colors.black)),
                  ),
                ],
              ),
              RichText(
                text: TextSpan(
                    text: 'Rp ${amountDoubleToString(amount)}',
                    style: const TextStyle(color: Colors.red, fontSize: 12)),
              ),
            ],
          ),
          const Divider(),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              minHeight: 8,
              value: amount / totalAmount,
              color: AppColors.primary,
              backgroundColor: AppColors.primary.withOpacity(0.2),
            ),
          ),
        ],
      ),
    );
  }
}

class BalanceCard extends StatelessWidget {
  final double income;
  final double expense;
  final double balance;

  const BalanceCard({
    Key? key,
    required this.income,
    required this.expense,
    required this.balance,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 24),
      decoration: BoxDecoration(
          color: AppColors.neutral,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(2, 2), // changes position of shadow
            ),
          ]),
      padding: const EdgeInsets.only(left: 24, right: 24, top: 32, bottom: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(text: TextSpan(text: 'Balance', style: TextStyle(color: AppColors.base300, fontSize: 12))),
              RichText(
                  text: TextSpan(
                      text: 'Rp ${amountDoubleToString(balance)}',
                      style: TextStyle(color: AppColors.base100, fontSize: 20, fontWeight: FontWeight.bold))),
            ],
          ),
          Container(
            height: 24,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RichText(
                          text: TextSpan(text: 'Expense', style: TextStyle(color: AppColors.base300, fontSize: 12))),
                      RichText(
                          text: TextSpan(
                              text: 'Rp ${amountDoubleToString(expense)}',
                              style: TextStyle(color: AppColors.base100, fontSize: 14))),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RichText(
                          text: TextSpan(text: 'Income', style: TextStyle(color: AppColors.base300, fontSize: 12))),
                      RichText(
                          text: TextSpan(
                              text: 'Rp ${amountDoubleToString(income)}',
                              style: TextStyle(color: AppColors.base100, fontSize: 14))),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WaveCustomPaint extends CustomPainter {
  Color backgroundColor;
  _WaveCustomPaint({required this.backgroundColor});

  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    Paint paint = Paint();

    var height = size.height / 5;
    var lowestBottom = size.height / 3;

    path = Path();
    path.lineTo(0, height); //start

    var firstStart = Offset(size.width / 2, lowestBottom);
    var firstEnd = Offset(size.width, height);

    path.quadraticBezierTo(firstStart.dx, firstStart.dy, firstEnd.dx, firstEnd.dy);

    path.lineTo(size.width, 0); //end
    path.close();

    paint.color = backgroundColor;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}

String valueToTitle(double value) {
  String yearText = value.toInt().toString();
  String year = yearText.substring(yearText.length - 4);

  int month = value ~/ 10000;
  String monthText = monthIntToString(month);

  String finalString = '$monthText\n$year';

  return finalString;
}

Widget bottomTitleWidgets(double value, TitleMeta meta) {
  String title = valueToTitle(value);

  Widget text = Text(
    title,
    style: const TextStyle(
      fontSize: 12,
    ),
    textAlign: TextAlign.center,
  );

  return SideTitleWidget(
    axisSide: meta.axisSide,
    child: text,
  );
}

Widget leftTitleWidgets(double value, TitleMeta meta) {
  const style = TextStyle(fontSize: 12);

  if (value >= 1000000) {
    return Text('${(value / 1000000).toStringAsFixed(1)}M', style: style, textAlign: TextAlign.left);
  } else if (value >= 1000) {
    return Text('${(value / 1000).toStringAsFixed(0)}K', style: style, textAlign: TextAlign.left);
  } else {
    String text = value.toInt().toString();
    return Text(text, style: style, textAlign: TextAlign.left);
  }
}
