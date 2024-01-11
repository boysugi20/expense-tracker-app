import 'package:sqflite/sqflite.dart' as sql;

class DatabaseHelper {
  static Future<void> createTables(sql.Database db) async {
    await db.execute("""

      CREATE TABLE IF NOT EXISTS ExpenseCategories(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        name TEXT,
        icon TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      );

      """);

    await db.execute("""

      CREATE TABLE IF NOT EXISTS IncomeCategories(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        name TEXT,
        icon TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      );

      """);

    await db.execute("""

      CREATE TABLE IF NOT EXISTS Transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        expenseCategoryId INTEGER,
        incomeCategoryId INTEGER,
        amount REAL,
        date DATETIME,
        note TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (expenseCategoryId) REFERENCES ExpenseCategories(id)
        FOREIGN KEY (incomeCategoryId) REFERENCES IncomeCategories(id)
      );

      """);

    await db.execute("""

      CREATE TABLE IF NOT EXISTS Goals (
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        name TEXT,
        totalAmount REAL,
        progressAmount REAL,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      );

      """);

    await db.execute("""

      CREATE TABLE IF NOT EXISTS Tags (
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        name TEXT,
        color TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      );

      """);

    await db.execute("""

      CREATE TABLE IF NOT EXISTS TransactionTags (
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        transactionId INTEGER,
        tagId INTEGER,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (transactionId) REFERENCES Transactions(id),
        FOREIGN KEY (transactionId) REFERENCES Tags(id)
      );

      """);
  }

  static Future<void> onCreate(sql.Database db) async {
    var batch = db.batch();
    batch.insert(
      'ExpenseCategories',
      {'name': 'Home', 'icon': '{"pack": "material", "key": "home_outlined"}'},
    );
    batch.insert(
      'ExpenseCategories',
      {'name': 'Food', 'icon': '{"pack": "material", "key": "fastfood_outlined"}'},
    );
    batch.insert(
      'ExpenseCategories',
      {'name': 'Groceries', 'icon': '{"pack": "material", "key": "local_grocery_store_outlined"}'},
    );
    batch.insert(
      'ExpenseCategories',
      {'name': 'Transportation', 'icon': '{"pack": "material", "key": "directions_transit_outlined"}'},
    );
    batch.insert(
      'ExpenseCategories',
      {'name': 'Utilities', 'icon': '{"pack": "material", "key": "build_outlined"}'},
    );
    batch.insert(
      'ExpenseCategories',
      {'name': 'Clothing', 'icon': '{"pack": "material", "key": "dry_cleaning_outlined"}'},
    );
    batch.insert(
      'ExpenseCategories',
      {'name': 'Self Care', 'icon': '{"pack": "material", "key": "health_and_safety_outlined"}'},
    );
    batch.insert(
      'ExpenseCategories',
      {'name': 'Entertainment', 'icon': '{"pack": "material", "key": "live_tv_outlined"}'},
    );
    batch.insert(
      'ExpenseCategories',
      {'name': 'Investment', 'icon': '{"pack": "material", "key": "candlestick_chart_outlined"}'},
    );
    batch.insert(
      'ExpenseCategories',
      {'name': 'Other', 'icon': '{"pack": "material", "key": "auto_fix_high_outlined"}'},
    );
    batch.insert(
      'IncomeCategories',
      {'name': 'Salary', 'icon': '{"pack": "material", "key": "attach_money"}'},
    );
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
      onUpgrade: (sql.Database database, int oldVersion, int newVersion) async {
        await createTables(database);
      },
    );
  }

  Future<List<Map<String, Object?>>> accessDatabase(String query) async {
    final database = await initializeDB();
    List<Map<String, Object?>> result = await database.rawQuery(query);

    return result;
  }
}
