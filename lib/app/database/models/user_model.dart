class User {
  int? id;
  String name;
  String lastName;
  String username;
  int createdAt;
  int? updatedAt;
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
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'isActive': isActive ? 1 : 0,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int?,
      name: map['name'] as String,
      lastName: map['lastName'] as String,
      username: map['username'] as String,
      createdAt: map['createdAt'] as int,
      updatedAt: map['updatedAt'] as int?,
      isActive: map['isActive'] == 1,
    );
  }
}