class Tag {
  int id;
  String name;
  String color;

  Tag({
    required this.id,
    required this.name,
    required this.color,
  });

  Map<String, Object> toMap() {
    return {
      'id': id,
      'name': name,
      'color': color,
    };
  }

  static Tag fromMap(Map<String, dynamic> map) {
    return Tag(
      id: map['id'],
      name: map['name'],
      color: map['color'],
    );
  }

  Tag copyWith({int? id, String? name, String? color}) {
    return Tag(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
    );
  }
}
