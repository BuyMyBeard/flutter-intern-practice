import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/db/db_functions.dart';
import 'package:task_manager/providers/auth_providers.dart';
import 'package:task_manager/widgets/task_form.dart';
import 'package:task_manager/widgets/task_screen.dart';

class Home extends ConsumerWidget {
  const Home({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final providers = ref.watch(authProviders);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          label: const Row( 
            children: 
            [
              Icon(Icons.add), 
              SizedBox(width: 8),
              Text('Add Task'),
            ],
          ), 
          // onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const TaskForm(action: TaskAction.add)))
          onPressed: () => getTasks(ref),
        ),
        appBar: AppBar(
          title: const Text("Tasks"),
          bottom: const TabBar(
            tabs:[
              Tab(icon: Icon(Icons.task_alt, size: 30)),
              Tab(icon: Icon(Icons.person, size: 30)),
              Tab(icon: Icon(Icons.settings, size: 30)),
            ],
          )
        ),
        body: TabBarView(children: [
          const TaskScreen(),
          ProfileScreen(
            providers: providers,
            actions: [
              SignedOutAction((context) {
                Navigator.pushReplacementNamed(context, '/sign-in');
              }),
            ],
          ),
          const Text("C"),
        ])
      ),
    );
  }
}