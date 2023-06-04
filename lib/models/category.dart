class ExpenseCategory{
  int id;
  String name;
  String? icon;

  ExpenseCategory({
    required this.id,
    required this.name,
    this.icon,
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
      icon: map['icon']
    );
  }

  ExpenseCategory copyWith({int? id, String? name, String? icon}) {
    return ExpenseCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon
    );
  }
}