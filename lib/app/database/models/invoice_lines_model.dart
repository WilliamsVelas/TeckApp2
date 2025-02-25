class InvoiceLine {
  int? id;
  String productName;
  double productPrice;
  double refProductPrice;
  double total;
  double? refTotal;
  int productId;
  String productSerial;
  int invoiceId;
  DateTime createdAt;
  DateTime? updatedAt;
  bool isActive; // Nuevo campo

  InvoiceLine({
    this.id,
    required this.productName,
    required this.productPrice,
    required this.refProductPrice,
    required this.total,
    this.refTotal,
    required this.productId,
    required this.productSerial,
    required this.invoiceId,
    required this.createdAt,
    this.updatedAt,
    this.isActive = true, // Valor por defecto
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productName': productName,
      'productPrice': productPrice,
      'refProductPrice': refProductPrice,
      'total': total,
      'refTotal': refTotal,
      'productId': productId,
      'productSerial': productSerial,
      'invoiceId': invoiceId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isActive': isActive ? 1 : 0, // Convertir bool a INTEGER
    };
  }

  factory InvoiceLine.fromMap(Map<String, dynamic> map) {
    return InvoiceLine(
      id: map['id'] as int?,
      productName: map['productName'] as String,
      productPrice: map['productPrice'] as double,
      refProductPrice: map['refProductPrice'] as double,
      total: map['total'] as double,
      refTotal: map['refTotal'] as double?,
      productId: map['productId'] as int,
      productSerial: map['productSerial'] as String,
      invoiceId: map['invoiceId'] as int,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'] as String)
          : null,
      isActive: map['isActive'] == 1, // Convertir INTEGER a bool
    );
  }
}
