import 'package:expense_tracker/components/functions.dart';
import 'package:expense_tracker/styles/color.dart';
import 'package:flutter/material.dart';

class BottomModalAmmount extends StatelessWidget {

  final String categoryText;

  const BottomModalAmmount({required this.categoryText, Key? key}) : super(key: key);

  static const double boxSize = 64;
  static const double margin = 4;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            color: AppColors.neutralDark,
          ),
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: (){
                  Navigator.pop(context);
                  openBottomModalCategory(context);
              },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 8),
                      child: CircleAvatar(
                        backgroundColor: Colors.grey.shade200,
                        radius: 16,
                        child: Text(categoryText.isNotEmpty ? categoryText.split(" ").map((e) => e[0]).take(2).join().toUpperCase() : ""),
                      ),
                    ),
                    RichText(text: TextSpan(text: categoryText, style: TextStyle(color: AppColors.white))),
                  ],
                ),
              ),
              Divider(
                color: AppColors.white,
                indent: 20,
                endIndent: 20,
                height: 36,
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                child: RichText(text: TextSpan(text: '17 April 2023', style: TextStyle(color: AppColors.white))),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 36),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(8))
                ),
                child: RichText(text: TextSpan(text: '1,000,000', style: TextStyle(color: AppColors.black))),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 24),
                child: RichText(text: TextSpan(text: 'Notes..', style: TextStyle(color: AppColors.white))),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.70,
                    child: Table(
                      children: [
                        TableRow(
                          children: [
                            _buildButton('+'),
                            _buildButton('7'),
                            _buildButton('8'),
                            _buildButton('9'),
                          ],
                        ),
                        TableRow(
                          children: [
                            _buildButton('-'),
                            _buildButton('4'),
                            _buildButton('5'),
                            _buildButton('6'),
                          ],
                        ),
                        TableRow(
                          children: [
                            _buildButton('x'),
                            _buildButton('1'),
                            _buildButton('2'),
                            _buildButton('3'),
                          ],
                        ),
                        TableRow(
                          children: [
                            _buildButton('/'),
                            _buildButton('0'),
                            _buildButton('000'),
                            _buildButton('.'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.18,
                    child: Table(
                      children: [
                        TableRow(
                          children: [
                            _buildIconButton(Icons.backspace),
                          ]
                        ),
                        TableRow(
                          children: [
                            _buildIconButton(Icons.calendar_today),
                          ]
                        ),
                        TableRow(
                          children: [
                            _buildIconButton(Icons.check, height: 2, color: AppColors.accent, iconcolor: AppColors.white),
                          ]
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ]
    );
  }
}

Widget _buildButton(String text) {
  return Container(
    height: 64,
    width: 64,
    margin: const EdgeInsets.all(4),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(4),
    ),
    child: Center(
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 24,
        ),
      ),
    ),
  );
}

Widget _buildIconButton(IconData icon, {double height = 1.0, Color color = Colors.white, Color iconcolor = Colors.black}) {
  return Container(
    height: 64 * height + ((height-1) * 8),
    width: 64,
    margin: const EdgeInsets.all(4),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(4),
    ),
    child: Center(
      child: Icon(
        icon,
        size: 24,
        color: iconcolor,
      ),
    ),
  );
}
