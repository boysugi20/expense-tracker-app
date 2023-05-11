import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/styles/color.dart';
import 'package:flutter/material.dart';

import '../components/functions.dart';

class BottomModalCategory extends StatelessWidget {

  final categoryList = TransactionCategory.categoryList();

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
                  for (var i in categoryList) CategoryButton(category: i,),
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

  final TransactionCategory category;

  const CategoryButton({required this.category, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return 
    GestureDetector(
      onTap: (){
        Navigator.pop(context);
        openBottomModalAmmount(context, category);
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
                text: category.name
              ),
            ),
          ),
          CircleAvatar(
              backgroundColor: Colors.grey.shade200,
              radius: 24,
              child: Text(category.name.isNotEmpty ? category.name.split(" ").map((e) => e[0]).take(2).join().toUpperCase() : ""),
          ),
        ],
      ),
    );
  }

}

