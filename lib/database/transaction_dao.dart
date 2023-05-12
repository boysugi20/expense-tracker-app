import 'package:expense_tracker/database/connection.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/models/transaction.dart';
import 'package:sqflite/sqflite.dart' as sql;

// Data Access Object
class TransactionDAO {
  
  static Future<int> createTransaction(Transaction transaction) async {
    final db = await DatabaseHelper.initializeDB();
    final data = transaction.toMap();
    final id = await db.insert('Transactions', data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Transaction>> getTransactions() async {
    final db = await DatabaseHelper.initializeDB();
    final List<Map<String, Object?>> queryResult = await db.rawQuery("""
        SELECT A.*, B.name as categoryName 
        FROM Transactions AS A JOIN TransactionCategories AS B ON A.categoryId = B.id
        ORDER BY A.date DESC
      """);
    return queryResult.map((e) => Transaction.fromMap(e)).toList();
  }

  static Future<int> updateTransaction(Transaction transaction, TransactionCategory category) async {
    final db = await DatabaseHelper.initializeDB();

    final data = {
      'categoryId': category.id,
      'date': transaction.date,
      'amount': transaction.amount,
      'note': transaction.note,
      'createdAt': DateTime.now().toString()
    };

    final result = await db.update('Transactions', data, where: "id = ?", whereArgs: [transaction.id]);
    return result;
  }

  // Delete
  static Future<void> deleteTransaction(Transaction transaction) async {
    final db = await DatabaseHelper.initializeDB();
    await db.delete("TransactionCategories", where: "id = ?", whereArgs: [transaction.id]);
  }



}