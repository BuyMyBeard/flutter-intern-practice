import 'package:flutter_riverpod/flutter_riverpod.dart';

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
];

enum TaskPriority {
  low,
  medium,
  high,
}

class Task {
  final String title;
  final String description;
  final DateTime dueDate;
  final TaskPriority priority;

  const Task({required this.title, required this.description, required this.dueDate, required this.priority});

  @override
  String toString() {
    return 'Product{title: $title, due date: $dueDate, priority: $priority, description: $description}';
  }
}

class TaskList extends Notifier<List<Task>> {
  
  @override
  List<Task> build() => dummyTaskList;
  
  
  void addTask(Task task) {
    state = [...state, task];
  }
}

final taskListProvider = NotifierProvider<TaskList, List<Task>>(TaskList.new);
