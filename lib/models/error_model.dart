// To parse this JSON data, do
//
//     final errorModel = errorModelFromJson(jsonString);

import 'dart:convert';

ErrorModel errorModelFromJson(String str) => ErrorModel.fromJson(json.decode(str));

String errorModelToJson(ErrorModel data) => json.encode(data.toJson());

class ErrorModel {
    String? msg;

    ErrorModel({
        required this.msg,
    });

    ErrorModel copyWith({
        String? msg,
    }) => 
        ErrorModel(
            msg: msg ?? this.msg,
        );

    factory ErrorModel.fromJson(Map<String, dynamic> json) => ErrorModel(
        msg: json["msg"],
    );

    Map<String, dynamic> toJson() => {
        "msg": msg,
    };
}
