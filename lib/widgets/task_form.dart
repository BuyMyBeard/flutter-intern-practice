import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/providers/database.dart';
import 'package:task_manager/providers/form_data.dart';
import 'package:task_manager/providers/task.dart';
enum TaskAction { add, edit }

/// Task Form to add or edit a task.
/// 
/// Must be instanciated by pusing it into [Navigator] as a [MaterialPageRoute].
class TaskForm extends ConsumerStatefulWidget {
  final Task? task;
  final TaskAction action;
  /// Create a task form widget.
  /// 
  /// Make sure to call it by pushing it into the [Navigator] as a [MaterialPageRoute].
  /// 
  /// If [action] is [TaskAction.edit], make sure to provide the [task] to edit.
  /// 
  /// If the [action] is [TaskAction.add], the [task] will be ignored
  const TaskForm({required this.action, this.task, super.key});
  
  String get formTitle => action == TaskAction.add ? "New Task" : "Edit Task";
  String get formSubmit => action == TaskAction.add ? "Create new task" : "Save changes";

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TaskFormState();
}

class _TaskFormState extends ConsumerState<TaskForm> {
  final TextEditingController _titleController = TextEditingController(text: '');
  final TextEditingController _descriptionController = TextEditingController(text: '');
  final _formKey = GlobalKey<FormState>();
  late DateTime _dateInitVal = DateTime(0);
  late TaskPriority _priorityInitVal = TaskPriority.medium;

  @override
  void initState() {
    if (widget.action == TaskAction.edit) {
      if (widget.task == null) {
        throw Exception('''Task form instanciated with action TaskAction.edit, but did not provide a task to edit. \n 
        Please provide a task in the constructor''');
      }

      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description;
      _dateInitVal = widget.task!.dueDate;
      _priorityInitVal = widget.task!.priority;
    } else {
      _dateInitVal = DateTime(0);
      _priorityInitVal = TaskPriority.low;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.formTitle),
        
      ),
      body: Form(
        key: _formKey,
          child: SingleChildScrollView( 
            child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                TextFormField(   
                  maxLength: 40,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                  controller: _titleController,
                  decoration: const InputDecoration(
                    border:OutlineInputBorder(),
                    labelText: 'Title',
                  ),
                ),
                const SizedBox(height:20),
                TextFormField(
                  controller: _descriptionController,
                  keyboardType: TextInputType.multiline,
                  maxLength: 200,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Description',
                  ),
                ),
                const SizedBox(height:20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text('Priority', style: TextStyle(fontSize: 16)),
                    PriorityButtons(_priorityInitVal),
                  ],
                ),
                const SizedBox(height:20),
                DatePicker(_dateInitVal),
                const SizedBox(height:50),
                FilledButton(
                  onPressed: () => _submitForm(context, ref), 
                  child: Text(widget.formSubmit),
                  
                ),
              ],
            )
          )
        )
      )
    );
  }

  _submitForm(BuildContext context, WidgetRef ref) {
    if(!_formKey.currentState!.validate()) {
      return;
    }
    String title = _titleController.text;
    String description = _descriptionController.text;
    TaskPriority priority = ref.read(priorityInputProvider);
    DateTime dueDate = ref.read(dateInputProvider);

    if (widget.action == TaskAction.add) {
      Task task = Task(title: title, description: description, priority: priority, dueDate: dueDate);
      // ref.read(taskListProvider.notifier).addTask(task);
      ref.read(databaseProvider).addTask(task);
    } else {
      Task task = widget.task!.copyWith(title: title, description: description, dueDate: dueDate, priority: priority);
      // ref.read(taskListProvider.notifier).editTask(task);
      ref.read(databaseProvider).editTask(task);
    }
    Navigator.pop(context);
  }
}

/// [SegmentedButton] used in [TaskForm]
class PriorityButtons extends ConsumerStatefulWidget {
  final TaskPriority initialValue;

  const PriorityButtons(this.initialValue, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PriorityButtonsState();
}

class _PriorityButtonsState extends ConsumerState<PriorityButtons> {
  TaskPriority _selected = TaskPriority.low;

  @override
  void initState() {
    _selected = widget.initialValue;
    super.initState();
  }
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
      selected: <TaskPriority>{_selected},
      onSelectionChanged: (Set<TaskPriority> newSelection) {
        setState(() => _selected = newSelection.first);
        ref.read(priorityInputProvider.notifier).state = _selected;
      },
    );
  }
}

/// [showDatePicker] bound by a readonly [TextFormField] used in [TaskForm]
class DatePicker extends ConsumerStatefulWidget {
  final DateTime initialValue;

  const DatePicker(this.initialValue, {super.key});
  
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DatePickerState();
}

class _DatePickerState extends ConsumerState<DatePicker> {
  DateTime pickedDate = DateTime.now();
  final TextEditingController controller = TextEditingController(text: '');

  set textFieldDate(DateTime date) {
    controller.text = DateFormat.yMd('fr_CA').format(pickedDate);
  }

  @override
  void initState() {
    pickedDate = widget.initialValue;
    if (pickedDate != DateTime(0)) {
      textFieldDate = pickedDate;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a date';
        }
        return null;
      },
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
            textFieldDate = pickedDate;
            ref.read(dateInputProvider.notifier).state = date;
          });
        }
      }
    );
  }
}