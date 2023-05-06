import 'package:expense_tracker/styles/color.dart';
import 'package:flutter/material.dart';

class BottomModalCategory extends StatelessWidget {

  final List<String> categories = ['Home','Food','Utility','Entertainment','Utility','Others','Food','Utility','Transportation','Entertainment','Utility','Others'];

  BottomModalCategory({super.key,});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 12,
            color: AppColors.neutralDark,
          ),
          Stack(
            children: [
              Container(
                height: 10,
                color: AppColors.neutralDark,
              ),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(6)),
                    color: Colors.white.withOpacity(0.7),
                  ),
                  height: 4,
                  width: 64,
                ),
              ),
            ]
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 24),
              decoration: BoxDecoration(
                color: AppColors.neutralDark,
                border: Border.all(color: AppColors.neutralDark)
              ),
              child: NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (overscroll) {
                  overscroll.disallowIndicator();
                  return true;
                },
                child: GridView.count(
                  mainAxisSpacing: 16,
                  crossAxisCount: 4,
                  children: [
                    for (var i in categories) 
                      CategoryButton(text: i, iconText: 'H'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BottomModalAmmount extends StatelessWidget {

  const BottomModalAmmount({Key? key}) : super(key: key);

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
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 24),
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

class CategoryButton extends StatelessWidget {

  final String text, iconText;

  const CategoryButton({required this.text, required this.iconText, Key? key}) : super(key: key);
  
  void openBottomModalAmmount(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return const BottomModalAmmount();
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return 
    GestureDetector(
      onTap: (){
        print("Clicked category $text");
        Navigator.pop(context);
        openBottomModalAmmount(context);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: RichText(
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                style: const TextStyle(color: Colors.white, fontSize: 12),
                text: text
              ),
            ),
          ),
          CircleAvatar(
              backgroundColor: Colors.grey.shade200,
              radius: 24,
              child: Text(iconText),
          ),
        ],
      ),
    );
  }

}

