import 'package:intl/intl.dart';  

import 'package:expense_tracker/styles/color.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/components/general.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
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
    
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.cardBorder),
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  color: AppColors.white
                ),
                height: 240,
                child: LineChart(
                    LineChartData(
                      // control how the chart looks
                    ),
                    swapAnimationDuration: const Duration(milliseconds: 150), // Optional
                    swapAnimationCurve: Curves.linear, // Optional
                  ),
              ),
    
              const SectionTitle(text: 'Expenses'),
    
              
              const Expenses(text: 'Home', ammount: 100000,),
              const Expenses(text: 'Home1', ammount: 100000,),
              const Expenses(text: 'Home2', ammount: 100000,),
              const Expenses(text: 'Home2', ammount: 100000,),
              const Expenses(text: 'Home2', ammount: 100000,),
              const Expenses(text: 'Home2', ammount: 100000,),
    
            ],
          ),
        ),
      ]
    );
  }
}

class Expenses extends StatelessWidget {

  final String text;
  final int ammount;

  const Expenses({required this.text, required this.ammount, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.only(left: 18, right: 18),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.cardBorder),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        color: AppColors.white
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 12),
                child: CircleAvatar(
                  backgroundColor: Colors.grey.shade200,
                  child: const Text('H'),
                ),
              ),
              RichText(
                text: TextSpan(
                  text: text,
                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
                ),
              ),
            ],
          ),
          RichText(
            text:  TextSpan(
              text: 'Rp ${NumberFormat('###,###,###,000').format(ammount)}',
              style: const TextStyle(color: Colors.red)
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
          RichText(text: const TextSpan(text: 'Balance\n', style: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5), fontSize: 12))),
          RichText(text: const TextSpan(text: 'Rp 3.000.000', style: TextStyle(color: Colors.white, fontSize: 20))),
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
          RichText(text: const TextSpan(text: 'Usage: 1.800.000 / 3.000.000 (75 %)', style: TextStyle(color: Colors.white, fontSize: 12))),
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

