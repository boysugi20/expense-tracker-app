import 'package:expense_tracker/database/connection.dart';
import 'package:expense_tracker/models/expenseCategory.dart';
import 'package:sqflite/sqflite.dart' as sql;

// Data Access Object
class ExpenseCategoryDAO {
  // Insert
  static Future<int> insertExpenseCategory(ExpenseCategory category) async {
    final db = await DatabaseHelper.initializeDB();
    final data = category.toMap();
    data.remove('id');
    final id = await db.insert('ExpenseCategories', data, conflictAlgorithm: sql.ConflictAlgorithm.replace);

    return id;
  }

  // Select
  static Future<List<ExpenseCategory>> getExpenseCategories() async {
    final db = await DatabaseHelper.initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('ExpenseCategories');
    return queryResult.map((e) => ExpenseCategory.fromMap(e)).toList();
  }

  static Future<List<ExpenseCategory>> getExpenseCategoryIDbyName(String name) async {
    final db = await DatabaseHelper.initializeDB();
    final List<Map<String, Object?>> queryResult =
        await db.query('ExpenseCategories', where: "name = ?", whereArgs: [name]);
    return queryResult.map((e) => ExpenseCategory.fromMap(e)).toList();
  }

  static Future<List<ExpenseCategory>> getExpenseCategorybyID(int id) async {
    final db = await DatabaseHelper.initializeDB();
    final List<Map<String, Object?>> queryResult =
        await db.query('ExpenseCategories', where: "id = ?", whereArgs: [id]);
    return queryResult.map((e) => ExpenseCategory.fromMap(e)).toList();
  }

  // Update
  static Future<int> updateExpenseCategory(ExpenseCategory category) async {
    final db = await DatabaseHelper.initializeDB();

    final data = {'name': category.name, 'icon': category.icon, 'createdAt': DateTime.now().toString()};

    final result = await db.update('ExpenseCategories', data, where: "id = ?", whereArgs: [category.id]);
    return result;
  }

  // Delete
  static Future<void> deleteExpenseCategory(ExpenseCategory category) async {
    final db = await DatabaseHelper.initializeDB();
    await db.delete("ExpenseCategories", where: "id = ?", whereArgs: [category.id]);
  }
}
