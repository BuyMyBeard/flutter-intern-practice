import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/providers/task.dart';
import 'package:task_manager/widgets/task_screen.dart';

class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(onPressed: () => ref.read(taskListProvider.notifier).addTask(Task(title: "A", description: "B", dueDate: DateTime(1998), priority: TaskPriority.high))),
        appBar: AppBar(
          title: const Text("Tasks"),
          bottom: const TabBar(
            tabs:[
              Tab(icon: Icon(Icons.task_alt, size: 30)),
              Tab(icon: Icon(Icons.person, size: 30)),
              Tab(icon: Icon(Icons.settings, size: 30)),
            ],
          )
        ),
        body: const TabBarView(children: [
          TaskScreen(),
          Text("B"),
          Text("C"),
        ])
      ),
    );
  }
}