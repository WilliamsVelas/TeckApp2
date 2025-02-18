class Invoice {
  int? id;
  String documentNo;
  String type;
  double totalAmount;
  double totalPayed;
  double? refTotalAmount;
  double? refTotalPayed;
  int qty;
  int clientId;
  int bankAccountId;
  int productId;
  DateTime createdAt;
  DateTime? updatedAt;

  Invoice({
    this.id,
    required this.documentNo,
    required this.type,
    required this.totalAmount,
    required this.totalPayed,
    this.refTotalAmount,
    required this.refTotalPayed,
    required this.qty,
    required this.clientId,
    required this.bankAccountId,
    required this.productId,
    required this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'documentNo': documentNo,
      'type': type,
      'totalAmount': totalAmount,
      'totalPayed': totalPayed,
      'refTotalAmount': refTotalAmount,
      'refTotalPayed': refTotalPayed,
      'qty': qty,
      'clientId': clientId,
      'bankAccountId': bankAccountId,
      'productId': productId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory Invoice.fromMap(Map<String, dynamic> map) {
    return Invoice(
      id: map['id'] as int?,
      documentNo: map['documentNo'] as String,
      type: map['type'] as String,
      totalAmount: map['totalAmount'] as double,
      totalPayed: map['totalPayed'] as double,
      refTotalAmount: map['refTotalAmount'] as double,
      refTotalPayed: map['refTotalPayed'] as double,
      qty: map['qty'] as int,
      clientId: map['clientId'] as int,
      bankAccountId: map['bankAccountId'] as int,
      productId: map['productId'] as int,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'] as String)
          : null,
    );
  }
}