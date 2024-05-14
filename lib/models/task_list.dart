// To parse this JSON data, do
//
//     final taskListModel = taskListModelFromJson(jsonString);

import 'dart:convert';

TaskListModel taskListModelFromJson(String str) => TaskListModel.fromJson(json.decode(str));

String taskListModelToJson(TaskListModel data) => json.encode(data.toJson());

class TaskListModel {
    List<TaskK> task;

    TaskListModel({
        required this.task,
    });

    TaskListModel copyWith({
        List<TaskK>? task,
    }) => 
        TaskListModel(
            task: task ?? this.task,
        );

    factory TaskListModel.fromJson(Map<String, dynamic> json) => TaskListModel(
        task: List<TaskK>.from(json["task"].map((x) => TaskK.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "task": List<dynamic>.from(task.map((x) => x.toJson())),
    };
}

class TaskK {
    String id;
    String title;
    String description;
    String status;
    String role;
    String createdBy;
    DateTime createdAt;
    DateTime updatedAt;
    int v;

    TaskK({
        required this.id,
        required this.title,
        required this.description,
        required this.status,
        required this.role,
        required this.createdBy,
        required this.createdAt,
        required this.updatedAt,
        required this.v,
    });

    TaskK copyWith({
        String? id,
        String? title,
        String? description,
        String? status,
        String? role,
        String? createdBy,
        DateTime? createdAt,
        DateTime? updatedAt,
        int? v,
    }) => 
        TaskK(
            id: id ?? this.id,
            title: title ?? this.title,
            description: description ?? this.description,
            status: status ?? this.status,
            role: role ?? this.role,
            createdBy: createdBy ?? this.createdBy,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
            v: v ?? this.v,
        );

    factory TaskK.fromJson(Map<String, dynamic> json) => TaskK(
        id: json["_id"],
        title: json["title"],
        description: json["description"],
        status: json["status"],
        role: json["role"],
        createdBy: json["createdBy"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "description": description,
        "status": status,
        "role": role,
        "createdBy": createdBy,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
    };
}
