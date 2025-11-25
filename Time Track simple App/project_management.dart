import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracking/dialog.dart';
import 'package:time_tracking/time_entery_provide.dart';

class ManageProjectsScreen extends StatelessWidget {
  const ManageProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: Text('Manage Projects'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: Consumer<TimeEntryProvider>(
        builder: (context, provider, child) {
          return ListView.builder(
            itemCount: provider.projects.length,
            itemBuilder: (context, index) {
              final entry = provider.projects[index];
              return ListTile(
                title: Text(entry.name),
                trailing: IconButton(
                  onPressed: () {
                    provider.deleteProject(entry.id);
                  },
                  icon: Icon(Icons.delete, color: Colors.red),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog<String>(
          context: context,
          builder: (context) => const AddProjectDialog(),
        ),
        tooltip: 'Add Project',
        child: Icon(Icons.add),
      ),
    );
  }
}

class ManageTasksScreen extends StatelessWidget {
  const ManageTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: Text('Manage Tasks'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: Consumer<TimeEntryProvider>(
        builder: (context, provider, child) {
          return ListView.builder(
            itemCount: provider.tasks.length,
            itemBuilder: (context, index) {
              final entry = provider.tasks[index];
              return ListTile(
                title: Text(entry.name),
                trailing: IconButton(
                  onPressed: () {
                    provider.deleteTask(entry.id);
                  },
                  icon: Icon(Icons.delete, color: Colors.red),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog<String>(
          context: context,
          builder: (context) => const AddTaskDialog(),
        ),
        tooltip: 'Add Task',
        child: Icon(Icons.add),
      ),
    );
  }
}
