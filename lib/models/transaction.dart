import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/models/tag.dart';

class Transaction {
  int id;
  double amount;
  DateTime date;
  String? note;
  ExpenseCategory category;
  List<Tag>? tags;

  Transaction({
    required this.id,
    required this.category,
    required this.date,
    required this.amount,
    this.note,
    this.tags,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'expenseCategoryId': category.id,
      'amount': amount,
      'date': date.toIso8601String(),
      'note': note,
      'tags': tags?.map((tag) => tag.toMap()).toList(),
    };
  }

  factory Transaction.fromMap(
      Map<String, dynamic> map, ExpenseCategory expenseCategory,
      {List<Tag>? tags}) {
    return Transaction(
      id: map['id'],
      amount: map['amount'],
      date: DateTime.parse(map['date']),
      note: map['note'],
      tags: tags,
      category: expenseCategory,
    );
  }

  Transaction copyWith({
    int? id,
    ExpenseCategory? category,
    DateTime? date,
    double? amount,
    String? note,
    List<Tag>? tags,
  }) {
    return Transaction(
      id: id ?? this.id,
      category: category ?? this.category,
      date: date ?? this.date,
      amount: amount ?? this.amount,
      note: note ?? this.note,
      tags: tags ?? this.tags,
    );
  }
}
