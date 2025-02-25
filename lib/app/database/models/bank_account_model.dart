class BankAccount {
  int? id;
  String bankName;
  String numberAccount;
  String code;
  int clientId;
  DateTime createdAt;
  DateTime? updatedAt;
  bool isActive;

  BankAccount({
    this.id,
    required this.bankName,
    required this.numberAccount,
    required this.code,
    required this.clientId,
    required this.createdAt,
    this.updatedAt,
    this.isActive = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bankName': bankName,
      'numberAccount': numberAccount,
      'code': code,
      'clientId': clientId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isActive': isActive ? 1 : 0,
    };
  }

  factory BankAccount.fromMap(Map<String, dynamic> map) {
    return BankAccount(
      id: map['id'] as int?,
      bankName: map['bankName'] as String,
      numberAccount: map['numberAccount'] as String,
      code: map['code'] as String,
      clientId: map['clientId'] as int,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'] as String)
          : null,
      isActive: map['isActive'] == 1,
    );
  }
}