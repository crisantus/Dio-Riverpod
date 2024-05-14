// To parse this JSON data, do
//
//     final taskModel = taskModelFromJson(jsonString);

import 'dart:convert';

TaskModel taskModelFromJson(String str) => TaskModel.fromJson(json.decode(str));

String taskModelToJson(TaskModel data) => json.encode(data.toJson());

class TaskModel {
    Task task;

    TaskModel({
        required this.task,
    });

    TaskModel copyWith({
        Task? task,
    }) => 
        TaskModel(
            task: task ?? this.task,
        );

    factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
        task: Task.fromJson(json["task"]),
    );

    Map<String, dynamic> toJson() => {
        "task": task.toJson(),
    };
}

class Task {
    String id;
    String title;
    String description;
    String status;
    String role;
    String createdBy;
    DateTime createdAt;
    DateTime updatedAt;

    Task({
        required this.id,
        required this.title,
        required this.description,
        required this.status,
        required this.role,
        required this.createdBy,
        required this.createdAt,
        required this.updatedAt,
    });

    Task copyWith({
        String? id,
        String? title,
        String? description,
        String? status,
        String? role,
        String? createdBy,
        DateTime? createdAt,
        DateTime? updatedAt,
    }) => 
        Task(
            id: id ?? this.id,
            title: title ?? this.title,
            description: description ?? this.description,
            status: status ?? this.status,
            role: role ?? this.role,
            createdBy: createdBy ?? this.createdBy,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
        );

    factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json["_id"],
        title: json["title"],
        description: json["description"],
        status: json["status"],
        role: json["role"],
        createdBy: json["createdBy"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
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
    };
}
