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
  DateTime createdAt;
  DateTime? updatedAt;
  bool isActive; // Nuevo campo

  Invoice({
    this.id,
    required this.documentNo,
    required this.type,
    required this.totalAmount,
    required this.totalPayed,
    this.refTotalAmount,
    this.refTotalPayed,
    required this.qty,
    required this.clientId,
    required this.createdAt,
    this.updatedAt,
    this.isActive = true, // Valor por defecto
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
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isActive': isActive ? 1 : 0, // Convertir bool a INTEGER
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
      qty: map['qty'] as int,
      clientId: map['clientId'] as int,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'] as String)
          : null,
      isActive: map['isActive'] == 1, // Convertir INTEGER a bool
    );
  }
}