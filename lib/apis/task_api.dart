import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import '../core/failure.dart';
import '../core/provider.dart';
import '../core/types_def.dart';
import '../models/error_model.dart';
import '../models/task_list.dart';
import '../models/task_model.dart';

final taskAPIProvider = Provider((ref) {
  final account = ref.watch(dioAuthClientProvider);
  return TaskAPI(
    authClient: account,
  );
});

abstract class ITaskAPI {
  Future<List<TaskK>> getTasks();
  FutureEither<TaskModel> getTaskById(String id);
  FutureEither<TaskModel> updateTaskById(title, description, id);
  FutureEither<dynamic> deleteTaskById(String id);
  FutureEither<TaskModel> createTask({
    required String title,
    required String description,
  });
}

class TaskAPI implements ITaskAPI {
  final Dio _authClient;
  TaskAPI({
    required Dio authClient,
  }) : _authClient = authClient;

  @override
  FutureEither<TaskModel> createTask(
      {required String title, required String description}) async {
    try {
      Map<String, dynamic> body = {
        'title': title,
        'description': description,
      };
      final response = await _authClient.post(
        "/task/",
        data: body,
      );
      debugPrint("data : $response");
      var taskData = taskModelFromJson(response.data);
      return right(taskData);
    } on DioException catch (e, stackTrace) {
      var err = e.response?.data;
      debugPrint("Dio Error: $err");
      var error = ErrorModel.fromJson(err);
      return left(
        Failure(error.msg ?? 'Some unexpected error occurred', stackTrace),
      );
    } catch (e, stackTrace) {
      return left(
        Failure(e.toString(), stackTrace),
      );
    }
  }

  @override
  FutureEither deleteTaskById(String id) async {
    try {
      var response = await _authClient.delete('/task/$id');
      return right(response);
    } on DioException catch (e, stackTrace) {
      var err = e.response?.data;
      debugPrint("Dio Error: $err");
      var error = ErrorModel.fromJson(err);
      return left(
        Failure(error.msg ?? 'Some unexpected error occurred', stackTrace),
      );
    } catch (e, stackTrace) {
      return left(
        Failure(e.toString(), stackTrace),
      );
    }
  }

  @override
  FutureEither<TaskModel> getTaskById(String id) async {
    try {
      var response = await _authClient.get('/task/$id');
      //debugPrint("data : $response");
      var data = response.data;
      var taskData = TaskModel.fromJson(data);
      debugPrint("data : I'm down here ${taskData.task.title}");
      return right(taskData);
    } on DioException catch (e, stackTrace) {
      var err = e.response?.data;
      debugPrint("Dio Error: $err");
      var error = ErrorModel.fromJson(err);
      return left(
        Failure(error.msg ?? 'Some unexpected error occurred', stackTrace),
      );
    } catch (e, stackTrace) {
      return left(
        Failure(e.toString(), stackTrace),
      );
    }
  }

  @override
  Future<List<TaskK>> getTasks() async {
    final response = await _authClient.get('/task/');
    var taskList = TaskListModel.fromJson(response.data);
    return taskList.task;
  }

  @override
  FutureEither<TaskModel> updateTaskById(title, description, id) async {
    try {
      Map<String, dynamic> body = {
        'title': title,
        'description': description,
      };
      var response = await _authClient.patch(
        '/task/$id',
        data: body,
      );
      debugPrint("data : $response");
      var data = response.data;
      var taskData = TaskModel.fromJson(data);
      debugPrint("data : I'm down here ${taskData.task.title}");
      return right(taskData);
    } on DioException catch (e, stackTrace) {
      var err = e.response?.data;
      debugPrint("Dio Error: $err");
      var error = ErrorModel.fromJson(err);
      return left(
        Failure(error.msg ?? 'Some unexpected error occurred', stackTrace),
      );
    } catch (e, stackTrace) {
      return left(
        Failure(e.toString(), stackTrace),
      );
    }
  }
}
