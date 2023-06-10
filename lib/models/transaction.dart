import 'package:expense_tracker/models/category.dart';

class Transaction{

  int id;
  double amount;
  DateTime date;
  String? note;
  ExpenseCategory category;

  Transaction({
    required this.id,
    required this.category,
    required this.date,
    required this.amount,
    this.note
  });

  Map<String, Object?> toMap(){
    return {
      'id': id,
      'expenseCategoryId': category.id,
      'amount': amount,
      'date': date.toIso8601String(),
      'note': note
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map, ExpenseCategory expenseCategory) {
    return Transaction(
      id: map['id'],
      amount: map["amount"],
      date: DateTime.parse(map["date"]),
      note: map["note"],
      category: expenseCategory,
    );
  }

  Transaction copyWith({int? id, ExpenseCategory? category, DateTime? date, double? amount, String? note}) {
    return Transaction(
      id: id ?? this.id,
      category: category ?? this.category,
      date: date ?? this.date,
      amount: amount ?? this.amount,
      note: note ?? this.note,
    );
  }
}