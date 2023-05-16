import 'package:sqflite/sqflite.dart' as sql;

class DatabaseHelper {

  static Future<void> createTables(sql.Database db) async {
    await db.execute("""

      CREATE TABLE ExpenseCategories(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        name TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      );

      """);

    await db.execute("""

      CREATE TABLE Transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        expenseCategoryId INTEGER,
        amount REAL,
        date DATETIME,
        note TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (expenseCategoryId) REFERENCES ExpenseCategories(id)
      );

      """);

    await db.execute("""

      CREATE TABLE Goals (
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        name TEXT,
        totalAmount REAL,
        progressAmount REAL,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      );

      """);
  }

  static Future<void> onCreate(sql.Database db) async {
    var batch = db.batch();
    batch.insert('ExpenseCategories', {'name': 'Home'},);
    batch.insert('ExpenseCategories', {'name': 'Food'},);
    batch.insert('ExpenseCategories', {'name': 'Groceries'},);
    batch.insert('ExpenseCategories', {'name': 'Transportation'},);
    batch.insert('ExpenseCategories', {'name': 'Utilities'},);
    batch.insert('ExpenseCategories', {'name': 'Clothing'},);
    batch.insert('ExpenseCategories', {'name': 'Self Care'},);
    batch.insert('ExpenseCategories', {'name': 'Entertainment'},);
    batch.insert('ExpenseCategories', {'name': 'Investment'},);
    batch.insert('ExpenseCategories', {'name': 'Other'},);
    await batch.commit();
    
    final tables = await db.rawQuery('SELECT * FROM sqlite_master ORDER BY name;');
    print(tables);
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

  Future<List<Map<String, Object?>>> accessDatabase(String query) async {
    final database = await initializeDB();
    List<Map<String, Object?>> result = await database.rawQuery(query);

    return result;
  }

}

  // // Get a single item by id
  // //We dont use this method, it is for you if you want it.
  // static Future<List<Map<String, dynamic>>> getItem(int id) async {
  //   final db = await DatabaseHelper.initializeDB();
  //   return db.query('items', where: "id = ?", whereArgs: [id], limit: 1);
  // }

  // // Update an item by id
  // static Future<int> updateExpenseCategory(
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