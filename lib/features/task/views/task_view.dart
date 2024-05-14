import 'package:dio_riverpod/common/loading_page.dart';
import 'package:flutter/material.dart';
import 'package:dio_riverpod/features/auth/widgets/dio_btn.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/widgets/auth_field.dart';
import '../../home/controller/task_controller.dart';

class TaskPage extends ConsumerStatefulWidget {
  final String? title;
  final String? desc;
  final String? id;
  const TaskPage({Key? key, this.title, this.desc, this.id}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TaskPageState();
}

class _TaskPageState extends ConsumerState<TaskPage> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  String id = '';

  void updateTaskByID(title, description, id, context) {
    ref
        .read(taskControllerProvider.notifier)
        .updateTaskById(title, description, id, context);
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      titleController.text = widget.title ?? "";
      descriptionController.text = widget.desc ?? "";
      id = widget.id ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(taskControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Task"),
      ),
      body: isLoading
          ? const Loader()
          : Container(
              margin: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  AuthField(
                    controller: titleController,
                    hintText: 'title',
                  ),
                  const SizedBox(height: 25),
                  DesField(
                    controller: descriptionController,
                    hintText: 'description',
                  ),
                  const SizedBox(height: 25),
                  DioBtn(
                      onTap: () {
                        updateTaskByID(titleController.text,
                            descriptionController.text, id, context);
                      },
                      btnName: "next")
                ],
              ),
            ),
    );
  }
}
