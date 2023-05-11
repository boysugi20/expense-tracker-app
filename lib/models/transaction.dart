import 'package:expense_tracker/models/category.dart';

class Transaction{

  int? id;
  double amount;
  DateTime date;
  String? note;
  TransactionCategory category;

  Transaction({
    this.id,
    required this.category,
    required this.date,
    required this.amount,
    this.note
  });

  Map<String, Object?> toMap(){
    return {
      'categoryId': category.id,
      'amount': amount,
      'date': date.toIso8601String(),
      'note': note
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      amount: map["amount"],
      date: DateTime.parse(map["date"]),
      note: map["note"],
      category: TransactionCategory(name: map['categoryName']),
    );
  }
}