import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:expense_tracker/bloc/transaction/bloc/transaction_bloc.dart';
import 'package:expense_tracker/components/functions.dart';
import 'package:expense_tracker/database/transaction_dao.dart';
import 'package:expense_tracker/forms/subscription.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/styles/color.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/components/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class TransactionPage extends StatelessWidget {


  const TransactionPage({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 32, right: 32, top: MediaQuery.of(context).viewPadding.top + 24, bottom: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(text: 'Subscription:', firstChild: true,),

          const SubscriptionCard(title: 'Netflix', amount: 75000, startDate: '01 Jan 2023', endDate: '01 Jan 2024',),
          const SubscriptionCard(title: 'Netflix', amount: 75000, startDate: '01 Jan 2023', endDate: '01 Jan 2024',),

          AddButton(
            text: 'Add +',
            onPressed: (context) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SubscriptionForm(header1: 'Add Subcription', header2: 'Add a new subscription',)),
              );
            },
          ),

          const TransactionsContainer()
        ],
      ),
    );
  }
}

class TransactionsContainer extends StatefulWidget {

  const TransactionsContainer({super.key,});

  // @override
  // State<TransactionsContainer> createState() => _TransactionsContainerState();
  @override
  TransactionsContainerState createState() => TransactionsContainerState();
}

class TransactionsContainerState extends State<TransactionsContainer> {

  List<Transaction> transactionList = [];
  bool datePicked = false;
  List<DateTime?> selectedDateRange = [DateTime.now().add(const Duration(days: -7)), DateTime.now()];

  void refreshData() async {
    transactionList = await TransactionDAO.getTransactions();
    setState(() {
      transactionList = transactionList;
    });
  }
  
  @override
  void initState() {
    super.initState();
    refreshData();
  }
  
  Future<void> _selectDateRange(BuildContext context) async {

    var results  = await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(
        calendarType: CalendarDatePicker2Type.range,
        selectedDayTextStyle: TextStyle(color: AppColors.white, fontWeight: FontWeight.w700),
        selectedDayHighlightColor: AppColors.accent,
      ),
      dialogSize: const Size(325, 400),
      borderRadius: BorderRadius.circular(15),
      value: selectedDateRange,
    );

    if (results != null && results != selectedDateRange) {
      setState(() {
        selectedDateRange = results;
        datePicked = true;
        _filterTransactions();
      });
    }
  }

  void _filterTransactions() async {
    transactionList = await TransactionDAO.getTransactions();
    List<Transaction> results = [];

    results = transactionList.where((t) {
      final tDate = DateTime(t.date.year, t.date.month, t.date.day);
      final startDate = DateTime(selectedDateRange[0]!.year, selectedDateRange[0]!.month, selectedDateRange[0]!.day);
      final endDate = DateTime(selectedDateRange[1]!.year, selectedDateRange[1]!.month, selectedDateRange[1]!.day);
      return tDate.isAfter(startDate) || tDate.isAtSameMomentAs(startDate) && (tDate.isBefore(endDate) || tDate.isAtSameMomentAs(endDate));
    }).toList();

    setState(() {
      transactionList = results;
    });
  }

  methodInChild() => {print('child')};

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(text: 'Transaction:', useBottomMargin: false,),

        Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  _selectDateRange(context);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.cardBorder),
                    borderRadius: BorderRadius.circular(4),
                    color: AppColors.white,
                  ),
                  child: Row(
                    children: [
                      Text(datePicked? '${DateFormat('dd MMM yyyy').format(selectedDateRange[0]!)} - ${DateFormat('dd MMM yyyy').format(selectedDateRange[1]!)}': 'Pick date range', style: TextStyle(color: AppColors.main, fontSize: 12),),
                      Container(width: 8,),
                      Icon(Icons.calendar_today, color: AppColors.main, size: 12,),
                    ],
                  ),
                ),
              )
            ]
          ),
        ),

        BlocBuilder<TransactionBloc, TransactionState>(
          builder: (context, state) {
            if (state is TransactionInitial) {
              context.read<TransactionBloc>().add(const GetCategories());
            }
            if (state is TransactionLoaded) {
              if(state.transaction.isNotEmpty){
                state.transaction.sort((a, b) => b.date.compareTo(a.date));
                return Column(
                  children: state.transaction.map((transactionItem) => Transactions(category: transactionItem.category, date: transactionItem.date, amount: transactionItem.amount,)).toList(),
                );
              }
            }
            return const NoDataWidget();
          },
        ),
      ],
    );
  }
}

class SubscriptionCard extends StatelessWidget {
  
  final String title, startDate, endDate;
  final int amount;

  const SubscriptionCard({required this.title, required this.startDate, required this.endDate, required this.amount, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CardContainer(
      color: AppColors.main,
      paddingBottom: 18,
      paddingTop: 18,
      paddingLeft: 16,
      paddingRight: 16,
      marginBottom: 6,
      useBorder: false,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
              Container(height: 8,),
              Text('Rp ${addThousandSeperatorToString(amount.toString())}', style: const TextStyle(color: Colors.white, fontSize: 18),),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('Start: $startDate', style: const TextStyle(color: Colors.white, fontSize: 12),),
              Text('End: $endDate', style: const TextStyle(color: Colors.white, fontSize: 12),),
              GestureDetector(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SubscriptionForm(
                      header1: 'Edit Subsciprtion', 
                      header2: 'Edit existing subscription', 
                      initialValues: {'name': title,'price': amount.toString(),}
                    )),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Icon(Icons.edit, color: AppColors.white, size: 14,),
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

  final DateTime date;
  final String? notes;
  final double amount;
  final TransactionCategory category;

  const Transactions({required this.category, required this.amount, required this.date, this.notes, Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
      },
      child: CardContainer(
        marginBottom: 6,
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
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: category.name,
                        style: const TextStyle(color: Colors.black)
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: RichText(
                        text: TextSpan(
                          text: DateFormat('dd MMM yyyy').format(date),
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
            RichText(
              text:  TextSpan(
                text: 'Rp ${amountDoubleToString(amount)}',
                style: const TextStyle(color: Colors.red, fontSize: 12)
              ),
            ),
          ],
        ),
    
      ),
    );
  }
}
