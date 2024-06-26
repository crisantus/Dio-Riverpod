// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
    User user;

    UserModel({
        required this.user,
    });

    UserModel copyWith({
        User? user,
    }) => 
        UserModel(
            user: user ?? this.user,
        );

    factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        user: User.fromJson(json["user"]),
    );

    Map<String, dynamic> toJson() => {
        "user": user.toJson(),
    };
}

class User {
    String name;
    String email;
    String password;
    String id;
    int v;

    User({
        required this.name,
        required this.email,
        required this.password,
        required this.id,
        required this.v,
    });

    User copyWith({
        String? name,
        String? email,
        String? password,
        String? id,
        int? v,
    }) => 
        User(
            name: name ?? this.name,
            email: email ?? this.email,
            password: password ?? this.password,
            id: id ?? this.id,
            v: v ?? this.v,
        );

    factory User.fromJson(Map<String, dynamic> json) => User(
        name: json["name"],
        email: json["email"],
        password: json["password"],
        id: json["_id"],
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "password": password,
        "_id": id,
        "__v": v,
    };
}
