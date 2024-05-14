import 'package:dio_riverpod/apis/task_api.dart';
import 'package:dio_riverpod/features/home/views/home_view.dart';
import 'package:dio_riverpod/features/task/views/task_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/util.dart';
import '../../../models/task_list.dart';
import '../../../models/task_model.dart';

final taskControllerProvider =
    StateNotifierProvider<TaskController, bool>((ref) {
  return TaskController(taskAPI: ref.watch(taskAPIProvider));
});

final getTaskProvider = FutureProvider((ref) {
  final taskController = ref.watch(taskControllerProvider.notifier);
  return taskController.getTask();
});

class TaskController extends StateNotifier<bool> {
  final TaskAPI _taskAPI;
  TaskController({required TaskAPI taskAPI})
      : _taskAPI = taskAPI,
        super(false);

  void createTask({
    required String title,
    required String description,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _taskAPI.createTask(
      title: title,
      description: description,
    );
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) async {
        showSnackBar(context, 'Tasked created! ${r.task.id}');
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const HomePage(),
        ));
      },
    );
  }

  Future<List<TaskK>> getTask() async {
    final taskList = await _taskAPI.getTasks();
    return taskList;
  }

  void getTaskById({
    required String id,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _taskAPI.getTaskById(id);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) async {
        Navigator.of(context).push( MaterialPageRoute(
          builder: (context) => TaskPage(
            title: r.task.title,
            desc: r.task.description,
            id:r.task.id
          ),
        ));
      },
    );
  }

  void updateTaskById(title, description, id,  

   BuildContext context,
  ) async {
    state = true;
  
    final res = await _taskAPI.updateTaskById(title, description, id);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) async {
        showSnackBar(context, "Task Updated!!");
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const HomePage(),
        ));
      },
    );
  }
}
