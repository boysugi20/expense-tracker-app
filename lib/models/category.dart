class ExpenseCategory{
  int? id;
  String name;

  ExpenseCategory({
    this.id,
    required this.name,
  });

  Map<String, Object> toMap(){
    return {'name': name};
  }

  static ExpenseCategory fromMap(Map<String, dynamic> map) {
    return ExpenseCategory(
      id: map['id'],
      name: map['name'],
    );
  }
}