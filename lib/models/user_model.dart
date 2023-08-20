import 'dart:convert';

class UserModel {
  String usernames;
  String password;
  String email;
  UserModel({
    required this.usernames,
    required this.password,
    required this.email,
  });

  UserModel copyWith({
    String? usernames,
    String? password,
    String? email,
  }) {
    return UserModel(
      usernames: usernames ?? this.usernames,
      password: password ?? this.password,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'usernames': usernames});
    result.addAll({'password': password});
    result.addAll({'email': email});
  
    return result;
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      usernames: map['usernames'] ?? '',
      password: map['password'] ?? '',
      email: map['email'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source));

  @override
  String toString() => 'UserModel(usernames: $usernames, password: $password, email: $email)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is UserModel &&
      other.usernames == usernames &&
      other.password == password &&
      other.email == email;
  }

  @override
  int get hashCode => usernames.hashCode ^ password.hashCode ^ email.hashCode;
}
