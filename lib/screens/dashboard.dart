import 'package:expense_tracker/bloc/goal/goal_bloc.dart';
import 'package:expense_tracker/components/functions.dart';

import 'package:expense_tracker/styles/color.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/components/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardPage extends StatelessWidget {

  const DashboardPage({Key? key}) : super(key: key);

  final List<FlSpot> dummyData = const [
    FlSpot(1, 2500000),
    FlSpot(2, 1700000),
    FlSpot(3, 2300000),
    FlSpot(4, 2200000),
    FlSpot(5, 2400000),
    FlSpot(6, 3000000),
    FlSpot(7, 2300000),
  ];

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
      
                const SectionTitle(text: 'Monthly Expense'),
      
                ExpenseChart(data: dummyData),

                const SectionTitle(text: 'Goals'),

                // const GoalsCard(title: 'Iphone XX', progress: 75),
                // const GoalsCard(title: 'Ipad XX', progress: 100),
                
                BlocBuilder<GoalBloc, GoalState>(
                  builder: (context, state) {
                    if (state is GoalInitial) {
                      context.read<GoalBloc>().add(const GetGoals());
                    }
                    if (state is GoalLoaded) {
                      if(state.goal.isNotEmpty){
                        return Column(
                          children: state.goal.map((goalItem) => GoalsCard(
                            title: goalItem.name,
                            progressAmount: goalItem.progressAmount,
                            totalAmount: goalItem.totalAmount,
                            progress: goalItem.progressAmount != null ? (goalItem.progressAmount! / goalItem.totalAmount) * 100 : 0,
                          )).toList(),
                        );
                      }
                    }
                    return const NoDataWidget();
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
      child: LineChart(
          LineChartData(
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                tooltipBgColor: AppColors.white, 
                tooltipBorder: BorderSide(color: AppColors.accent, width: 2),
                getTooltipItems: (List<LineBarSpot> touchedSpots) {
                  TextStyle tooltipStyle = TextStyle(color: AppColors.accent);
                  return touchedSpots.map((LineBarSpot touchedSpot) {
                    return LineTooltipItem(
                      '${monthIntToString((touchedSpot.x).toInt())}\nRp ${addThousandSeperatorToString((touchedSpot.y).toInt().toString())}',
                      tooltipStyle,
                    );
                  }).toList();
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
                  interval: maxY * 0.25,
                  getTitlesWidget: leftTitleWidgets,
                  reservedSize: 42,
                ),
              ),
            ),
            borderData: FlBorderData(
              show: false,
              border: Border.all(color: const Color(0xff37434d)),
            ),
            // minX: 0,
            // maxX: 11,
            minY: minY - (maxY * 0.25),
            maxY: maxY + (maxY * 0.25),
            lineBarsData: [
              LineChartBarData(
                curveSmoothness: 0.3,
                dotData: FlDotData(show: false,),
                spots: data,
                isCurved: true,
                barWidth: 1,
                isStrokeCapRound: true,
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    colors: [AppColors.main,AppColors.accent].map((color) => color.withOpacity(0.3)).toList(),
                  ),
                ),
                gradient: LinearGradient(
                  colors: [
                    ColorTween(begin: AppColors.main, end: AppColors.accent).lerp(0.2)!,
                    ColorTween(begin: AppColors.main, end: AppColors.accent).lerp(0.2)!,
                  ],
                ),
              ),
            ],
            gridData: FlGridData(
              show: true,
              drawVerticalLine: true,
              horizontalInterval: maxY * 0.25,
              verticalInterval: 1,
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: AppColors.cardBorder,
                  strokeWidth: 1,
                );
              },
              getDrawingVerticalLine: (value) {
                return FlLine(
                  color: AppColors.cardBorder,
                  strokeWidth: 1,
                );
              },
            ),
          ),
          swapAnimationDuration: const Duration(milliseconds: 150), // Optional
          swapAnimationCurve: Curves.linear, // Optional
        ),
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
    return CardContainer(
      paddingTop: 16,
      paddingBottom: 16,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 4, 
            child: Text(title, style: TextStyle(color: AppColors.black)),
          ),
          Expanded(
            flex: 6,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Stack(
                        children: [
                          Container(
                            height: 8,
                            width: 100,
                            decoration: BoxDecoration(
                              border: progress >= 100 ? Border.all(color: AppColors.green) : Border.all(color: AppColors.accent),
                              borderRadius: const BorderRadius.all(Radius.circular(8)),
                              color: AppColors.white
                            ),
                          ),
                          Container(
                            height: 8,
                            width: progress >= 100 ? 100 : progress,
                            color: progress >= 100 ? AppColors.green : AppColors.accent,
                          ),
                        ]
                      ),
                    ),
                    SizedBox(
                      width: 50,
                      child: Text('${progress.toInt()} %', style: TextStyle(color: AppColors.black), textAlign: TextAlign.right,)
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      progressAmount != null ?
                      Text('${amountDoubleToString(progressAmount!)} / ${amountDoubleToString(totalAmount)}', style: TextStyle(color: AppColors.grey, fontSize: 12),) : Text('0 / ${amountDoubleToString(totalAmount)}', style: TextStyle(color: AppColors.grey, fontSize: 12),),
                    ]
                  ),
                )
              ],
            ),
          ),
        ],
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
      margin: const EdgeInsets.only(top: 32),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(text: TextSpan(text: 'Balance\n', style: TextStyle(color: AppColors.grey, fontSize: 12))),
          RichText(text: TextSpan(text: 'Rp ${addThousandSeperatorToString(3000000.toString())}', style: TextStyle(color: AppColors.white, fontSize: 20))),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                Container(
                  height: 8,
                  margin: const EdgeInsets.only(top: 32, bottom: 32),
                  color: AppColors.neutralLight,
                ),
                Container(
                  height: 8,
                  width: 90,
                  margin: const EdgeInsets.only(top: 32, bottom: 32),
                  color: AppColors.accent,
                ),
              ]
            ),
          ),
          RichText(text: TextSpan(text: 'Usage: ${addThousandSeperatorToString(1800000.toString())} / ${addThousandSeperatorToString(3000000.toString())} (75%)', style: const TextStyle(color: Colors.white, fontSize: 12))),
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