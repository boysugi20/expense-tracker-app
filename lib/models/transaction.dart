import 'package:expense_tracker/models/expenseCategory.dart';
import 'package:expense_tracker/models/incomeCategory.dart';
import 'package:expense_tracker/models/tag.dart';

class Transaction {
  int id;
  double amount;
  DateTime date;
  String? note;
  ExpenseCategory? expenseCategory;
  IncomeCategory? incomeCategory;
  List<Tag>? tags;

  Transaction({
    required this.id,
    required this.date,
    required this.amount,
    this.expenseCategory,
    this.incomeCategory,
    this.note,
    this.tags,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'expenseCategoryId': expenseCategory?.id,
      'incomeCategoryId': incomeCategory?.id,
      'amount': amount,
      'date': date.toIso8601String(),
      'note': note,
      'tags': tags?.map((tag) => tag.toMap()).toList(),
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map,
      {ExpenseCategory? expenseCategory, IncomeCategory? incomeCategory, List<Tag>? tags}) {
    return Transaction(
      id: map['id'],
      amount: map['amount'],
      date: DateTime.parse(map['date']),
      note: map['note'],
      tags: tags,
      expenseCategory: expenseCategory,
      incomeCategory: incomeCategory,
    );
  }

  Transaction copyWith({
    int? id,
    ExpenseCategory? expenseCategory,
    IncomeCategory? incomeCategory,
    DateTime? date,
    double? amount,
    String? note,
    List<Tag>? tags,
  }) {
    return Transaction(
      id: id ?? this.id,
      expenseCategory: expenseCategory ?? this.expenseCategory,
      incomeCategory: incomeCategory ?? this.incomeCategory,
      date: date ?? this.date,
      amount: amount ?? this.amount,
      note: note ?? this.note,
      tags: tags ?? this.tags,
    );
  }
}
