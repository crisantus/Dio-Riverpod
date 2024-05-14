// To parse this JSON data, do
//
//     final currentUser = currentUserFromJson(jsonString);

import 'dart:convert';

CurrentUser currentUserFromJson(String str) => CurrentUser.fromJson(json.decode(str));

String currentUserToJson(CurrentUser data) => json.encode(data.toJson());

class CurrentUser {
    User user;

    CurrentUser({
        required this.user,
    });

    CurrentUser copyWith({
        User? user,
    }) => 
        CurrentUser(
            user: user ?? this.user,
        );

    factory CurrentUser.fromJson(Map<String, dynamic> json) => CurrentUser(
        user: User.fromJson(json["user"]),
    );

    Map<String, dynamic> toJson() => {
        "user": user.toJson(),
    };
}

class User {
    String id;
    String name;
    String email;
    int v;

    User({
        required this.id,
        required this.name,
        required this.email,
        required this.v,
    });

    User copyWith({
        String? id,
        String? name,
        String? email,
        int? v,
    }) => 
        User(
            id: id ?? this.id,
            name: name ?? this.name,
            email: email ?? this.email,
            v: v ?? this.v,
        );

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["_id"],
        name: json["name"],
        email: json["email"],
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "email": email,
        "__v": v,
    };
}
