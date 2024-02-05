import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:task_manager/providers/form_data.dart';
import 'package:task_manager/providers/task.dart';
enum TaskAction { add, edit }

class TaskForm extends ConsumerStatefulWidget {
  final Task? task;
  final TaskAction action;
  
  const TaskForm({required this.action, this.task, super.key});
  
  String get formTitle => action == TaskAction.add ? "New Task" : "Edit Task";
  String get formSubmit => action == TaskAction.add ? "Create new task" : "Save changes";

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TaskFormState();
}

class _TaskFormState extends ConsumerState<TaskForm> {
  final TextEditingController titleController = TextEditingController(text: '');
  final TextEditingController descriptionController = TextEditingController(text: '');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.formTitle),
        
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                border:OutlineInputBorder(),
                labelText: 'Title',
              ),
            ),
            const SizedBox(height:20),
            TextField(
              controller: descriptionController,
              keyboardType: TextInputType.multiline,
              maxLines: 3,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Description',
              ),
            ),
            const SizedBox(height:20),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('Priority', style: TextStyle(fontSize: 16)),
                PriorityButtons(),
              ],
            ),
            const SizedBox(height:20),
            const DatePicker(),
            const SizedBox(height:50),
            FilledButton(
              onPressed: () => _submitForm(context, ref), 
              child: Text(widget.formSubmit),
              
            ),
          ],
        )
      )
    );
  }

  _submitForm(BuildContext context, WidgetRef ref) {
    String title = titleController.text;
    String description = descriptionController.text;
    TaskPriority priority = ref.read(priorityInputProvider);
    DateTime dueDate = ref.read(dateInputProvider);

    Task task = Task(title: title, description: description, priority: priority, dueDate: dueDate);
    ref.read(taskListProvider.notifier).addTask(task);
    Navigator.pop(context);
  }
}

class PriorityButtons extends ConsumerStatefulWidget {
  const PriorityButtons({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PriorityButtonsState();
}

class _PriorityButtonsState extends ConsumerState<PriorityButtons> {
  TaskPriority selected = TaskPriority.medium;
  @override
  Widget build(BuildContext context) {
    return SegmentedButton<TaskPriority>(
      segments: const [
        ButtonSegment<TaskPriority>(
          value: TaskPriority.low, 
          label: Text("Low")
        ),
        ButtonSegment<TaskPriority>(
          value: TaskPriority.medium, 
          label: Text("Medium")
        ),
        ButtonSegment<TaskPriority>(
          value: TaskPriority.high, 
          label: Text("High")
        ),
      ], 
      selected: <TaskPriority>{selected},
      onSelectionChanged: (Set<TaskPriority> newSelection) {
        setState(() => selected = newSelection.first);
        ref.read(priorityInputProvider.notifier).state = selected;
      },
    );
  }
}

class DatePicker extends ConsumerStatefulWidget {
  const DatePicker({super.key});
  
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DatePickerState();
}

class _DatePickerState extends ConsumerState<DatePicker> {
  DateTime pickedDate = DateTime(0);
  final TextEditingController controller = TextEditingController(text: '');
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Due Date',
      ),
      readOnly: true,
      controller: controller,
      onTap: () async { 
        DateTime? date = await showDatePicker(context: context, firstDate: DateTime.now(), lastDate: DateTime(2100));
        if (date != null) {
          setState(() {
            pickedDate = date;
            controller.text = DateFormat.yMd('fr_CA').format(pickedDate);
            ref.read(dateInputProvider.notifier).state = date;
          });
        }
      }
    );
  }
}