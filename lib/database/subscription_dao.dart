import 'package:expense_tracker/database/connection.dart';
import 'package:expense_tracker/models/subscription.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:workmanager/workmanager.dart';

void scheduleSubscriptionReminder(uniqueName, Subscription subscription) {
  Workmanager().cancelByUniqueName(uniqueName);
  Workmanager().registerPeriodicTask(
    uniqueName,
    'subscription_reminder',
    inputData: <String, dynamic>{
      'name': subscription.name,
      'startDate': subscription.startDate.toIso8601String(),
      'endDate': subscription.endDate.toIso8601String(),
      'paymentDate': subscription.paymentDay,
    },
    frequency: const Duration(hours: 6),
  );
}

// Data Access Object
class SubscriptionDAO {
  // Insert
  static Future<int> insertSubscription(Subscription subscription) async {
    final db = await DatabaseHelper.initializeDB();

    final data = subscription.toMap();
    data.remove('id');

    final id = await db.insert('Subscriptions', data, conflictAlgorithm: sql.ConflictAlgorithm.replace);

    final uniqueName = 'subscription_$id';
    scheduleSubscriptionReminder(uniqueName, subscription);

    return id;
  }

  // Select
  static Future<List<Subscription>> getSubscriptions() async {
    final db = await DatabaseHelper.initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('Subscriptions');
    return queryResult.map((e) => Subscription.fromMap(e)).toList();
  }

  // Update
  static Future<int> updateSubscription(Subscription subscription) async {
    final db = await DatabaseHelper.initializeDB();

    final data = {
      'name': subscription.name,
      'amount': subscription.amount,
      'startDate': subscription.startDate.toIso8601String(),
      'endDate': subscription.endDate.toIso8601String(),
      'createdAt': DateTime.now().toIso8601String(),
      'paymentDay': subscription.paymentDay,
    };

    final result = await db.update('Subscriptions', data, where: "id = ?", whereArgs: [subscription.id]);

    final uniqueName = 'subscription_${subscription.id}';
    scheduleSubscriptionReminder(uniqueName, subscription);

    return result;
  }

  // Delete
  static Future<void> deleteSubscription(Subscription subscription) async {
    final db = await DatabaseHelper.initializeDB();
    await db.delete("Subscriptions", where: "id = ?", whereArgs: [subscription.id]);
  }
}
