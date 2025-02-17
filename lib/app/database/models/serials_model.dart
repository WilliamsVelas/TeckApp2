class Serial {
  int? id;
  int productId;
  String serial;
  String status;
  DateTime createdAt;
  DateTime? updatedAt;

  Serial({
    this.id,
    required this.productId,
    required this.serial,
    this.status = 'activo',
    required this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productId': productId,
      'serial': serial,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory Serial.fromMap(Map<String, dynamic> map) {
    return Serial(
      id: map['id'] as int?,
      productId: map['productId'] as int,
      serial: map['serial'] as String,
      status: map['status'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'] as String)
          : null,
    );
  }
}
