class TransactionCategory{
  String id;
  String name;

  TransactionCategory({
    required this.id,
    required this.name,
  });

  static List<TransactionCategory> categoryList() {
    return [
      TransactionCategory(id: '1', name: 'Home'),
      TransactionCategory(id: '2', name: 'Transportation'),
      TransactionCategory(id: '3', name: 'Food'),
      TransactionCategory(id: '4', name: 'Utility'),
      TransactionCategory(id: '5', name: 'Entertainment'),
      TransactionCategory(id: '6', name: 'Self Care'),
      TransactionCategory(id: '7', name: 'Others'),
    ];
  }
}
