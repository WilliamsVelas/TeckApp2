class User {
  int? id;
  String? name;
  String? lastName;
  String? username;
  String? password;
  double? amount;
  DateTime createdAt;
  DateTime? updatedAt;
  bool isActive;

  User({
    this.id,
    this.name,
    this.lastName,
    this.username,
    this.password,
    this.amount,
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
      'password': password,
      'amount': amount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isActive': isActive ? 1 : 0,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int?,
      name: map['name'] as String?,
      lastName: map['lastName'] as String?,
      username: map['username'] as String?,
      password: map['password'] as String?,
      amount: map['amount'] as double?,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'] as String)
          : null,
      isActive: map['isActive'] == 1,
    );
  }
}