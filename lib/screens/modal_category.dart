import 'package:expense_tracker/styles/color.dart';
import 'package:flutter/material.dart';

import '../components/functions.dart';

class BottomModalCategory extends StatelessWidget {

  final List<String> categories = ['Home','Food','Utility','Entertainment','Utility','Others','Food','Utility','Transportation','Entertainment','Utility','Others'];

  BottomModalCategory({super.key,});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            color: AppColors.neutralDark,
          ),
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
          child: Column(
            children: [
              GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                crossAxisCount: 4,
                mainAxisSpacing: 8,
                crossAxisSpacing: 1,
                children: [
                  for (var i in categories) CategoryButton(text: i),
                ],
              ),
            ],
          )
        ),
      ]
    );
  }
}


class CategoryButton extends StatelessWidget {

  final String text;

  const CategoryButton({required this.text, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return 
    GestureDetector(
      onTap: (){
        print("Clicked category $text");
        Navigator.pop(context);
        openBottomModalAmmount(context, text);
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
              child: Text(text.isNotEmpty ? text.split(" ").map((e) => e[0]).take(2).join().toUpperCase() : ""),
          ),
        ],
      ),
    );
  }

}

