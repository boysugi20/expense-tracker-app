import 'dart:math';

import 'package:expense_tracker/bloc/goal/goal_bloc.dart';
import 'package:expense_tracker/database/connection.dart';
import 'package:expense_tracker/general/functions.dart';

import 'package:expense_tracker/styles/color.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/general/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardPage extends StatefulWidget {

  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {

  DatabaseHelper db = DatabaseHelper();

  List<FlSpot> chartData = [];

  Future<List<FlSpot>> createDummyData() async {
    List<Map<String, Object?>> monthlyAmounts = await db.accessDatabase('''
      SELECT strftime('%m', date) AS month, SUM(amount) AS totalAmount
      FROM Transactions
      GROUP BY month
      ORDER BY month ASC
    ''');

    chartData = monthlyAmounts.map((row) {
      double x = double.parse(row['month'] as String);
      double y = row['totalAmount'] as double;
      return FlSpot(x, y);
    }).toList();

    return chartData;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 100),
      child: Stack(
        children: [
          CustomPaint(
            painter: _WaveCustomPaint(backgroundColor: AppColors.main),
            size: MediaQuery.of(context).size,
          ),
          Container(
            padding: EdgeInsets.only(left: 32, right: 32, top: MediaQuery.of(context).viewPadding.top + 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: const TextSpan(
                    text: 'Hello,\n',
                    style: TextStyle(color: Colors.white),
                    children: <TextSpan>[
                      TextSpan(text: 'John Doe', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
        
                const BalanceCard(),

                const SectionTitle(text: 'Notifications'),
                
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: const [
                      NotificationCard(),
                      NotificationCard(),
                    ],
                  ),
                ),
      
                const SectionTitle(text: 'Monthly Expense'),

                FutureBuilder<List<FlSpot>>(
                  future: createDummyData(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      chartData = snapshot.data!;
                      if (chartData.isEmpty){
                        return const NoDataWidget(text: 'No Transactions yet');
                      }
                      return ExpenseChart(data: chartData.length > 6 ? chartData.sublist(chartData.length - 6, chartData.length,) : chartData);
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
                
                BlocBuilder<GoalBloc, GoalState>(
                  builder: (context, state) {
                    if (state is GoalInitial) {
                      context.read<GoalBloc>().add(const GetGoals());
                    }
                    if (state is GoalLoaded) {
                      if(state.goal.isNotEmpty){
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SectionTitle(text: 'Goals'),
                            ...state.goal.map((goalItem) => GoalsCard(
                                  title: goalItem.name,
                                  progressAmount: goalItem.progressAmount,
                                  totalAmount: goalItem.totalAmount,
                                  progress: goalItem.totalAmount != 0
                                      ? (goalItem.progressAmount != null ? (goalItem.progressAmount! / goalItem.totalAmount) * 100 : 0)
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
      
                
                const Expenses(text: 'Home', amount: 100000,),
                const Expenses(text: 'Home1', amount: 100000,),
                const Expenses(text: 'Home2', amount: 100000,),
                const Expenses(text: 'Home2', amount: 100000,),
                const Expenses(text: 'Home2', amount: 100000,),
                const Expenses(text: 'Home2', amount: 100000,),
      
              ],
            ),
          ),
        ]
      ),
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
                backgroundColor: AppColors.grey,
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

  ExpenseChart({Key? key,required this.data,}) : super(key: key);

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
              tooltipBgColor: AppColors.white,
              tooltipBorder: BorderSide(color: AppColors.main, width: 1),
              tooltipPadding: const EdgeInsets.all(8),
              tooltipRoundedRadius: 2,
              tooltipMargin: 2,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                TextStyle textStyle = TextStyle(color: AppColors.black);
                return BarTooltipItem(
                  '${monthIntToString(group.x.toInt())}\nRp ${addThousandSeperatorToString((rod.toY).toInt().toString())}',
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
                reservedSize: 30,
                interval: 1,
                getTitlesWidget: bottomTitleWidgets,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: ((maxY+minY)/2) * 0.5,
                getTitlesWidget: leftTitleWidgets,
                reservedSize: 42,
              ),
            ),
          ),
          borderData: FlBorderData(show: false,),
          minY: max(minY - (maxY * 0.25), 0),
          maxY: maxY + (maxY * 0.25),
          barGroups: data.map((item) {
            return BarChartGroupData(
              x: item.x.toInt(),
              barRods: [
                BarChartRodData(
                  toY: item.y,
                  color: AppColors.main,
                  width: 18,
                  borderRadius: BorderRadius.circular(2),
                ),
              ],
            );
          }).toList(),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: ((maxY+minY)/2) * 0.5,
            verticalInterval: 1,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: AppColors.cardBorder,
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
      //           tooltipBgColor: AppColors.white, 
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
      //               colors: [AppColors.main,AppColors.accent].map((color) => color.withOpacity(0.3)).toList(),
      //             ),
      //           ),
      //           gradient: LinearGradient(
      //             colors: [
      //               ColorTween(begin: AppColors.main, end: AppColors.accent).lerp(0.2)!,
      //               ColorTween(begin: AppColors.main, end: AppColors.accent).lerp(0.2)!,
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
      //             color: AppColors.cardBorder,
      //             strokeWidth: 1,
      //           );
      //         },
      //         getDrawingVerticalLine: (value) {
      //           return FlLine(
      //             color: AppColors.cardBorder,
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

  const GoalsCard({required this.title, required this.progress, this.progressAmount, required this.totalAmount, Key? key}) : super(key: key);

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
                  child: Text(title, style: TextStyle(color: AppColors.black)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    progressAmount != null ?
                    Text('${amountDoubleToString(progressAmount!)} / ${amountDoubleToString(totalAmount)} ( ${progress.toInt()}% )', style: TextStyle(color: AppColors.grey, fontSize: 12),) 
                    : 
                    Text('0 / ${amountDoubleToString(totalAmount)} ( 0% )', style: TextStyle(color: AppColors.grey, fontSize: 12),),
                  ]
                ),
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
                      value: progress/100,
                      color: progress >= 100 ? AppColors.green : AppColors.accent,
                      backgroundColor: AppColors.accent.withOpacity(0.2),
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
  final int amount;

  const Expenses({required this.text, required this.amount, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CardContainer(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 12),
                child: CircleAvatar(
                  backgroundColor: Colors.grey.shade200,
                  child: Text(text.isNotEmpty ? text.split(" ").map((e) => e[0]).take(2).join().toUpperCase() : "", style: TextStyle(color: AppColors.main),),
                ),
              ),
              RichText(
                text: TextSpan(
                  text: text,
                  style: const TextStyle(color: Colors.black)
                ),
              ),
            ],
          ),
          RichText(
            text:  TextSpan(
              text: 'Rp ${addThousandSeperatorToString(amount.toString())}',
              style: const TextStyle(color: Colors.red, fontSize: 12)
            ),
          ),
        ],
      ),
    );
  }
}

class BalanceCard extends StatelessWidget {
  const BalanceCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 24),
      decoration: BoxDecoration(
        color: AppColors.neutralDark,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(2, 2), // changes position of shadow
          ),
        ]
      ),
      padding: const EdgeInsets.only(left: 24, right: 24, top: 32, bottom: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(text: TextSpan(text: 'Balance', style: TextStyle(color: AppColors.grey, fontSize: 12))),
              RichText(text: TextSpan(text: 'Rp ${addThousandSeperatorToString(3000000.toString())}', style: TextStyle(color: AppColors.white, fontSize: 20, fontWeight: FontWeight.bold))),
            ],
          ),
          Container(height: 24,),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(text: TextSpan(text: 'Expense', style: TextStyle(color: AppColors.grey, fontSize: 12))),
                    RichText(text: TextSpan(text: 'Rp ${addThousandSeperatorToString(3000000.toString())}', style: TextStyle(color: AppColors.white, fontSize: 14))),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(text: TextSpan(text: 'Income', style: TextStyle(color: AppColors.grey, fontSize: 12))),
                    RichText(text: TextSpan(text: 'Rp ${addThousandSeperatorToString(3000000.toString())}', style: TextStyle(color: AppColors.white, fontSize: 14))),
                  ],
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

    var height = size.height/5;
    var lowestBottom = size.height/3;

    path = Path();
    path.lineTo(0, height); //start
    
    var firstStart = Offset(size.width/2, lowestBottom); 
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

Widget bottomTitleWidgets(double value, TitleMeta meta) {

  String monthText = monthIntToString(value.toInt());
  
  Widget text = Text(monthText, style: const TextStyle(fontSize: 12,));

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