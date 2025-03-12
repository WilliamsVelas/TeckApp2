class Invoice {
  int? id;
  String documentNo;
  String type;
  double totalAmount;
  double totalPayed;
  double? refTotalAmount;
  double? refTotalPayed;
  int clientId;
  int createdAt;
  int? updatedAt;
  bool isActive;

  Invoice({
    this.id,
    required this.documentNo,
    required this.type,
    required this.totalAmount,
    required this.totalPayed,
    this.refTotalAmount,
    this.refTotalPayed,
    required this.clientId,
    required this.createdAt,
    this.updatedAt,
    this.isActive = true,
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
      'clientId': clientId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'isActive': isActive ? 1 : 0,
    };
  }

  factory Invoice.fromMap(Map<String, dynamic> map) {
    return Invoice(
      id: map['id'] as int?,
      documentNo: map['documentNo'] as String,
      type: map['type'] as String,
      totalAmount: map['totalAmount'] as double,
      totalPayed: map['totalPayed'] as double,
      refTotalAmount: map['refTotalAmount'] as double?,
      refTotalPayed: map['refTotalPayed'] as double?,
      clientId: map['clientId'] as int,
      createdAt: map['createdAt'] as int,
      updatedAt: map['updatedAt'] as int?,
      isActive: map['isActive'] == 1,
    );
  }
}