class PaymentMethod {
  int? id;
  String name;
  String code;
  int createdAt;
  int? updatedAt;
  bool isActive;

  PaymentMethod({
    this.id,
    required this.name,
    required this.code,
    required this.createdAt,
    this.updatedAt,
    this.isActive = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'isActive': isActive ? 1 : 0,
    };
  }

  factory PaymentMethod.fromMap(Map<String, dynamic> map) {
    return PaymentMethod(
      id: map['id'] as int?,
      name: map['name'] as String,
      code: map['code'] as String,
      createdAt: map['createdAt'] as int,
      updatedAt: map['updatedAt'] as int?,
      isActive: map['isActive'] == 1,
    );
  }
}