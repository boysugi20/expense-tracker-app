
import 'package:expense_tracker/database/connection.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:sqflite/sqflite.dart' as sql;

// Data Access Object
class CategoryDAO {


  // Insert
  static Future<int> createCategory(TransactionCategory category) async {
    final db = await DatabaseHelper.initializeDB();

    final data = category.toMap();
    final id = await db.insert('TransactionCategories', data, conflictAlgorithm: sql.ConflictAlgorithm.replace);

    return id;
  }

  // Select
  static Future<List<TransactionCategory>> getCategories() async {
    final db = await DatabaseHelper.initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('TransactionCategories');
    return queryResult.map((e) => TransactionCategory.fromMap(e)).toList();
  }

  // Update
  static Future<int> updateCategory(TransactionCategory category) async {
    final db = await DatabaseHelper.initializeDB();

    final data = {
      'name': category.name,
      'createdAt': DateTime.now().toString()
    };

    final result = await db.update('TransactionCategories', data, where: "id = ?", whereArgs: [category.id]);
    return result;
  }

  // Delete
  static Future<void> deleteCategory(TransactionCategory category) async {
    final db = await DatabaseHelper.initializeDB();
    await db.delete("TransactionCategories", where: "id = ?", whereArgs: [category.id]);
  }

}