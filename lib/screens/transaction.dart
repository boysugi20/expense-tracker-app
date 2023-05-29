import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:expense_tracker/bloc/category/category_bloc.dart';
import 'package:expense_tracker/bloc/transaction/bloc/transaction_bloc.dart';
import 'package:expense_tracker/general/functions.dart';
import 'package:expense_tracker/forms/transaction.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/styles/color.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/general/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class TransactionPage extends StatelessWidget {

  const TransactionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 32, right: 32, top: MediaQuery.of(context).viewPadding.top + 24, bottom: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          TransactionsContainer()
        ],
      ),
    );
  }
}

class TransactionsContainer extends StatefulWidget {

  const TransactionsContainer({Key? key}) : super(key: key);

  @override
  TransactionsContainerState createState() => TransactionsContainerState();
}

class TransactionsContainerState extends State<TransactionsContainer> {

  bool datePicked = false;
  List<ExpenseCategory> categories = [];
  
  List<DateTime?> filterDateRange = [DateTime.now().add(const Duration(days: -7)), DateTime.now()];
  String filterCategoryName = 'All';
  
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
      value: filterDateRange,
    );

    if (results != null && results != filterDateRange && results.length == 2) {
      setState(() {
        filterDateRange = results;
        datePicked = true;
      });
    }else if (results != null && results.length == 1){
      setState(() {
        filterDateRange = List.from(results)..addAll(results);
        datePicked = true;
      });
    }
    else{
      setState(() {
        datePicked = false;
      });
    }
  }

  List<Transaction> _sortTransactions(List<Transaction> transactionList) {

    List<Transaction> sortedTransactions = [];

    // final sortedTransactions = transactionList.toList()..sort((a, b) => b.date.compareTo(a.date));
    sortedTransactions = List.from(transactionList)
      ..sort((a, b) {
        final dateComparison = b.date.compareTo(a.date);
        if (dateComparison != 0) {
          return dateComparison;
        }
        return b.id.compareTo(a.id);
      });
    return sortedTransactions;
  }

  List<Transaction> _filterTransactions(List<Transaction> transactionList) {

    List<Transaction> results = [];

    if(datePicked){
      results = transactionList.where((t) {
        final tDate = DateTime(t.date.year, t.date.month, t.date.day);
        final startDate = DateTime(filterDateRange[0]!.year, filterDateRange[0]!.month, filterDateRange[0]!.day);
        final endDate = DateTime(filterDateRange[1]!.year, filterDateRange[1]!.month, filterDateRange[1]!.day);
        return (tDate.isAfter(startDate) || tDate.isAtSameMomentAs(startDate)) && ((tDate.isBefore(endDate) || tDate.isAtSameMomentAs(endDate)));
      }).toList();
      if(filterCategoryName != 'All'){
        results = results.where((t) {
          return t.category.name == filterCategoryName;
        }).toList();
      }
    }else{
      if(filterCategoryName != 'All'){
        results = transactionList.where((t) {
          return t.category.name == filterCategoryName;
        }).toList();
      }else{
        results = transactionList;
      }
    }

    return results;
  }

  Map<String, List<Transaction>> _groupTransactionsByDate(List<Transaction> transactions) {
    final Map<String, List<Transaction>> groupedTransactions = {};

    for (var transaction in transactions) {
      final String date = DateFormat('dd MMM yyyy').format(transaction.date); // Replace 'formatDate' with your date formatting logic

      if (groupedTransactions.containsKey(date)) {
        groupedTransactions[date]!.add(transaction);
      } else {
        groupedTransactions[date] = [transaction];
      }
    }

    return groupedTransactions;
  }

  double _calculateTotalAmount(List<Transaction> transactions) {
    double total = 0.0;
    for (final transaction in transactions) {
      total += transaction.amount;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(text: 'Transaction:', useBottomMargin: false, firstChild: true,),

        Container(
          margin: const EdgeInsets.only(bottom: 8, top: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [

              BlocBuilder<CategoryBloc, CategoryState>(
                builder: (context, state) {
                  if (state is CategoryInitial) {
                    context.read<CategoryBloc>().add(const GetExpenseCategories());
                  }
                  if (state is CategoryLoaded) {
                    // Get list of categories
                    final categories = state.category.map((category) => category.name).toList();
                    // Add "All" to the list
                    categories.insert(0, "All");
                    // Create DropdownMenuItem from the list
                    final dropdownItems = categories.map((category) => DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    )).toList();
                    return Container(
                      padding: const EdgeInsets.only(left: 12, top: 3, bottom: 3),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.cardBorder),
                        borderRadius: BorderRadius.circular(4),
                        color: AppColors.white,
                      ),
                      child: DropdownButton(
                        onChanged: (String? newValue){
                          setState(() {
                            filterCategoryName = newValue!;
                          });
                        },
                        value: filterCategoryName,
                        items: dropdownItems,
                        style: TextStyle(color: AppColors.main, fontSize: 12),
                        underline: const SizedBox(),
                        isDense: true,
                      ),
                    );
                  }
                  return const NoDataWidget();
                }
              ),

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
                      Text(datePicked? '${DateFormat('dd MMM yyyy').format(filterDateRange[0]!)} - ${DateFormat('dd MMM yyyy').format(filterDateRange[1]!)}': 'Pick date range', style: TextStyle(color: AppColors.main, fontSize: 12),),
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
              context.read<TransactionBloc>().add(const GetTransactions());
            }
            if (state is TransactionLoaded) {
              if (state.transaction.isEmpty) {
                return const NoDataWidget();
              }

              final List<Transaction> transactions = _sortTransactions(_filterTransactions(state.transaction));
              final Map<String, List<Transaction>> groupedTransactions = _groupTransactionsByDate(transactions);

              return SingleChildScrollView(
                child: Column(
                  children: [
                    for (final entry in groupedTransactions.entries)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  entry.key,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                    color: AppColors.grey
                                  ),
                                ),
                                Text(
                                  'Rp ${amountDoubleToString(_calculateTotalAmount(entry.value))}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                    color: AppColors.grey
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              for (final transaction in entry.value)
                                TransactionCard(
                                  category: transaction.category,
                                  transaction: transaction,
                                ),
                            ],
                          ),
                        ],
                      ),
                  ],
                ),
              );
            }

            return const NoDataWidget();
          },
        )
      ],
    );
  }
}

class TransactionCard extends StatelessWidget {

  final ExpenseCategory category;
  final Transaction transaction;

  const TransactionCard({required this.category, required this.transaction, Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TransactionForm(header1: 'Edit transaction', header2: 'Edit existing transaction', initialValues: transaction,)),
        );
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
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 2),
                    //   child: RichText(
                    //     text: TextSpan(
                    //       text: DateFormat('dd MMM yyyy').format(transaction.date),
                    //       style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w300, fontSize: 8)
                    //     ),
                    //   ),
                    // ),
                    (transaction.note != null && transaction.note!.isNotEmpty) 
                    ? Container(
                      margin: const EdgeInsets.only(top: 8),
                      child: RichText(
                        text: TextSpan(
                          text: transaction.note != null && transaction.note!.length > 22 ? '${transaction.note?.substring(0, 22)}...' : transaction.note,
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
                text: 'Rp ${amountDoubleToString(transaction.amount)}',
                style: const TextStyle(color: Colors.red, fontSize: 12)
              ),
            ),
          ],
        ),
    
      ),
    );
  }
}
