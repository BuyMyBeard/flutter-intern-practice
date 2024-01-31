import 'package:flutter/material.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3, 
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Tasks"),
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.task_alt, size: 30)),
                Tab(icon: Icon(Icons.person, size: 30)),
                Tab(icon: Icon(Icons.settings, size: 30)),
              ],
            )
          ),
          body: const TabBarView(children: [
            Text("A"),
            Text("B"),
            Text("C"),
          ])
        ),
      )
    );
  }
}