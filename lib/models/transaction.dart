import 'package:expense_tracker/models/category.dart';

class Transaction{

  String id;
  double ammount;
  DateTime date;
  String? categoryText, note;
  TransactionCategory category;

  Transaction({
    required this.id,
    required this.category,
    required this.date,
    required this.ammount,
    this.note
  });

  static List<Transaction> transactionList() {
    return [
      Transaction(id: '01', category: TransactionCategory(name: 'Home', id: '1'), date: DateTime(2023,1,1), ammount: 100000, note: 'testing notes'),
      Transaction(id: '02', category: TransactionCategory(name: 'Others', id: '2'), date: DateTime(2023,1,1), ammount: 120000, note: 'testing notes'),
      Transaction(id: '03', category: TransactionCategory(name: 'Home', id: '1'), date: DateTime(2023,1,1), ammount: 100000, note: 'testing notes'),
      Transaction(id: '04', category: TransactionCategory(name: 'Home', id: '1'), date: DateTime(2023,1,1), ammount: 100000, note: 'testing notes'),
      Transaction(id: '02', category: TransactionCategory(name: 'Home', id: '1'), date: DateTime(2023,1,1), ammount: 100000, note: 'testing notes'),
      Transaction(id: '03', category: TransactionCategory(name: 'Home', id: '1'), date: DateTime(2023,1,1), ammount: 100000, note: 'testing notes'),
      Transaction(id: '04', category: TransactionCategory(name: 'Home', id: '1'), date: DateTime(2023,1,1), ammount: 100000, note: 'testing notes'),
      Transaction(id: '02', category: TransactionCategory(name: 'Home', id: '1'), date: DateTime(2023,1,1), ammount: 100000, note: 'testing notes'),
      Transaction(id: '03', category: TransactionCategory(name: 'Home', id: '1'), date: DateTime(2023,1,1), ammount: 100000, note: 'testing notes'),
      Transaction(id: '04', category: TransactionCategory(name: 'Home', id: '1'), date: DateTime(2023,1,1), ammount: 100000, note: 'testing notes'),
    ];
  }
}