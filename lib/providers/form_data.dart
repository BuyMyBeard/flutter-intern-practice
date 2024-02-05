import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/providers/task.dart';

final dateInputProvider = StateProvider<DateTime>((ref) => DateTime(0));
final priorityInputProvider = StateProvider<TaskPriority>((ref) => TaskPriority.medium);