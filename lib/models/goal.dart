class Goal{
  int id;
  String name;
  double totalAmount;
  double? progressAmount;

  Goal({
    required this.id,
    required this.name,
    required this.totalAmount,
    this.progressAmount
  });

  Map<String, Object> toMap(){
    return {
      'id': id,
      'name': name,
      'totalAmount': totalAmount,
    };
  }

  static Goal fromMap(Map<String, dynamic> map) {
    return Goal(
      id: map['id'],
      name: map['name'],
      totalAmount: map['totalAmount'],
      progressAmount: map['progressAmount']
    );
  }

  Goal copyWith({int? id, String? name, double? totalAmount, double? progressAmount}) {
    return Goal(
      id: id ?? this.id,
      name: name ?? this.name,
      totalAmount: totalAmount ?? this.totalAmount,
      progressAmount: progressAmount ?? this.progressAmount,
    );
  }
}