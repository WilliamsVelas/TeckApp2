class Product {
  int? id;
  String name;
  String code;
  double price;
  double? refPrice;
  int minStock;
  int serialsQty;
  int categoryId;
  int providerId;
  int createdAt;
  int? updatedAt;
  bool isActive;

  Product({
    this.id,
    required this.name,
    required this.code,
    this.price = 0.0,
    this.refPrice,
    this.minStock = 0,
    this.serialsQty = 0,
    this.categoryId = 0,
    this.providerId = 0,
    required this.createdAt,
    this.updatedAt,
    this.isActive = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'price': price,
      'refPrice': refPrice,
      'minStock': minStock,
      'serialsQty': serialsQty,
      'categoryId': categoryId,
      'providerId': providerId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'isActive': isActive ? 1 : 0,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as int?,
      name: map['name'] as String,
      code: map['code'] as String,
      price: map['price'] as double,
      refPrice: map['refPrice'] as double?,
      minStock: map['minStock'] as int,
      serialsQty: map['serialsQty'] as int,
      categoryId: map['categoryId'] as int,
      providerId: map['providerId'] as int,
      createdAt: map['createdAt'] as int,
      updatedAt: map['updatedAt'] as int?,
      isActive: map['isActive'] == 1,
    );
  }
}
