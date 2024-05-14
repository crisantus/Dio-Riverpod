// To parse this JSON data, do
//
//     final userSignupModel = userSignupModelFromJson(jsonString);

import 'dart:convert';

UserSignupModel userSignupModelFromJson(String str) => UserSignupModel.fromJson(json.decode(str));

String userSignupModelToJson(UserSignupModel data) => json.encode(data.toJson());

class UserSignupModel {
    User user;

    UserSignupModel({
        required this.user,
    });

    UserSignupModel copyWith({
        User? user,
    }) => 
        UserSignupModel(
            user: user ?? this.user,
        );

    factory UserSignupModel.fromJson(Map<String, dynamic> json) => UserSignupModel(
        user: User.fromJson(json["user"]),
    );

    Map<String, dynamic> toJson() => {
        "user": user.toJson(),
    };
}

class User {
    String name;
    String userId;

    User({
        required this.name,
        required this.userId,
    });

    User copyWith({
        String? name,
        String? userId,
    }) => 
        User(
            name: name ?? this.name,
            userId: userId ?? this.userId,
        );

    factory User.fromJson(Map<String, dynamic> json) => User(
        name: json["name"],
        userId: json["userId"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "userId": userId,
    };
}
