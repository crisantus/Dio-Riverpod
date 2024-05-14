// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
    User user;
    Tokens tokens;

    LoginModel({
        required this.user,
        required this.tokens,
    });

    LoginModel copyWith({
        User? user,
        Tokens? tokens,
    }) => 
        LoginModel(
            user: user ?? this.user,
            tokens: tokens ?? this.tokens,
        );

    factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        user: User.fromJson(json["user"]),
        tokens: Tokens.fromJson(json["tokens"]),
    );

    Map<String, dynamic> toJson() => {
        "user": user.toJson(),
        "tokens": tokens.toJson(),
    };
}

class Tokens {
    String accessToken;
    String refreshToken;

    Tokens({
        required this.accessToken,
        required this.refreshToken,
    });

    Tokens copyWith({
        String? accessToken,
        String? refreshToken,
    }) => 
        Tokens(
            accessToken: accessToken ?? this.accessToken,
            refreshToken: refreshToken ?? this.refreshToken,
        );

    factory Tokens.fromJson(Map<String, dynamic> json) => Tokens(
        accessToken: json["accessToken"],
        refreshToken: json["refreshToken"],
    );

    Map<String, dynamic> toJson() => {
        "accessToken": accessToken,
        "refreshToken": refreshToken,
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
