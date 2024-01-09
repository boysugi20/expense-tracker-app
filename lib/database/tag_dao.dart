import 'package:expense_tracker/database/connection.dart';
import 'package:expense_tracker/models/tag.dart';
import 'package:sqflite/sqflite.dart' as sql;

// Data Access Object
class TagDAO {
  // Insert
  static Future<int> insertTag(Tag tag) async {
    final db = await DatabaseHelper.initializeDB();

    final data = tag.toMap();
    data.remove('id');
    final id = await db.insert('Tags', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Select
  static Future<List<Tag>> getTags() async {
    final db = await DatabaseHelper.initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('Tags');
    return queryResult.map((e) => Tag.fromMap(e)).toList();
  }

  // Update
  static Future<int> updateTag(Tag tag) async {
    final db = await DatabaseHelper.initializeDB();

    final data = {
      'id': tag.id,
      'name': tag.name,
      'color': tag.color,
    };

    final result =
        await db.update('Tags', data, where: "id = ?", whereArgs: [tag.id]);
    return result;
  }

  // Delete
  static Future<void> deleteTag(Tag tag) async {
    final db = await DatabaseHelper.initializeDB();
    await db.delete("Tags", where: "id = ?", whereArgs: [tag.id]);
  }
}
