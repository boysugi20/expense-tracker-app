import 'package:expense_tracker/styles/color.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';  
import 'package:expense_tracker/components/general.dart';

class TransactionPage extends StatelessWidget {
  const TransactionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 32, right: 32, top: MediaQuery.of(context).viewPadding.top + 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          SectionTitle(text: 'Subscription:', firstChild: true,),

          SubscriptionCard(title: 'Netflix', ammount: 75000, startDate: '01 Jan 2023', endDate: '01 Jan 2024',),

          SectionTitle(text: 'Transaction:'),
        ],
      ),
    );
  }
}

class SubscriptionCard extends StatelessWidget {
  
  final String title, startDate, endDate;
  final int ammount;

  const SubscriptionCard({required this.title, required this.startDate, required this.endDate, required this.ammount, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: AppColors.main,
        borderRadius: BorderRadius.circular(8)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
              Container(height: 8,),
              Text('Rp ${NumberFormat('###,###,###,000').format(ammount)}', style: const TextStyle(color: Colors.white, fontSize: 18),),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('Start: $startDate', style: const TextStyle(color: Colors.white, fontSize: 12),),
              Text('End: $endDate', style: const TextStyle(color: Colors.white, fontSize: 12),),
            ],
          ),
        ],
      ),
    );
  }
}
