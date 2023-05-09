import 'package:expense_tracker/components/widgets.dart';
import 'package:expense_tracker/styles/color.dart';
import 'package:flutter/material.dart';

class ConfigurationPage extends StatelessWidget {
  const ConfigurationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 32, right: 32, top: MediaQuery.of(context).viewPadding.top + 24, bottom: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          SectionTitle(text: 'Budget:', firstChild: true,),

          BudgetCard(ammount: 3000000),

          AddButton(text: 'Add +'),
          
          SectionTitle(text: 'Goals:'),

          GoalsCard(title: 'Iphone XX', ammount: 16000000,),

          AddButton(text: 'Add +'),

          SectionTitle(text: 'Categories:'),

          CategoriesCard(title: 'Home',),
          CategoriesCard(title: 'Food',),
          CategoriesCard(title: 'Transportation',),
        ],
      ),
    );
  }
}

class CategoriesCard extends StatelessWidget {

  final String title;

  const CategoriesCard({required this.title, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.cardBorder),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 12),
                child: CircleAvatar(
                  backgroundColor: Colors.grey.shade200,
                  child: Text(title.isNotEmpty ? title.split(" ").map((e) => e[0]).take(2).join().toUpperCase() : ""),
                ),
              ),
              RichText(
                text: TextSpan(
                  text: title,
                  style: const TextStyle(color: Colors.black)
                ),
              ),
            ],
          ),
          Icon(Icons.edit, color: AppColors.black, size: 16,)
        ],
      ),
    );
  }
}

class GoalsCard extends StatelessWidget {

  final String title;
  final int ammount;

  const GoalsCard({required this.ammount, required this.title, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.main,
        borderRadius: BorderRadius.circular(8)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),),
              Container(height: 8,),
              Text('Rp ${ammount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}', style: const TextStyle(color: Colors.white, fontSize: 16),),
            ],
          ),
          Icon(Icons.edit, color: AppColors.white, size: 16,)
        ],
      ),
    );
  }
}

class BudgetCard extends StatelessWidget {

  final int ammount;

  const BudgetCard({required this.ammount, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.main,
        borderRadius: BorderRadius.circular(8)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Rp ${ammount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}', style: const TextStyle(color: Colors.white, fontSize: 18),),
          Icon(Icons.edit, color: AppColors.white, size: 16,)
        ],
      )
    );
  }
}
