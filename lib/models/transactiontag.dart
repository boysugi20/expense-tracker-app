class TransactionTagAssociation {
  int id;
  int transactionId;
  int tagId;

  TransactionTagAssociation({
    required this.id,
    required this.transactionId,
    required this.tagId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'transactionId': transactionId,
      'tagId': tagId,
    };
  }

  factory TransactionTagAssociation.fromMap(Map<String, dynamic> map) {
    return TransactionTagAssociation(
      id: map['id'],
      transactionId: map['transactionId'],
      tagId: map['tagId'],
    );
  }
}
