import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/providers/task.dart';

final dateInputProvider = StateProvider<DateTime>((ref) => DateTime.now());
final priorityInputProvider = StateProvider<TaskPriority>((ref) => TaskPriority.medium);