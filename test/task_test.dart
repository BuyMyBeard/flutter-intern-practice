import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_manager/providers/task.dart';
import 'package:task_manager/widgets/task_form.dart';


void main() {
  late ProviderContainer container;
  group('TaskListProvider', () {
    setUp(() {
      
      final List<Task> taskList = [
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

      container = ProviderContainer();
      container.read(taskListProvider).clear();
      container.read(taskListProvider).addAll(taskList);
      
    }); 
    test('TaskList add', (){
      int taskCount = container.read(taskListProvider).length;
      Task task = Task(title: "Title", description: "Description", dueDate: DateTime(2024, 02, 10), priority: TaskPriority.high);
      
      container.read(taskListProvider.notifier).addTask(task);
      int newTaskCount = container.read(taskListProvider).length;

      expect(container.read(taskListProvider).any((e) => e == task), true);
      expect(newTaskCount, taskCount + 1);
    });

    test('TaskList edit', (){
      int taskCount = container.read(taskListProvider).length;

      String newTitle = 'New Title';
      String newDescription = 'New Description';
      TaskPriority newPriority = TaskPriority.low;
      DateTime newDueDate = DateTime(2040, 01, 01);
      
      Task task = container.read(taskListProvider).first;

      Task modifiedTask = task.copyWith(description: newDescription, title: newTitle, dueDate: newDueDate, priority: newPriority);
      
      container.read(taskListProvider.notifier).editTask(modifiedTask);
      Task fetchedTask = container.read(taskListProvider).firstWhere((element) => element.id == task.id);
      int newTaskCount = container.read(taskListProvider).length;
      
      expect(fetchedTask.title, newTitle);
      expect(fetchedTask.description, newDescription);
      expect(fetchedTask.priority, newPriority);
      expect(fetchedTask.dueDate, newDueDate);
      expect(fetchedTask.done, task.done);
      expect(fetchedTask.title, isNot(equals(task.title)));
      expect(newTaskCount, taskCount);
    });

    test('TaskList remove', (){
      final container = ProviderContainer();

      int taskCount = container.read(taskListProvider).length;
      String removeId = container.read(taskListProvider).first.id;
      
      container.read(taskListProvider.notifier).removeTask(removeId);
      int newTaskCount = container.read(taskListProvider).length;

      expect(newTaskCount, taskCount - 1);
      expect(container.read(taskListProvider).any((element) => element.id == removeId), false);
    });
  });
  
  // Had problems with trying to setup widget tests

  testWidgets('task add', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: TaskForm(action: TaskAction.add)));
    
    await tester.tap(find.text('Create new task'));
    await tester.pump(const Duration(milliseconds: 100));
    Pattern pattern = RegExp(r'Please enter a');
    expect(find.textContaining(pattern), findsExactly(2));
  });
}