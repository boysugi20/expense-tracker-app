import 'package:expense_tracker/database/category_dao.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/styles/color.dart';
import 'package:flutter/material.dart';

import '../components/functions.dart';

class BottomModalCategory extends StatefulWidget {

  final Function(int)? changeScreen;
  
  const BottomModalCategory({this.changeScreen, Key? key}) : super(key: key);

  @override
  State<BottomModalCategory> createState() => _BottomModalCategoryState();
}

class _BottomModalCategoryState extends State<BottomModalCategory> {

  List<TransactionCategory> categoryList = [];

  void _refreshData() async {
    final data = await CategoryDAO.getCategories();
    setState(() {
      categoryList = data;
    });
  }
  
  @override
  void initState() {
    super.initState();
    _refreshData();
  }

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
                  for (var i in categoryList) CategoryButton(category: i, changeScreen: widget.changeScreen),
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
  final Function(int)? changeScreen;

  const CategoryButton({required this.category, this.changeScreen, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return 
    GestureDetector(
      onTap: (){
        Navigator.pop(context);
        openBottomModalamount(context, category, changeScreen!);
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
              child: Text(category.name.isNotEmpty ? category.name.split(" ").map((e) => e[0]).take(2).join().toUpperCase() : "", style: TextStyle(color: AppColors.main),),
          ),
        ],
      ),
    );
  }

}

