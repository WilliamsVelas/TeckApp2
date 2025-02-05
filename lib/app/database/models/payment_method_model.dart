class PaymentMethod {
  int? id;
  String? name;
  String? code;
  double? amount;
  DateTime createdAt;
  DateTime? updatedAt;

  PaymentMethod({
    this.id,
    this.name,
    this.code,
    this.amount,
    required this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'amount': amount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory PaymentMethod.fromMap(Map<String, dynamic> map) {
    return PaymentMethod(
      id: map['id'] as int?,
      name: map['name'] as String?,
      code: map['code'] as String?,
      amount: map['amount'] as double?,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'] as String)
          : null,
    );
  }
}