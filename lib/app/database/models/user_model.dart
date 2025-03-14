class UserApp {
  int? id;
  String name;
  String lastName;
  String username;
  int createdAt;
  int? updatedAt;
  bool isActive;

  UserApp({
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

  factory UserApp.fromMap(Map<String, dynamic> map) {
    return UserApp(
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