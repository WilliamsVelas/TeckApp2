class Provider {
  int? id;
  String name;
  String lastName;
  String businessName;
  String value;
  int createdAt;
  int? updatedAt;
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
      'createdAt': createdAt,
      'updatedAt': updatedAt,
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
      createdAt: map['createdAt'] as int,
      updatedAt: map['updatedAt'] as int?,
      isActive: map['isActive'] == 1,
    );
  }
}