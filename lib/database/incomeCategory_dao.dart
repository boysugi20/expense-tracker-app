import 'package:expense_tracker/database/connection.dart';
import 'package:expense_tracker/models/incomeCategory.dart';
import 'package:sqflite/sqflite.dart' as sql;

// Data Access Object
class IncomeCategoryDAO {
  // Insert
  static Future<int> insertIncomeCategory(IncomeCategory category) async {
    final db = await DatabaseHelper.initializeDB();
    final data = category.toMap();
    data.remove('id');
    final id = await db.insert('IncomeCategories', data, conflictAlgorithm: sql.ConflictAlgorithm.replace);

    return id;
  }

  // Select
  static Future<List<IncomeCategory>> getIncomeCategories() async {
    final db = await DatabaseHelper.initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('IncomeCategories');
    return queryResult.map((e) => IncomeCategory.fromMap(e)).toList();
  }

  static Future<List<IncomeCategory>> getIncomeCategoryIDbyName(String name) async {
    final db = await DatabaseHelper.initializeDB();
    final List<Map<String, Object?>> queryResult =
        await db.query('IncomeCategories', where: "name = ?", whereArgs: [name]);
    return queryResult.map((e) => IncomeCategory.fromMap(e)).toList();
  }

  static Future<List<IncomeCategory>> getIncomeCategorybyID(int id) async {
    final db = await DatabaseHelper.initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('IncomeCategories', where: "id = ?", whereArgs: [id]);
    return queryResult.map((e) => IncomeCategory.fromMap(e)).toList();
  }

  // Update
  static Future<int> updateIncomeCategory(IncomeCategory category) async {
    final db = await DatabaseHelper.initializeDB();

    final data = {'name': category.name, 'icon': category.icon, 'createdAt': DateTime.now().toString()};

    final result = await db.update('IncomeCategories', data, where: "id = ?", whereArgs: [category.id]);
    return result;
  }

  // Delete
  static Future<void> deleteIncomeCategory(IncomeCategory category) async {
    final db = await DatabaseHelper.initializeDB();
    await db.delete("IncomeCategories", where: "id = ?", whereArgs: [category.id]);
  }
}
