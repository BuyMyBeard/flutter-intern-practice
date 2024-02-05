import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
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
            const TextField(
              decoration: InputDecoration(
                border:OutlineInputBorder(),
                labelText: 'Title',
              ),
            ),
            const SizedBox(height:20),
            const TextField(
              keyboardType: TextInputType.multiline,
              maxLines: 3,
              decoration: InputDecoration(
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
              onPressed: () => Logger().log(Level.info, "Form submitted"), 
              child: Text(widget.formSubmit),
              
            ),
          ],
        )
      )
    );
  }
}

class PriorityButtons extends StatefulWidget {
  const PriorityButtons({super.key});

  @override
  State<PriorityButtons> createState() => _PriorityButtonsState();
}

class _PriorityButtonsState extends State<PriorityButtons> {
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
      },
    );
  }
}

class DatePicker extends StatefulWidget {
  const DatePicker({super.key});

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
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
          });
        }
      }
    );
  }
}