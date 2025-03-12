class Image {
  int? id;
  String? uri;
  int createdAt;
  int? updatedAt;
  bool isActive;

  Image({
    this.id,
    this.uri,
    required this.createdAt,
    this.updatedAt,
    this.isActive = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uri': uri,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'isActive': isActive ? 1 : 0,
    };
  }

  factory Image.fromMap(Map<String, dynamic> map) {
    return Image(
      id: map['id'] as int?,
      uri: map['uri'] as String?,
      createdAt: map['createdAt'] as int,
      updatedAt: map['updatedAt'] as int?,
      isActive: map['isActive'] == 1,
    );
  }
}