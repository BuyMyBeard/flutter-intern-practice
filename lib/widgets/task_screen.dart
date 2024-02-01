import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/providers/task.dart';
import 'package:task_manager/constants/color_palette.dart' as colors;

class TaskScreen extends ConsumerWidget {
  const TaskScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    final tasks = ref.watch(taskListProvider);

    return ListView.separated(
      itemCount: tasks.length,
      padding: const EdgeInsets.all(10),
      physics: const BouncingScrollPhysics(),
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) => TaskContainer(tasks[index]),
    );    
  }
}

class TaskContainer extends StatelessWidget {
  final Task task;
  
  Color get priorityColor {
    return switch(task.priority) {
      TaskPriority.high => colors.danger,
      TaskPriority.medium => colors.warning,
      TaskPriority.low => colors.success,
    };
  }
  const TaskContainer(this.task, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: 80,
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: colors.secondary, width: 1),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          
          gradient:LinearGradient(
            colors: [
              priorityColor,
              colors.primary,
            ],
            stops: const [.1, .2],

          )
        ),
        child: Row(
          children: [
            TaskToggleBox(task),
            Text(task.title, overflow: TextOverflow.fade,),
            Text(task.dueDate.toIso8601String()),
          ],
        ),
      ),

    );
  }
}

class TaskToggleBox extends ConsumerWidget {
  final Task task;

  const TaskToggleBox(this.task, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Checkbox(
      onChanged: (_) => ref.read(taskListProvider.notifier).toggleTask(!task.done, task.id),
      value: task.done,
    );
  }
}