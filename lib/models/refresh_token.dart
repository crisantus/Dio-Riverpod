// To parse this JSON data, do
//
//     final refreshTokenModel = refreshTokenModelFromJson(jsonString);

import 'dart:convert';

RefreshTokenModel refreshTokenModelFromJson(String str) => RefreshTokenModel.fromJson(json.decode(str));

String refreshTokenModelToJson(RefreshTokenModel data) => json.encode(data.toJson());

class RefreshTokenModel {
    User user;
    Tokens tokens;

    RefreshTokenModel({
        required this.user,
        required this.tokens,
    });

    RefreshTokenModel copyWith({
        User? user,
        Tokens? tokens,
    }) => 
        RefreshTokenModel(
            user: user ?? this.user,
            tokens: tokens ?? this.tokens,
        );

    factory RefreshTokenModel.fromJson(Map<String, dynamic> json) => RefreshTokenModel(
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
