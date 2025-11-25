import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:time_tracking/model.dart';
import 'package:time_tracking/time_entery_provide.dart';

class AddOrUpdateEntry extends StatefulWidget {
  final TimeEntry? entry;
  const AddOrUpdateEntry({super.key, this.entry});
  @override
  State<StatefulWidget> createState() {
    return AddOrUpdateEntryState();
  }
}

class AddOrUpdateEntryState extends State<AddOrUpdateEntry> {
  final _formKey = GlobalKey<FormState>();

  double _totalTime = 0.0;
  String _note = '';
  DateTime _selectedDate = DateTime.now();
  String? _selectedProject;
  String? _selectedTask;

  @override
  void initState() {
    super.initState();

    final timeEntryProvider = Provider.of<TimeEntryProvider>(
      context,
      listen: false,
    );

    if (widget.entry != null) {
      _totalTime = widget.entry!.totalTime;
      _note = widget.entry!.note;
      _selectedDate = widget.entry!.date;
      _selectedProject = widget.entry!.projectName;
      _selectedTask = widget.entry!.taskName;
    } else {
      if (timeEntryProvider.projects.isNotEmpty) {
        _selectedProject = timeEntryProvider.projects[0].name;
      }
      if (timeEntryProvider.tasks.isNotEmpty) {
        _selectedTask = timeEntryProvider.tasks[0].name;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Project> listOfProjects = Provider.of<TimeEntryProvider>(
      context,
    ).projects;
    var firstP = listOfProjects[0].name;

    List<Task> listOfTasks = Provider.of<TimeEntryProvider>(context).tasks;
    var firstT = listOfTasks[0].name;

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Time Entry'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 0, 193, 113),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.black),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 30, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Project'),
                initialValue: _selectedProject,
                items: listOfProjects
                    .map(
                      (e) => DropdownMenuItem<String>(
                        value: e.name,
                        child: Text(e.name),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedProject = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'please select a project ';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),

              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Task'),
                initialValue: _selectedTask ?? firstT,
                items: listOfTasks
                    .map(
                      (e) => DropdownMenuItem<String>(
                        value: e.name,
                        child: Text(e.name),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedTask = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'please select a task ';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Text('Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}'),
              SizedBox(height: 12),
              ElevatedButton(
                onPressed: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _selectedDate = pickedDate;
                    });
                  }
                },
                child: Text('Select Date'),
              ),
              SizedBox(height: 15),
              TextFormField(
                initialValue: _totalTime == 0.0 && widget.entry == null
                    ? ''
                    : _totalTime.toString(),
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  label: Text('Total Time (in hours)'),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter total time';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
                onSaved: (newValue) => _totalTime = double.parse(newValue!),
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: _note,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  label: Text('Note'),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some Notes';
                  }
                  return null;
                },
                onSaved: (newValue) => _note = newValue!,
              ),
              SizedBox(height: 26),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final entry = TimeEntry(
                      id: widget.entry?.id ?? DateTime.now().toString(),
                      projectName: _selectedProject!,
                      taskName: _selectedTask!,
                      totalTime: _totalTime,
                      date: _selectedDate,
                      note: _note,
                    );
                    if (widget.entry == null) {
                      Provider.of<TimeEntryProvider>(
                        context,
                        listen: false,
                      ).addEntries(entry);
                    } else {
                      Provider.of<TimeEntryProvider>(
                        context,
                        listen: false,
                      ).updateEntry(entry);
                    }
                    Navigator.pop(context);
                  }
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
