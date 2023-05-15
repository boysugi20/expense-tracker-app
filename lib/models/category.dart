class ExpenseCategory{
  int id;
  String name;

  ExpenseCategory({
    required this.id,
    required this.name,
  });

  Map<String, Object> toMap(){
    return {
      'id': id,
      'name': name
    };
  }

  static ExpenseCategory fromMap(Map<String, dynamic> map) {
    return ExpenseCategory(
      id: map['id'],
      name: map['name'],
    );
  }

  ExpenseCategory copyWith({int? id, String? name}) {
    return ExpenseCategory(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}