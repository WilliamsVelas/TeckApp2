class Provider {
  int? id;
  String name;
  String lastName;
  String businessName;
  String value;
  DateTime createdAt;
  DateTime? updatedAt;
  bool isActive;

  Provider({
    this.id,
    required this.name,
    required this.lastName,
    required this.businessName,
    required this.value,
    required this.createdAt,
    this.updatedAt,
    this.isActive = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'lastName': lastName,
      'businessName': businessName,
      'value': value,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isActive': isActive ? 1 : 0,
    };
  }

  factory Provider.fromMap(Map<String, dynamic> map) {
    return Provider(
      id: map['id'] as int?,
      name: map['name'] as String,
      lastName: map['lastName'] as String,
      businessName: map['businessName'] as String,
      value: map['value'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'] as String)
          : null,
      isActive: map['isActive'] == 1,
    );
  }
}