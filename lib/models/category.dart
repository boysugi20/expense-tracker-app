class TransactionCategory{
  int? id;
  String name;

  TransactionCategory({
    this.id,
    required this.name,
  });

  Map<String, Object> toMap(){
    return {'name': name};
  }

  static TransactionCategory fromMap(Map<String, dynamic> map) {
    return TransactionCategory(
      id: map['id'],
      name: map['name'],
    );
  }
}
