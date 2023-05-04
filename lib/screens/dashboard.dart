import 'package:expense_tracker/styles/color.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomPaint(
          painter: _WaveCustomPaint(backgroundColor: AppColors.dark),
          size: Size.infinite,
        ),
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
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
      
              Container(height: 32,),
      
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.only(left: 24, right: 24, top: 32, bottom: 32),
                  color: AppColors.darkest,
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
                              color: AppColors.white,
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
                ),
              )
            ],
          ),
        ),
      ]
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

    var height = size.height/4;
    var lowestBottom = size.height/2;

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

