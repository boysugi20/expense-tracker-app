import 'package:expense_tracker/styles/color.dart';
import 'package:flutter/material.dart';

class BottomPopupModal extends StatelessWidget {

  List<String> categories = ['Home','Food','Utility','Transportation','Entertainment','Utility','Others','Food','Utility','Transportation','Entertainment','Utility','Others'];

  BottomPopupModal({super.key,});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 52, bottom: 36),
      decoration: BoxDecoration(
        color: AppColors.neutralDark,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
      ),
      child: Scrollbar(
        child: GridView.count(
          crossAxisCount: 3,
          children: [
            for (var i in categories) 
              CategoryButton(text: i, iconText: 'H'),
          ],
        ),
      ),
    );
  }
}

class CategoryButton extends StatelessWidget {

  final String text, iconText;

  const CategoryButton({required this.text, required this.iconText, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(text, style: TextStyle(color: AppColors.white)),
        ),
        CircleAvatar(
            backgroundColor: Colors.grey.shade200,
            radius: 32,
            child: Text(iconText),
        ),
      ],
    );
  }
}
