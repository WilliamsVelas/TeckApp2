class User {
  int? id;
  String name;
  String lastName;
  String username;
  DateTime createdAt;
  DateTime? updatedAt;
  bool isActive;

  User({
    this.id,
    required this.name,
    required this.lastName,
    required this.username,
    required this.createdAt,
    this.updatedAt,
    this.isActive = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'lastName': lastName,
      'username': username,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isActive': isActive ? 1 : 0,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int?,
      name: map['name'] as String,
      lastName: map['lastName'] as String,
      username: map['username'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'] as String)
          : null,
      isActive: map['isActive'] == 1,
    );
  }
}