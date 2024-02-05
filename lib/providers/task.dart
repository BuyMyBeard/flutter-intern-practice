import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final List<Task> dummyTaskList = [
  Task(
    title: "Dishes", 
    description: "Do the dishes",
    priority: TaskPriority.high,
    dueDate: DateTime(2024, 2, 30),
  ),
  Task(
    title: "Homework", 
    description: "Do the math homework",
    priority: TaskPriority.medium,
    dueDate: DateTime(2024, 3, 7),
  ),
  Task(
    title: "Friend", 
    description: "Talk with my friend I haven't seen in forever",
    priority: TaskPriority.low,
    dueDate: DateTime(2024, 10, 30),
  ),
  Task(
    title: "aaaaaaaaaaaaaa aaaaaaaaaaaaaaaaaaaaaaa aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa", 
    description: "Talk with my friend I haven't seen in foreverllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllll",
    priority: TaskPriority.low,
    dueDate: DateTime(2024, 10, 30),
  ),
];

enum TaskPriority {
  low,
  medium,
  high,
}

const uuid = Uuid();

class Task {
  late String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final TaskPriority priority;
  final bool done;

  Task({String? id, required this.title, required this.description, required this.dueDate, required this.priority, this.done = false}) {
    this.id = id ?? uuid.v4();
  }

  @override
  String toString() {
    return 'Product{title: $title, due date: $dueDate, priority: $priority, description: $description}';
  }

  Task copyWith({String? title, String? description, DateTime? dueDate, TaskPriority? priority, bool? done}) {
    return Task(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      done: done ?? this.done,
    );
  }
}

class TaskList extends Notifier<List<Task>> {
  
  @override
  List<Task> build() => dummyTaskList;
  
  
  void addTask(Task task) async {
    state = [...state, task];
  }

  void editTask(Task editedTask) => state = state.map((previousTask) => editedTask.id == previousTask.id ? editedTask : previousTask).toList();

  void removeTask(String id) => state = state.where((task) => task.id != id).toList();

  void toggleTask(bool done, String id) => state = state.map((task) => id == task.id ? task.copyWith(done: done) : task).toList();
  
}

final taskListProvider = NotifierProvider<TaskList, List<Task>>(TaskList.new);
