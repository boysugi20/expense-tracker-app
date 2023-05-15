
import 'package:expense_tracker/database/connection.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:sqflite/sqflite.dart' as sql;

// Data Access Object
class CategoryDAO {


  // Insert
  static Future<int> insertExpenseCategory(ExpenseCategory category) async {
    final db = await DatabaseHelper.initializeDB();

    final data = category.toMap();
    final id = await db.insert('ExpenseCategories', data, conflictAlgorithm: sql.ConflictAlgorithm.replace);

    return id;
  }

  // Select
  static Future<List<ExpenseCategory>> getExpenseCategories() async {
    final db = await DatabaseHelper.initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('ExpenseCategories');
    return queryResult.map((e) => ExpenseCategory.fromMap(e)).toList();
  }

  // Update
  static Future<int> updateExpenseCategory(ExpenseCategory category) async {
    final db = await DatabaseHelper.initializeDB();

    final data = {
      'name': category.name,
      'createdAt': DateTime.now().toString()
    };

    final result = await db.update('ExpenseCategories', data, where: "id = ?", whereArgs: [category.id]);
    return result;
  }

  // Delete
  static Future<void> deleteExpenseCategory(ExpenseCategory category) async {
    final db = await DatabaseHelper.initializeDB();
    await db.delete("ExpenseCategories", where: "id = ?", whereArgs: [category.id]);
  }

}