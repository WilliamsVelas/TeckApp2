class BankAccount {
  int? id;
  String bankName;
  String numberAccount;
  String code;
  int clientId;
  int createdAt;
  int? updatedAt;
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
      'createdAt': createdAt,
      'updatedAt': updatedAt,
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
      createdAt: map['createdAt'] as int,
      updatedAt: map['updatedAt'] as int?,
      isActive: map['isActive'] == 1,
    );
  }
}