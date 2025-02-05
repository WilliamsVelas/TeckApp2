class BankAccount {
  int? id;
  String? bankName;
  String? numberAccount;
  String? code;
  int? clientId;
  DateTime createdAt;
  DateTime? updatedAt;

  BankAccount({
    this.id,
    this.bankName,
    this.numberAccount,
    this.code,
    this.clientId,
    required this.createdAt,
    this.updatedAt,
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
    };
  }

  factory BankAccount.fromMap(Map<String, dynamic> map) {
    return BankAccount(
      id: map['id'] as int?,
      bankName: map['bankName'] as String?,
      numberAccount: map['numberAccount'] as String?,
      code: map['code'] as String?,
      clientId: map['clientId'] as int?,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'] as String)
          : null,
    );
  }
}