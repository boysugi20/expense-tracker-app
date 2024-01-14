import 'package:expense_tracker/database/connection.dart';
import 'package:expense_tracker/models/goal.dart';
import 'package:sqflite/sqflite.dart' as sql;

// Data Access Object
class GoalDAO {
  // Insert
  static Future<int> insertGoal(Goal goal) async {
    final db = await DatabaseHelper.initializeDB();

    final data = goal.toMap();
    data.remove('id');

    final id = await db.insert('Goals', data, conflictAlgorithm: sql.ConflictAlgorithm.replace);

    return id;
  }

  // Select
  static Future<List<Goal>> getGoals() async {
    final db = await DatabaseHelper.initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('Goals');
    return queryResult.map((e) => Goal.fromMap(e)).toList();
  }

  // Update
  static Future<int> updateGoal(Goal goal) async {
    final db = await DatabaseHelper.initializeDB();

    final data = {
      'name': goal.name,
      'totalAmount': goal.totalAmount,
      'progressAmount': goal.progressAmount,
      'createdAt': DateTime.now().toString()
    };

    final result = await db.update('Goals', data, where: "id = ?", whereArgs: [goal.id]);
    return result;
  }

  // Delete
  static Future<void> deleteGoal(Goal goal) async {
    final db = await DatabaseHelper.initializeDB();
    await db.delete("Goals", where: "id = ?", whereArgs: [goal.id]);
  }
}
