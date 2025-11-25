import 'package:intl/intl.dart';

final DateFormat dateFormater = DateFormat('yyyy-MM-dd');

class Project {
  final String id;
  final String name;
  Project({required this.id, required this.name});

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}

class Task {
  final String id;
  final String name;
  Task({required this.id, required this.name});

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}

class TimeEntry {
  final String id;
  final String projectName;
  final String taskName;
  final double totalTime;
  final DateTime date;
  final String note;

  TimeEntry({
    required this.id,
    required this.projectName,
    required this.taskName,
    required this.totalTime,
    required this.date,
    required this.note,
  });

  factory TimeEntry.fromJson(Map<String, dynamic> json) {
    return TimeEntry(
      id: json['id'],
      projectName: json['projectName'],
      taskName: json['taskName'],
      totalTime: json['totalTime'],
      date: dateFormater.parse(json['date']),
      note: json['note'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'projectName': projectName,
      'taskName': taskName,
      'totalTime': totalTime,
      'date': dateFormater.format(date),
      'note': note,
    };
  }
}
