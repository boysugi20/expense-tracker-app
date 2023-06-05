
import 'dart:convert';

import 'package:expense_tracker/bloc/category/category_bloc.dart';
import 'package:expense_tracker/bloc/goal/goal_bloc.dart';
import 'package:expense_tracker/general/widgets.dart';
import 'package:expense_tracker/database/category_dao.dart';
import 'package:expense_tracker/database/goal_dao.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/models/goal.dart';
import 'package:expense_tracker/styles/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconpicker/Serialization/iconDataSerialization.dart';

import '../general/functions.dart';

class BottomModalCategory extends StatefulWidget {

  final Function(int)? changeScreen;
  
  const BottomModalCategory({this.changeScreen, Key? key}) : super(key: key);

  @override
  State<BottomModalCategory> createState() => _BottomModalCategoryState();
}

class _BottomModalCategoryState extends State<BottomModalCategory> with SingleTickerProviderStateMixin {

  List<ExpenseCategory> categoryList = [];
  List<Goal> goalList = [];

  static const List<Tab> myTabs = <Tab>[Tab(text: 'Expense'),Tab(text: 'Goal'),];
  late TabController _tabController;

  void _refreshData() async {
    final data1 = await CategoryDAO.getExpenseCategories();
    final data2 = await GoalDAO.getGoals();
    setState(() {
      categoryList = data1;
      goalList = data2;
    });
  }
  
  @override
  void initState() {
    super.initState();
    _refreshData();
    _tabController = TabController(vsync: this, length: myTabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        color: AppColors.neutralDark,
      ),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 32,
            width: 240,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
                border: Border.all(width: 1, color: AppColors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(width: 2, color: AppColors.accent),
                color: AppColors.accent
              ),
              labelColor: AppColors.white,
              unselectedLabelColor: AppColors.grey,
              tabs: myTabs
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: TabBarView(
              controller: _tabController,
              children: [
                BlocBuilder<CategoryBloc, CategoryState>(
                  builder: (context, state) {
                    if (state is CategoryInitial) {
                      context.read<CategoryBloc>().add(const GetExpenseCategories());
                    }
                    if (state is CategoryLoaded) {
                      if(state.category.isNotEmpty){
                        return GridView.count(
                          padding: const EdgeInsets.all(0),
                          shrinkWrap: true,
                          crossAxisCount: 4,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 1,
                          children: state.category.map((categoryItem) => CategoryButton(category: categoryItem, changeScreen: widget.changeScreen)).toList(),
                        );
                      }
                    }
                    return const NoDataWidget();
                  },
                ),
                BlocBuilder<GoalBloc, GoalState>(
                  builder: (context, state) {
                    if (state is GoalInitial) {
                      context.read<GoalBloc>().add(const GetGoals());
                    }
                    if (state is GoalLoaded) {
                      if(state.goal.isNotEmpty){
                        return GridView.count(
                          padding: const EdgeInsets.all(0),
                          shrinkWrap: true,
                          crossAxisCount: 4,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 1,
                          children: state.goal.map((goalItem) => GoalButton(goal: goalItem, changeScreen: widget.changeScreen)).toList(),
                        );
                      }
                    }
                    return const NoDataWidget();
                  },
                ),
              ]
            ),
          ),
        ],
      )
    );
  }
}

class GoalButton extends StatelessWidget {

  final Goal goal;
  final Function(int)? changeScreen;

  const GoalButton({required this.goal, this.changeScreen, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return 
    GestureDetector(
      onTap: (){
        Navigator.pop(context);
        openBottomModalAmount(context, goal, changeScreen: changeScreen!);
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
                text: goal.name
              ),
            ),
          ),
          CircleAvatar(
              backgroundColor: Colors.grey.shade200,
              radius: 24,
              child: Text(goal.name.isNotEmpty ? goal.name.split(" ").map((e) => e[0]).take(2).join().toUpperCase() : "", style: TextStyle(color: AppColors.main),),
          ),
        ],
      ),
    );
  }
}


class CategoryButton extends StatelessWidget {

  final ExpenseCategory category;
  final Function(int)? changeScreen;

  const CategoryButton({required this.category, this.changeScreen, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return 
    GestureDetector(
      onTap: (){
        Navigator.pop(context);
        openBottomModalAmount(context, category, changeScreen: changeScreen!);
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
              child: category.icon != null ? 
                Icon(deserializeIcon(jsonDecode(category.icon!)), color: AppColors.main,) 
                : 
                Text(category.name.isNotEmpty ? category.name.split(" ").map((e) => e[0]).take(2).join().toUpperCase() : "", style: TextStyle(color: AppColors.main),),
          ),
        ],
      ),
    );
  }

}

