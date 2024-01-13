class Subscription {
  int id;
  String name;
  double amount;
  DateTime startDate;
  DateTime endDate;

  Subscription({
    required this.id,
    required this.name,
    required this.amount,
    required this.startDate,
    required this.endDate,
  });

  Map<String, Object> toMap() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
    };
  }

  static Subscription fromMap(Map<String, dynamic> map) {
    return Subscription(
      id: map['id'],
      name: map['name'],
      amount: map['amount'],
      startDate: DateTime.parse(map['startDate']),
      endDate: DateTime.parse(map['endDate']),
    );
  }

  Subscription copyWith({int? id, String? name, double? amount, DateTime? startDate, DateTime? endDate}) {
    return Subscription(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}
