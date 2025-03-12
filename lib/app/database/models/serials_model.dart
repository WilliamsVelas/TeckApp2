class Serial {
  int? id;
  int productId;
  String serial;
  String status;
  int createdAt;
  int? updatedAt;
  bool isActive;

  Serial({
    this.id,
    required this.productId,
    required this.serial,
    this.status = 'activo',
    required this.createdAt,
    this.updatedAt,
    this.isActive = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productId': productId,
      'serial': serial,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'isActive': isActive ? 1 : 0,
    };
  }

  factory Serial.fromMap(Map<String, dynamic> map) {
    return Serial(
      id: map['id'] as int?,
      productId: map['productId'] as int,
      serial: map['serial'] as String,
      status: map['status'] as String,
      createdAt: map['createdAt'] as int,
      updatedAt: map['updatedAt'] as int?,
      isActive: map['isActive'] == 1,
    );
  }
}
