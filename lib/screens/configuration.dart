import 'package:expense_tracker/bloc/category/category_bloc.dart';
import 'package:expense_tracker/bloc/goal/goal_bloc.dart';
import 'package:expense_tracker/components/functions.dart';
import 'package:expense_tracker/components/widgets.dart';
import 'package:expense_tracker/forms/categories.dart';
import 'package:expense_tracker/forms/goals.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/models/goal.dart';
import 'package:expense_tracker/styles/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConfigurationPage extends StatefulWidget {
  
  const ConfigurationPage({Key? key}) : super(key: key);

  @override
  State<ConfigurationPage> createState() => _ConfigurationPageState();
}

class _ConfigurationPageState extends State<ConfigurationPage> {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 32, right: 32, top: MediaQuery.of(context).viewPadding.top + 24, bottom: 140),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(text: 'Budget:', firstChild: true,),

          const BudgetCard(amount: 3000000),

          const AddButton(text: 'Add +'),
          
          const SectionTitle(text: 'Goals:'),
          
          BlocBuilder<GoalBloc, GoalState>(
            builder: (context, state) {
              if (state is GoalInitial) {
                context.read<GoalBloc>().add(const GetGoals());
              }
              if (state is GoalLoaded) {
                if(state.goal.isNotEmpty){
                  return Column(
                    children: state.goal.map((goalItem) => GoalsCard(goal: goalItem)).toList(),
                  );
                }
              }
              return const NoDataWidget();
            },
          ),

          AddButton(
            text: 'Add +',
            onPressed: (context) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const GoalsForm(header1: 'Add Goal', header2: 'Add a new goal',)),
              );
            },
          ),

          const SectionTitle(text: 'Categories:'),

          BlocBuilder<CategoryBloc, CategoryState>(
            builder: (context, state) {
              if (state is CategoryInitial) {
                context.read<CategoryBloc>().add(const GetExpenseCategories());
              }
              if (state is CategoryLoaded) {
                if(state.category.isNotEmpty){
                  return Column(
                    children: state.category.map((categoryItem) => CategoriesCard(category: categoryItem)).toList(),
                  );
                }
              }
              return const NoDataWidget();
            },
          ),
          
          AddButton(
            text: 'Add +',
            onPressed: (context) async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CategoriesForm(header1: 'Add Category', header2: 'Add a new category',)),
              );
            },
          ),
        ],
      ),
    );
  }

}

class CategoriesCard extends StatelessWidget {

  final ExpenseCategory category;

  const CategoriesCard({required this.category, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CategoriesForm(header1: 'Edit Category', header2: 'Edit existing category', initialValues: category,)),
        );
      },
      child: CardContainer(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 12),
                  child: CircleAvatar(
                    backgroundColor: Colors.grey.shade200,
                    child: Text(category.name.isNotEmpty ? category.name.split(" ").map((e) => e[0]).take(2).join().toUpperCase() : "", style: TextStyle(color: AppColors.main),),
                  ),
                ),
                RichText(
                  text: TextSpan(
                    text: category.name,
                    style: const TextStyle(color: Colors.black)
                  ),
                ),
              ],
            ),
            // Icon(Icons.edit, color: AppColors.black, size: 16,)
          ],
        ),
      ),
    );
  }
}

class GoalsCard extends StatelessWidget {

  final Goal goal;

  const GoalsCard({required this.goal, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => GoalsForm(header1: 'Edit Goal', header2: 'Edit existing goal', initialValues: goal,)),
        );
      },
      child: CardContainer(
        color: AppColors.main,
        paddingBottom: 16,
        paddingTop: 16,
        marginBottom: 6,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(goal.name, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),),
                Container(height: 8,),
                Text('Rp ${amountDoubleToString(goal.totalAmount)}', style: const TextStyle(color: Colors.white, fontSize: 16),),
              ],
            ),
            // Icon(Icons.edit, color: AppColors.white, size: 16,)
          ],
        ),
      ),
    );
  }
}

class BudgetCard extends StatelessWidget {

  final double amount;

  const BudgetCard({required this.amount, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CardContainer(
      color: AppColors.main,
      paddingBottom: 16,
      paddingTop: 16,
      marginBottom: 6,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Rp ${amountDoubleToString(amount)}', style: const TextStyle(color: Colors.white, fontSize: 18),),
          // Icon(Icons.edit, color: AppColors.white, size: 16,)
        ],
      )
    );
  }
}
