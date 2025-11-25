import 'dart:convert';
import 'package:localstorage/localstorage.dart';

import 'model.dart';
import 'package:flutter/material.dart';

class TimeEntryProvider with ChangeNotifier {
  final LocalStorage storage;
  final String entryKey = 'timeEntry';
  final String projectKey = 'Project';
  final String taskKey = 'Task';
  List<TimeEntry> _entries = [];

  List<Project> _projects = [
    Project(id: '1', name: 'Project App'),
    Project(id: '2', name: 'Project Write'),
    Project(id: '3', name: 'Project Design'),
  ];

  List<Task> _tasks = [
    Task(id: '1', name: 'Task Layout'),
    Task(id: '2', name: 'Task Code'),
    Task(id: '3', name: 'Task Draw'),
  ];

  List<Project> get projects => _projects;
  List<Task> get tasks => _tasks;
  List<TimeEntry> get entries => _entries;

  List<TimeEntry> get sortedByProject {
    final copy = [..._entries];
    copy.sort((a, b) => a.projectName.compareTo(b.projectName));
    return copy;
  }

  TimeEntryProvider({required this.storage}) {
    _loadFromStorage();
  }

  void _saveToStorage() {
    storage.setItem(
      entryKey,
      jsonEncode(_entries.map((e) => e.toJson()).toList()),
    );
    storage.setItem(
      projectKey,
      jsonEncode(_projects.map((e) => e.toJson()).toList()),
    );
    storage.setItem(
      taskKey,
      jsonEncode(_tasks.map((e) => e.toJson()).toList()),
    );

    notifyListeners();
  }

  void _loadFromStorage() {
    var storedTask = storage.getItem(taskKey);
    var storedProject = storage.getItem(projectKey);
    var storedEntry = storage.getItem(entryKey);

    if (storedEntry != null) {
      List decoded = jsonDecode(storedEntry);
      _entries = decoded.map((e) => TimeEntry.fromJson(e)).toList();
    }
    if (storedProject != null) {
      List decoded = jsonDecode(storedProject);
      _projects = decoded.map((e) => Project.fromJson(e)).toList();
    }
    if (storedTask != null) {
      List decoded = jsonDecode(storedTask);
      _tasks = decoded.map((e) => Task.fromJson(e)).toList();
    }

    notifyListeners();
  }

  void addEntries(TimeEntry value) {
    _entries.add(value);
    _saveToStorage();
    notifyListeners();
  }

  void addProject(Project value) {
    _projects.add(value);
    _saveToStorage();
    notifyListeners();
  }

  void addTask(Task value) {
    _tasks.add(value);
    _saveToStorage();
    notifyListeners();
  }

  void deleteEntry(String id) {
    _entries.removeWhere((element) => element.id == id);
    _saveToStorage();
    notifyListeners();
  }

  void deleteProject(String id) {
    _projects.removeWhere((element) => element.id == id);
    _saveToStorage();
    notifyListeners();
  }

  void deleteTask(String id) {
    _tasks.removeWhere((element) => element.id == id);
    _saveToStorage();
    notifyListeners();
  }

  void updateEntry(TimeEntry value) {
    int index = _entries.indexWhere((element) => element.id == value.id);

    if (index != -1) {
      _entries[index] = value;
    } else {
      _entries.add(value);
    }
    _saveToStorage();
    notifyListeners();
  }
}
