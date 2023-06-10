import 'package:expense_tracker/database/connection.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/models/transaction.dart';
import 'package:sqflite/sqflite.dart' as sql;

// Data Access Object
class TransactionDAO {
  
  static Future<int> insertTransaction(Transaction transaction) async {
    final db = await DatabaseHelper.initializeDB();
    final data = transaction.toMap();
    data.remove('id');
    final id = await db.insert('Transactions', data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Transaction>> getTransactions() async {

    final db = await DatabaseHelper.initializeDB();

    final List<Map<String, Object?>> queryResult = await db.rawQuery("""
        SELECT A.*, B.id as categoryId, B.name as categoryName, B.icon as categoryIcon
        FROM Transactions AS A JOIN ExpenseCategories AS B ON A.ExpenseCategoryId = B.id
        ORDER BY A.date DESC
      """);

    return queryResult.map((e) {
      
      var categoryMap = {'id':e['categoryId'], 'name':e['categoryName'],'icon':e['categoryIcon']};
      final expenseCategory = ExpenseCategory.fromMap(categoryMap);

      return Transaction.fromMap(e, expenseCategory);
    }).toList();
  }

  static Future<int> updateTransaction(Transaction transaction, ExpenseCategory category) async {
    final db = await DatabaseHelper.initializeDB();

    final data = {
      'expenseCategoryId': category.id,
      'date': (transaction.date).toIso8601String(),
      'amount': transaction.amount,
      'note': transaction.note,
      'createdAt': DateTime.now().toIso8601String()
    };
    final result = await db.update('Transactions', data, where: "id = ?", whereArgs: [transaction.id]);
    return result;
  }

  // Delete
  static Future<void> deleteTransaction(Transaction transaction) async {
    final db = await DatabaseHelper.initializeDB();
    await db.delete("Transactions", where: "id = ?", whereArgs: [transaction.id]);
  }



}