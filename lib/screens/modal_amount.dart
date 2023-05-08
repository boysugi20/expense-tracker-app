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
                child: RichText(text: TextSpan(text: '1.000.000', style: TextStyle(color: AppColors.black))),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 24),
                child: RichText(text: TextSpan(text: 'Notes..', style: TextStyle(color: AppColors.white))),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.all(margin),
                    height: boxSize,
                    width: boxSize,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(4))
                    ),
                    child: Center(child: RichText(text: TextSpan(text: '+', style: TextStyle(color: AppColors.black, fontSize: 24)),)),
                  ),
                  Container(
                    margin: const EdgeInsets.all(margin),
                    height: boxSize,
                    width: boxSize,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(4))
                    ),
                    child: Center(child: RichText(text: TextSpan(text: '7', style: TextStyle(color: AppColors.black, fontSize: 24)),)),
                  ),
                  Container(
                    margin: const EdgeInsets.all(margin),
                    height: boxSize,
                    width: boxSize,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(4))
                    ),
                    child: Center(child: RichText(text: TextSpan(text: '8', style: TextStyle(color: AppColors.black, fontSize: 24)),)),
                  ),
                  Container(
                    margin: const EdgeInsets.all(margin),
                    height: boxSize,
                    width: boxSize,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(4))
                    ),
                    child: Center(child: RichText(text: TextSpan(text: '9', style: TextStyle(color: AppColors.black, fontSize: 24)),)),
                  ),
                  Container(
                    margin: const EdgeInsets.all(margin),
                    height: boxSize,
                    width: boxSize,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(4))
                    ),
                    child: const Center(child: Icon(Icons.backspace)),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.all(margin),
                    height: boxSize,
                    width: boxSize,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(4))
                    ),
                    child: Center(child: RichText(text: TextSpan(text: '-', style: TextStyle(color: AppColors.black, fontSize: 24)),)),
                  ),
                  Container(
                    margin: const EdgeInsets.all(margin),
                    height: boxSize,
                    width: boxSize,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(4))
                    ),
                    child: Center(child: RichText(text: TextSpan(text: '4', style: TextStyle(color: AppColors.black, fontSize: 24)),)),
                  ),
                  Container(
                    margin: const EdgeInsets.all(margin),
                    height: boxSize,
                    width: boxSize,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(4))
                    ),
                    child: Center(child: RichText(text: TextSpan(text: '5', style: TextStyle(color: AppColors.black, fontSize: 24)),)),
                  ),
                  Container(
                    margin: const EdgeInsets.all(margin),
                    height: boxSize,
                    width: boxSize,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(4))
                    ),
                    child: Center(child: RichText(text: TextSpan(text: '6', style: TextStyle(color: AppColors.black, fontSize: 24)),)),
                  ),
                  Container(
                    margin: const EdgeInsets.all(margin),
                    height: boxSize,
                    width: boxSize,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(4))
                    ),
                    child: const Center(child: Icon(Icons.calendar_today)),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.all(margin),
                    height: boxSize,
                    width: boxSize,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(4))
                    ),
                    child: Center(child: RichText(text: TextSpan(text: 'x', style: TextStyle(color: AppColors.black, fontSize: 24)),)),
                  ),
                  Container(
                    margin: const EdgeInsets.all(margin),
                    height: boxSize,
                    width: boxSize,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(4))
                    ),
                    child: Center(child: RichText(text: TextSpan(text: '1', style: TextStyle(color: AppColors.black, fontSize: 24)),)),
                  ),
                  Container(
                    margin: const EdgeInsets.all(margin),
                    height: boxSize,
                    width: boxSize,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(4))
                    ),
                    child: Center(child: RichText(text: TextSpan(text: '2', style: TextStyle(color: AppColors.black, fontSize: 24)),)),
                  ),
                  Container(
                    margin: const EdgeInsets.all(margin),
                    height: boxSize,
                    width: boxSize,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(4))
                    ),
                    child: Center(child: RichText(text: TextSpan(text: '3', style: TextStyle(color: AppColors.black, fontSize: 24)),)),
                  ),
                  Container(
                    margin: const EdgeInsets.all(margin),
                    height: boxSize,
                    width: boxSize,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(4))
                    ),
                    child: Center(child: RichText(text: TextSpan(text: '=', style: TextStyle(color: AppColors.black, fontSize: 24)),)),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.all(margin),
                    height: boxSize,
                    width: boxSize,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(4))
                    ),
                    child: Center(child: RichText(text: TextSpan(text: '/', style: TextStyle(color: AppColors.black, fontSize: 24)),)),
                  ),
                  Container(
                    margin: const EdgeInsets.all(margin),
                    height: boxSize,
                    width: boxSize,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(4))
                    ),
                    child: Center(child: RichText(text: TextSpan(text: '0', style: TextStyle(color: AppColors.black, fontSize: 24)),)),
                  ),
                  Container(
                    margin: const EdgeInsets.all(margin),
                    height: boxSize,
                    width: boxSize,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(4))
                    ),
                    child: Center(child: RichText(text: TextSpan(text: '000', style: TextStyle(color: AppColors.black, fontSize: 24)),)),
                  ),
                  Container(
                    margin: const EdgeInsets.all(margin),
                    height: boxSize,
                    width: boxSize,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(4))
                    ),
                    child: Center(child: RichText(text: TextSpan(text: '.', style: TextStyle(color: AppColors.black, fontSize: 24)),)),
                  ),
                  Container(
                    margin: const EdgeInsets.all(margin),
                    height: boxSize,
                    width: boxSize,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(4))
                    ),
                    child: Center(child: RichText(text: TextSpan(text: '=', style: TextStyle(color: AppColors.black, fontSize: 24)),)),
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
