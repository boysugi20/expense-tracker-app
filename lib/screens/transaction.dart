

import 'package:expense_tracker/styles/color.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';  
import 'package:expense_tracker/components/widgets.dart';

class TransactionPage extends StatelessWidget {
  const TransactionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 32, right: 32, top: MediaQuery.of(context).viewPadding.top + 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(text: 'Subscription:', firstChild: true,),

          const SubscriptionCard(title: 'Netflix', ammount: 75000, startDate: '01 Jan 2023', endDate: '01 Jan 2024',),
          const SubscriptionCard(title: 'Netflix', ammount: 75000, startDate: '01 Jan 2023', endDate: '01 Jan 2024',),

          GestureDetector(
            onTap: (){
              print("Add Subscription");
            },
            child: Center(
              child: RichText(
                text: TextSpan(
                  text: 'Add +',
                  style: TextStyle(color: AppColors.accent)
                ),
              ),
            ),
          ),

          const SectionTitle(text: 'Transaction:'),

          Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: const [
                Text('Range: ', style: TextStyle(color: Colors.black),),
                Text('<dateRangePicker>', style: TextStyle(color: Colors.black),),
              ]
            ),
          ),

          const Transactions(text: 'Food', date: '04 Apr 2023', ammount: 10000,),
          const Transactions(text: 'Food', date: '04 Apr 2023', ammount: 10000,),
          const Transactions(text: 'Food', date: '04 Apr 2023', ammount: 10000,),
          const Transactions(text: 'Food', date: '04 Apr 2023', ammount: 10000, notes: 'Testing notes',),
          const Transactions(text: 'Food', date: '04 Apr 2023', ammount: 10000, notes: 'Testing notes notes notes notes notes notes',),
          const Transactions(text: 'Food', date: '04 Apr 2023', ammount: 10000, notes: 'Testing notes notes',),
          const Transactions(text: 'Food', date: '04 Apr 2023', ammount: 10000, notes: 'Testing notes notes',),
          const Transactions(text: 'Food', date: '04 Apr 2023', ammount: 10000, notes: 'Testing notes notes',),
          const Transactions(text: 'Food', date: '04 Apr 2023', ammount: 10000, notes: 'Testing notes notes',),
          const Transactions(text: 'Food', date: '04 Apr 2023', ammount: 10000, notes: 'Testing notes notes',),
          const Transactions(text: 'Food', date: '04 Apr 2023', ammount: 10000, notes: 'Testing notes notes',),

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
      margin: const EdgeInsets.only(bottom: 6),
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
              GestureDetector(
                onTap: (){
                  print("Edit Subscription");
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Icon(Icons.edit, color: AppColors.white, size: 16,),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class Transactions extends StatelessWidget {

  final String text, date;
  final String? notes;
  final int ammount;

  const Transactions({required this.text, required this.ammount, required this.date, this.notes, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        print("Edit Transaction $text");
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.cardBorder),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          color: AppColors.white
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
                    child: const Text('F'),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: text,
                        style: const TextStyle(color: Colors.black)
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: RichText(
                        text: TextSpan(
                          text: date,
                          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w300, fontSize: 10)
                        ),
                      ),
                    ),
                    (notes != null) 
                    ? Container(
                      margin: const EdgeInsets.only(top: 8),
                      child: RichText(
                        text: TextSpan(
                          text: notes != null && notes!.length > 22 ? '${notes?.substring(0, 22)}...' : notes,
                          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w300, fontSize: 11),
                        ),
                      ),
                    )
                    : Container(),
                  ]
                ),
              ],
            ),
            Row(
              children: [
                RichText(
                  text:  TextSpan(
                    text: 'Rp ${NumberFormat('###,###,###,000').format(ammount)}',
                    style: const TextStyle(color: Colors.red)
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 12),
                  child: const Icon(Icons.edit, size: 14,)
                ),
              ],
            ),
          ],
        ),
    
      ),
    );
  }
}
