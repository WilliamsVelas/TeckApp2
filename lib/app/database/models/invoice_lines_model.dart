class InvoiceLine {
  int? id;
  String productName;
  double productPrice;
  double refProductPrice;
  double total;
  double? refTotal;
  int qty;
  int productId;
  String productSerial;
  int invoiceId;
  int createdAt;
  int? updatedAt;
  bool isActive;

  InvoiceLine({
    this.id,
    required this.productName,
    required this.productPrice,
    required this.refProductPrice,
    required this.total,
    this.refTotal,
    required this.qty,
    required this.productId,
    required this.productSerial,
    required this.invoiceId,
    required this.createdAt,
    this.updatedAt,
    this.isActive = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productName': productName,
      'productPrice': productPrice,
      'refProductPrice': refProductPrice,
      'total': total,
      'refTotal': refTotal,
      'qty': qty,
      'productId': productId,
      'productSerial': productSerial,
      'invoiceId': invoiceId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'isActive': isActive ? 1 : 0,
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
      qty: map['qty'] as int,
      productId: map['productId'] as int,
      productSerial: map['productSerial'] as String,
      invoiceId: map['invoiceId'] as int,
      createdAt: map['createdAt'] as int,
      updatedAt: map['updatedAt'] as int?,
      isActive: map['isActive'] == 1,
    );
  }
}
