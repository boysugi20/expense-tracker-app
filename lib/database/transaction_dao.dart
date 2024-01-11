import 'package:expense_tracker/database/connection.dart';
import 'package:expense_tracker/models/expenseCategory.dart';
import 'package:expense_tracker/models/incomeCategory.dart';
import 'package:expense_tracker/models/transaction.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:intl/intl.dart';

import '../models/tag.dart';

// Data Access Object
class TransactionDAO {
  static Future<int> insertTransaction(Transaction transaction) async {
    final db = await DatabaseHelper.initializeDB();
    final transactionData = transaction.toMap();
    transactionData.remove('id');

    final List<Map<String, dynamic>> tagsData = transaction.tags!.map((tag) {
      return {
        'transactionId': 0,
        'tagId': tag.id,
        'createdAt': transactionData['createdAt'],
      };
    }).toList();

    transactionData.remove('tags');

    // Insert into Transactions table
    final int transactionId =
        await db.insert('Transactions', transactionData, conflictAlgorithm: sql.ConflictAlgorithm.replace);

    // Update the 'transactionId' field in the tagsData list with the actual transaction ID
    for (var tagData in tagsData) {
      tagData['transactionId'] = transactionId;
    }

    // Insert into TransactionTags table
    for (var tag in tagsData) {
      await db.insert('TransactionTags', tag, conflictAlgorithm: sql.ConflictAlgorithm.replace);
    }

    return transactionId;
  }

  static Future<List<Transaction>> getTransactions() async {
    final db = await DatabaseHelper.initializeDB();

    final List<Map<String, Object?>> queryResult = await db.rawQuery("""
      SELECT 
        A.*, 
        B.id as expenseCategoryId, B.name as expenseCategoryName, B.icon as expenseCategoryIcon, 
        C.id as incomeCategoryId, C.name as incomeCategoryName, C.icon as incomeCategoryIcon, 
        D.id as tagId, D.name as tagName, D.color as tagColor
      FROM Transactions AS A 
        LEFT JOIN ExpenseCategories AS B ON A.ExpenseCategoryId = B.id 
        LEFT JOIN IncomeCategories AS C ON A.IncomeCategoryId = C.id 
        LEFT JOIN TransactionTags AS X ON A.id = X.transactionId
        LEFT JOIN Tags AS D ON D.id = X.tagId
      ORDER BY A.date DESC
    """);

    final Map<int, Transaction> transactionsMap = {};

    for (var e in queryResult) {
      ExpenseCategory? expenseCategory;
      if (e['expenseCategoryId'] != null) {
        var expenseCategoryMap = {
          'id': e['expenseCategoryId'],
          'name': e['expenseCategoryName'],
          'icon': e['expenseCategoryIcon']
        };
        expenseCategory = ExpenseCategory.fromMap(expenseCategoryMap);
      }

      IncomeCategory? incomeCategory;
      if (e['incomeCategoryId'] != null) {
        var incomeCategoryMap = {
          'id': e['incomeCategoryId'],
          'name': e['incomeCategoryName'],
          'icon': e['incomeCategoryIcon']
        };
        incomeCategory = IncomeCategory.fromMap(incomeCategoryMap);
      }

      final transactionId = e['id'] as int;
      final tagId = e['tagId'] as int?;
      final tagName = e['tagName'] as String?;
      final tagColor = e['tagColor'] as String?;

      // Format the date without the time
      final formattedDate = DateFormat('dd MM yyyy').format(DateTime.parse(e['date'] as String));
      final dateWithoutTime = DateFormat('dd MM yyyy').parse(formattedDate);

      // Check if the transaction is already in the map
      if (transactionsMap.containsKey(transactionId)) {
        if (tagId != null && tagName != null && tagColor != null) {
          transactionsMap[transactionId]!.tags!.add(Tag.fromMap({
                'id': tagId,
                'name': tagName,
                'color': tagColor,
              }));
        }
      } else {
        // If not, create a new Transaction object
        final transaction =
            Transaction.fromMap(e, expenseCategory: expenseCategory, incomeCategory: incomeCategory, tags: [
          if (tagId != null && tagName != null && tagColor != null)
            Tag.fromMap({
              'id': tagId,
              'name': tagName,
              'color': tagColor,
            })
        ]);

        transaction.date = dateWithoutTime;
        transactionsMap[transactionId] = transaction;
      }
    }

    return transactionsMap.values.toList();
  }

  static Future<int> updateTransaction(
      Transaction transaction, ExpenseCategory? expenseCategory, IncomeCategory? incomeCategory) async {
    final db = await DatabaseHelper.initializeDB();

    // Prepare the data for the update
    final data = {
      'expenseCategoryId': expenseCategory?.id,
      'incomeCategoryId': incomeCategory?.id,
      'date': transaction.date.toIso8601String(),
      'amount': transaction.amount,
      'note': transaction.note,
      'createdAt': DateTime.now().toIso8601String(),
    };

    // Update the main transaction data
    final result = await db.update('Transactions', data, where: "id = ?", whereArgs: [transaction.id]);

    // Update tags separately
    await _updateTransactionTags(db, transaction);

    return result;
  }

  static Future<void> _updateTransactionTags(db, transaction) async {
    // Delete existing tags for the transaction
    await db.delete('TransactionTags', where: 'transactionId = ?', whereArgs: [transaction.id]);

    // Insert new tags for the transaction
    for (var tag in transaction.tags) {
      await db.insert('TransactionTags', {
        'transactionId': transaction.id,
        'tagId': tag.id,
        'createdAt': DateTime.now().toIso8601String(),
      });
    }
  }

  static Future<void> deleteTransaction(Transaction transaction) async {
    final db = await DatabaseHelper.initializeDB();

    // Delete the main transaction
    await db.delete("Transactions", where: "id = ?", whereArgs: [transaction.id]);

    // Delete the associated tags
    await db.delete("TransactionTags", where: "transactionId = ?", whereArgs: [transaction.id]);
  }
}
