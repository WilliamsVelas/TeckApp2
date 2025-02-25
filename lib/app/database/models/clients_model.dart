class Client {
  int? id;
  String name;
  String lastName;
  String businessName;
  String bankAccount;
  String codeBank;
  String affiliateCode;
  String value;
  DateTime createdAt;
  DateTime? updatedAt;
  bool isActive;
  Client({
    this.id,
    required this.name,
    required this.lastName,
    required this.businessName,
    required this.bankAccount,
    required this.codeBank,
    required this.affiliateCode,
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
      'bankAccount': bankAccount,
      'codeBank': codeBank,
      'affiliateCode': affiliateCode,
      'value': value,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isActive': isActive ? 1 : 0,
    };
  }

  factory Client.fromMap(Map<String, dynamic> map) {
    return Client(
      id: map['id'] as int?,
      name: map['name'] as String,
      lastName: map['lastName'] as String,
      businessName: map['businessName'] as String,
      bankAccount: map['bankAccount'] as String,
      codeBank: map['codeBank'] as String,
      affiliateCode: map['affiliateCode'] as String,
      value: map['value'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'] as String)
          : null,
      isActive: map['isActive'] == 1,
    );
  }
}