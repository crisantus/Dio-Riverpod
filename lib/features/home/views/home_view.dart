import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/error_page.dart';
import '../../../common/loading_page.dart';
import '../../task/views/task_view.dart';
import '../controller/task_controller.dart';
import '../widget/task_card.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  void getTaskID(id, context) {
    ref
        .read(taskControllerProvider.notifier)
        .getTaskById(id: id, context: context);
  }

  @override
  Widget build(BuildContext contexts) {
    final task = ref.watch(getTaskProvider);
    final isLoading = ref.watch(taskControllerProvider);
    return Scaffold(
        appBar: AppBar(
          title: const Text("My Tasks"),
          automaticallyImplyLeading: false,
          //centerTitle: true,
        ),
        body: isLoading
            ? const Loader()
            :
             task.when(
                data: (tasks) {
                  return ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (BuildContext context, int index) {
                      final task = tasks[index];
                      return Container(
                        margin: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                        ),
                        child: TaskCard(
                          desc: task.description,
                          onTap: () {
                            getTaskID(task.id, contexts);
                          },
                          title: task.title,
                        ),
                      );
                    },
                  );
                },
                error: (error, stackTrace) {
                  debugPrint(error.toString());
                  return ErrorText(
                    error: error.toString(),
                  );
                },
                loading: () => const Loader(),
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Perform some action when the button is pressed
            // print('Floating button pressed!');
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const TaskPage(),
              ),
            );
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ));
  }
}
