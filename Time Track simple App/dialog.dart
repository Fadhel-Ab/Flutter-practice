import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracking/model.dart';
import 'time_entery_provide.dart';

class AddProjectDialog extends StatefulWidget {
  const AddProjectDialog({super.key});

  @override
  State<StatefulWidget> createState() => _AddProjectDialogState();
}

class _AddProjectDialogState extends State<AddProjectDialog> {
  final TextEditingController _namecontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Project'),
      content: TextField(
        controller: _namecontroller,
        decoration: InputDecoration(labelText: 'Project Name'),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final projectName = _namecontroller.text;
            if (projectName.isNotEmpty) {
              final project = Project(
                id: DateTime.now().toString(),
                name: projectName,
              );
              Provider.of<TimeEntryProvider>(
                context,
                listen: false,
              ).addProject(project);
              Navigator.of(context).pop(projectName);
            }
          },
          child: Text('Add'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _namecontroller.dispose();
    super.dispose();
  }
}

class AddTaskDialog extends StatefulWidget {
  const AddTaskDialog({super.key});
  @override
  State<StatefulWidget> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final TextEditingController _namecontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Task'),
      content: TextField(
        controller: _namecontroller,
        decoration: InputDecoration(labelText: 'Task Name'),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final taskname = _namecontroller.text;
            if (taskname.isNotEmpty) {
              final task = Task(id: DateTime.now().toString(), name: taskname);
              Provider.of<TimeEntryProvider>(
                context,
                listen: false,
              ).addTask(task);
              Navigator.of(context).pop(taskname);
            }
          },
          child: Text('Add'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _namecontroller.dispose();
    super.dispose();
  }
}
