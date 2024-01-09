import 'dart:async';
import 'dart:convert';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:expense_tracker/bloc/category/category_bloc.dart';
import 'package:expense_tracker/bloc/transaction/transaction_bloc.dart';
import 'package:expense_tracker/general/functions.dart';
import 'package:expense_tracker/forms/transaction.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/models/tag.dart';
import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/styles/color.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/general/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconpicker/Serialization/iconDataSerialization.dart';
import 'package:intl/intl.dart';

class TransactionPage extends StatelessWidget {
  const TransactionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 100),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [TransactionsContainer()],
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
  bool datePicked = true;
  List<ExpenseCategory> categories = [];

  List<DateTime?> filterDateRange = [
    DateTime(DateTime.now().year, DateTime.now().month, 1),
    DateTime(DateTime.now().year, DateTime.now().month + 1, 0)
  ];
  String filterDateRangeText = 'This Month';
  String customDateRangeText = 'Custom';

  List<DropdownMenuItem<String>> get dropdownDateRangeItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(value: "All", child: Text("All")),
      const DropdownMenuItem(value: "This Month", child: Text("This Month")),
      const DropdownMenuItem(value: "Last Month", child: Text("Last Month")),
      DropdownMenuItem(value: "Custom", child: Text(customDateRangeText)),
    ];
    return menuItems;
  }

  String filterCategoryName = 'All';

  void setDateRange(String dateRange) {
    DateTime now = DateTime.now();

    if (dateRange == 'This Month') {
      DateTime startOfMonth = DateTime(now.year, now.month, 1);
      DateTime endOfMonth = DateTime(now.year, now.month + 1, 0);
      setState(() {
        filterDateRange = [startOfMonth, endOfMonth];
        datePicked = true;
      });
    } else if (dateRange == 'Last Month') {
      DateTime startOfMonth = DateTime(now.year, now.month - 1, 1);
      DateTime endOfMonth = DateTime(now.year, now.month, 0);
      setState(() {
        filterDateRange = [startOfMonth, endOfMonth];
        datePicked = true;
      });
    } else {
      setState(() {
        datePicked = false;
      });
    }
  }

  Future<void> _selectDateRange(BuildContext context) async {
    var results = await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(
        calendarType: CalendarDatePicker2Type.range,
        selectedDayTextStyle:
            TextStyle(color: AppColors.white, fontWeight: FontWeight.w700),
        selectedDayHighlightColor: AppColors.accent,
      ),
      dialogSize: const Size(325, 400),
      borderRadius: BorderRadius.circular(15),
      value: filterDateRange,
    );

    if (results != null && results.length == 2) {
      setState(() {
        filterDateRange = results;
        datePicked = true;
      });
    } else if (results != null && results.length == 1) {
      setState(() {
        filterDateRange = List.from(results)..addAll(results);
        datePicked = true;
      });
    } else {
      setState(() {
        datePicked = false;
        filterDateRangeText = 'All';
        customDateRangeText = 'Custom';
      });
    }
  }

  List<Transaction> _sortTransactions(List<Transaction> transactionList) {
    List<Transaction> sortedTransactions = [];

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

    if (datePicked) {
      results = transactionList.where((t) {
        final tDate = DateTime(t.date.year, t.date.month, t.date.day);
        final startDate = DateTime(filterDateRange[0]!.year,
            filterDateRange[0]!.month, filterDateRange[0]!.day);
        final endDate = DateTime(filterDateRange[1]!.year,
            filterDateRange[1]!.month, filterDateRange[1]!.day);
        return (tDate.isAfter(startDate) ||
                tDate.isAtSameMomentAs(startDate)) &&
            ((tDate.isBefore(endDate) || tDate.isAtSameMomentAs(endDate)));
      }).toList();
      if (filterCategoryName != 'All') {
        results = results.where((t) {
          return t.category.name == filterCategoryName;
        }).toList();
      }
    } else {
      if (filterCategoryName != 'All') {
        results = transactionList.where((t) {
          return t.category.name == filterCategoryName;
        }).toList();
      } else {
        results = transactionList;
      }
    }
    return results;
  }

  Map<String, List<Transaction>> _groupTransactionsByDate(
      List<Transaction> transactions) {
    final Map<String, List<Transaction>> groupedTransactions = {};

    for (var transaction in transactions) {
      final String date = DateFormat('dd MMM yyyy').format(transaction
          .date); // Replace 'formatDate' with your date formatting logic

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
  void initState() {
    super.initState();
    context.read<TransactionBloc>().add(const GetTransactions());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<TransactionBloc, TransactionState>(
            builder: (context, state) {
          if (state is TransactionInitial) {
            context.read<TransactionBloc>().add(const GetTransactions());
          }
          if (state is TransactionLoaded) {
            if (state.transaction.isEmpty) {
              return Container(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).viewPadding.top + 16,
                      bottom: 16),
                  color: AppColors.main,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                'Total',
                                style: TextStyle(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.bold),
                              )),
                          Text('Rp 0',
                              style: TextStyle(color: AppColors.white)),
                        ],
                      ),
                    ],
                  ));
            }
            final List<Transaction> transactions =
                _sortTransactions(_filterTransactions(state.transaction));
            double totalAmount = 0;
            for (Transaction transaction in transactions) {
              totalAmount += transaction.amount;
            }
            return Container(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).viewPadding.top + 16, bottom: 16),
              color: AppColors.main,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            'Total',
                            style: TextStyle(
                                color: AppColors.white,
                                fontWeight: FontWeight.bold),
                          )),
                      Text('Rp -${amountDoubleToString(totalAmount)}',
                          style: TextStyle(color: AppColors.white)),
                    ],
                  ),
                ],
              ),
            );
          }
          return Text('Rp -', style: TextStyle(color: AppColors.white));
        }),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 8, top: 12),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  BlocBuilder<CategoryBloc, CategoryState>(
                      builder: (context, state) {
                    if (state is CategoryInitial) {
                      context
                          .read<CategoryBloc>()
                          .add(const GetExpenseCategories());
                    }
                    if (state is CategoryLoaded) {
                      // Get list of categories
                      final categories = state.category
                          .map((category) => category.name)
                          .toList();
                      // Add "All" to the list
                      categories.insert(0, "All");
                      // Create DropdownMenuItem from the list
                      final dropdownItems = categories
                          .map((category) => DropdownMenuItem(
                                value: category,
                                child: Text(category),
                              ))
                          .toList();
                      return Container(
                        padding:
                            const EdgeInsets.only(left: 12, top: 3, bottom: 3),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.cardBorder),
                          borderRadius: BorderRadius.circular(4),
                          color: AppColors.white,
                        ),
                        child: DropdownButton(
                          onChanged: (String? newValue) {
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
                  }),
                  Container(
                    padding: const EdgeInsets.only(left: 12, top: 3, bottom: 3),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.cardBorder),
                      borderRadius: BorderRadius.circular(4),
                      color: AppColors.white,
                    ),
                    child: DropdownButton(
                      onChanged: (String? newValue) {
                        if (newValue == 'Custom') {
                          _selectDateRange(context);
                          setState(() {
                            customDateRangeText =
                                '${DateFormat('dd MMM yyyy').format(filterDateRange[0]!)} - ${DateFormat('dd MMM yyyy').format(filterDateRange[1]!)}';
                          });
                        } else {
                          setDateRange(newValue!);
                        }
                        setState(() {
                          filterDateRangeText = newValue!;
                        });
                      },
                      value: filterDateRangeText,
                      items: dropdownDateRangeItems,
                      style: TextStyle(color: AppColors.main, fontSize: 12),
                      underline: const SizedBox(),
                      isDense: true,
                    ),
                  ),
                ]),
              ),
              BlocBuilder<TransactionBloc, TransactionState>(
                builder: (context, state) {
                  if (state is TransactionInitial) {
                    context
                        .read<TransactionBloc>()
                        .add(const GetTransactions());
                  }
                  if (state is TransactionLoaded) {
                    if (state.transaction.isEmpty) {
                      return const NoDataWidget();
                    }

                    final List<Transaction> transactions = _sortTransactions(
                        _filterTransactions(state.transaction));
                    final Map<String, List<Transaction>> groupedTransactions =
                        _groupTransactionsByDate(transactions);

                    if (transactions.isEmpty) {
                      return const NoDataWidget();
                    } else {
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          entry.key,
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.normal,
                                              color: AppColors.grey),
                                        ),
                                        Text(
                                          'Rp ${amountDoubleToString(_calculateTotalAmount(entry.value))}',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.normal,
                                              color: AppColors.grey),
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
                  }

                  return const NoDataWidget();
                },
              )
            ],
          ),
        ),
      ],
    );
  }
}

class TransactionCard extends StatelessWidget {
  final ExpenseCategory category;
  final Transaction transaction;

  const TransactionCard(
      {required this.category, required this.transaction, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => TransactionForm(
                    header1: 'Edit transaction',
                    header2: 'Edit existing transaction',
                    initialValues: transaction,
                  )),
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
                    child: category.icon != null
                        ? Icon(
                            deserializeIcon(jsonDecode(category.icon!)),
                            color: AppColors.main,
                          )
                        : Text(
                            category.name.isNotEmpty
                                ? category.name
                                    .split(" ")
                                    .map((e) => e[0])
                                    .take(2)
                                    .join()
                                    .toUpperCase()
                                : "",
                            style: TextStyle(color: AppColors.main),
                          ),
                  ),
                ),
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                            text: category.name,
                            style: const TextStyle(color: Colors.black)),
                      ),
                      (transaction.note != null && transaction.note!.isNotEmpty)
                          ? Container(
                              margin: const EdgeInsets.only(top: 8),
                              child: RichText(
                                text: TextSpan(
                                  text: transaction.note != null &&
                                          transaction.note!.length > 22
                                      ? '${transaction.note?.substring(0, 22)}...'
                                      : transaction.note,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w300,
                                      fontSize: 11),
                                ),
                              ),
                            )
                          : Container(),
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        child: Row(
                          children: [
                            for (var tag in transaction.tags ??
                                [Tag(id: 0, name: 'nope', color: "#FFFFFF")])
                              Container(
                                margin: const EdgeInsets.only(right: 4),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 2,
                                  horizontal: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: hexToColor(tag.color),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(4),
                                  ),
                                ),
                                child: Text(
                                  tag.name,
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: getTextColorForBackground(
                                          hexToColor(tag.color))),
                                ),
                              ),
                          ],
                        ),
                      )
                    ]),
              ],
            ),
            RichText(
              text: TextSpan(
                  text: 'Rp ${amountDoubleToString(transaction.amount)}',
                  style: const TextStyle(color: Colors.red, fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }
}
