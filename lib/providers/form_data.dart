import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/providers/task.dart';
import 'package:task_manager/widgets/task_form.dart';

/// Used in [TaskForm] to keep the state of the dueDate input
final dateInputProvider = StateProvider<DateTime>((ref) => DateTime.now());

/// Used in [TaskForm] to keep the state of the priority input
final priorityInputProvider = StateProvider<TaskPriority>((ref) => TaskPriority.low);