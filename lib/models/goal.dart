class Goal{
  int? id;
  String name;
  double totalAmount;
  double? progressAmount;

  Goal({
    this.id,
    required this.name,
    required this.totalAmount,
    this.progressAmount
  });

  Map<String, Object> toMap(){
    return {
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
}