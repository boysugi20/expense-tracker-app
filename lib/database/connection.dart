import 'package:sqflite/sqflite.dart' as sql;

class DatabaseHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""

      CREATE TABLE TransactionCategories(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        name TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      );

      """);

    await database.execute("""

      CREATE TABLE Transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        categoryId INTEGER,
        amount REAL,
        date DATETIME,
        note TEXT,
        FOREIGN KEY (categoryId) REFERENCES TransactionCategories(id)
      );

      """);
  }

  static Future<void> onCreate(sql.Database db) async {
    var batch = db.batch();
    batch.insert('TransactionCategories', {'name': 'Home'},);
    batch.insert('TransactionCategories', {'name': 'Food'},);
    batch.insert('TransactionCategories', {'name': 'Groceries'},);
    batch.insert('TransactionCategories', {'name': 'Transportation'},);
    batch.insert('TransactionCategories', {'name': 'Utilities'},);
    batch.insert('TransactionCategories', {'name': 'Clothing'},);
    batch.insert('TransactionCategories', {'name': 'Self Care'},);
    batch.insert('TransactionCategories', {'name': 'Entertainment'},);
    batch.insert('TransactionCategories', {'name': 'Investment'},);
    batch.insert('TransactionCategories', {'name': 'Other'},);
    await batch.commit();
  }

  static Future<sql.Database> initializeDB() async {
    return sql.openDatabase(
      'database.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
        await onCreate(database);
      },
    );
  }

  // // Get a single item by id
  // //We dont use this method, it is for you if you want it.
  // static Future<List<Map<String, dynamic>>> getItem(int id) async {
  //   final db = await DatabaseHelper.initializeDB();
  //   return db.query('items', where: "id = ?", whereArgs: [id], limit: 1);
  // }

  // // Update an item by id
  // static Future<int> updateCategory(
  //     int id, String title, String? descrption) async {
  //   final db = await DatabaseHelper.initializeDB();

  //   final data = {
  //     'title': title,
  //     'description': descrption,
  //     'createdAt': DateTime.now().toString()
  //   };

  //   final result =
  //       await db.update('items', data, where: "id = ?", whereArgs: [id]);
  //   return result;
  // }

  // // Delete
  // static Future<void> deleteItem(int id) async {
  //   final db = await DatabaseHelper.initializeDB();
  //   try {
  //     await db.delete("items", where: "id = ?", whereArgs: [id]);
  //   } catch (err) {
  //     debugPrint("Something went wrong when deleting an item: $err");
  //   }
  // }
}