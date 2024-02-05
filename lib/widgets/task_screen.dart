import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:task_manager/providers/task.dart';
import 'package:task_manager/constants/color_palette.dart' as colors;
import 'package:task_manager/widgets/task_form.dart';
import 'package:task_manager/widgets/task_info.dart';

class TaskScreen extends ConsumerWidget {
  const TaskScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    final tasks = ref.watch(taskListProvider);

    return ListView.separated(
      itemCount: tasks.length,
      padding: const EdgeInsets.all(1),
      physics: const BouncingScrollPhysics(),
      separatorBuilder: (context, index) => const SizedBox(height: 1),
      itemBuilder: (context, index) => TaskContainer(tasks[index]),
    );    
  }
}


class TaskContainer extends StatelessWidget {
  final Task task;
  
  Color get priorityColor {
    return switch(task.priority) {
      TaskPriority.high => colors.dangerDark,
      TaskPriority.medium => colors.warningDark,
      TaskPriority.low => colors.successDark,
    };
  }
  Color get priorityLightColor {
    return switch(task.priority) {
      TaskPriority.high => colors.dangerLight,
      TaskPriority.medium => colors.warningLight,
      TaskPriority.low => colors.successLight,
    };
  }
  const TaskContainer(this.task, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(TaskInfo<void>(task)),
      child: Container(
        height: 80,
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          border: Border.all(color: priorityColor, width: 1),
          borderRadius: const BorderRadius.all(Radius.circular(40)),
          color: priorityLightColor
          // gradient:LinearGradient(
          //   colors: [
          //     priorityColor,
          //     colors.secondary,
          //   ],
          //   stops: const [.1, .2],

          // )
        ),
        child: Row(
          children: [
            TaskToggleBox(task),
              Expanded(
                child: Column(
                
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children : [

                    
                  Text(
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    task.title, 
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                  
                  ),
                  Text(DateFormat.yMd('fr_CA').format(task.dueDate)),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit), 
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TaskForm(task: task, action: TaskAction.edit))),
              iconSize: 35,
            ),
            IconButton(
              icon: const Icon(Icons.delete), 
              onPressed: () => Logger().log(Level.info, "Delete"),
              iconSize: 35,
            ),
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