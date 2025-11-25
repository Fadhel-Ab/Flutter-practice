import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final DateFormat dateFormater = DateFormat('yyyy-MM-dd');

class Project {
  final String id;
  final String name;
  Project({required this.id, required this.name});

   factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class Task {
  final String id;
  final String name;
  Task({required this.id, required this.name});

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
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


class TimeEntryProvider with ChangeNotifier {
 // final LocalStorage storage;
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

  /*TimeEntryProvider({required this.storage}) {
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
*/
  void addEntries(TimeEntry value) {
    _entries.add(value);
   // _saveToStorage();
    notifyListeners();
  }

  void addProject(Project value) {
    _projects.add(value);
   // _saveToStorage();
    notifyListeners();
  }

  void addTask(Task value) {
    _tasks.add(value);
  //  _saveToStorage();
    notifyListeners();
  }

  void deleteEntry(String id) {
    _entries.removeWhere((element) => element.id == id);
   // _saveToStorage();
    notifyListeners();
  }

  void deleteProject(String id) {
    _projects.removeWhere((element) => element.id == id);
   // _saveToStorage();
    notifyListeners();
  }

  void deleteTask(String id) {
    _tasks.removeWhere((element) => element.id == id);
   // _saveToStorage();
    notifyListeners();
  }

  void updateEntry(TimeEntry value) {
    int index = _entries.indexWhere((element) => element.id == value.id);

    if (index != -1) {
      _entries[index] = value;
    } else {
      _entries.add(value);
    }
  //  _saveToStorage();
    notifyListeners();
  }
}



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

    final timeEntryProvider = Provider.of<TimeEntryProvider>(context, listen: false);

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
   

    List<Task> listOfTasks = Provider.of<TimeEntryProvider>(context).tasks;
   

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
                    .map<DropdownMenuItem<String>>(
                      (e) =>
                          DropdownMenuItem<String>(value: e.name, child: Text(e.name)),
                    )
                    .toList(),
                onChanged: (String? value) {
                  setState(() {
                    _selectedProject = value;
                  });
                },
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a project';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),

              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Task'),
                initialValue: _selectedTask,
                items: listOfTasks
                    .map<DropdownMenuItem<String>>(
                      (e) =>
                          DropdownMenuItem<String>(value: e.name, child: Text(e.name)),
                    )
                    .toList(),
                onChanged: (String? value) {
                  setState(() {
                    _selectedTask = value;
                  });
                },
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a task';
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
                initialValue: _totalTime == 0.0 && widget.entry == null ? '' : _totalTime.toString(),
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
          builder: (BuildContext context) => const AddProjectDialog(), 
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
          builder: (BuildContext context) => const AddTaskDialog(), 
        ),
        tooltip: 'Add Task',
        child: Icon(Icons.add),
      ),
    );
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
 // await initLocalStorage();
  runApp(MainApp(/*localStorage: localStorage*/));
}

class MainApp extends StatelessWidget {
 // final LocalStorage localStorage;
  const MainApp({super.key/*, required this.localStorage*/});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TimeEntryProvider>(
      create: (_) => TimeEntryProvider(/*storage: localStorage*/),
      builder: (context, child) => MaterialApp(
        title: 'Time Entry Manager',
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => HomeScreen(),
          '/manage_projects': (context) => ManageProjectsScreen(),
          '/manage_tasks': (context) => ManageTasksScreen(),
        },
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Time Tracking'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 0, 193, 113),
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.yellow[700],
          labelColor: Colors.white,
          unselectedLabelColor: const Color.fromARGB(185, 0, 0, 0),
          tabs: const <Tab>[
            Tab(text: 'All Entries'),
            Tab(text: 'Grouped by Projects'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const <Widget>[
          ListOfEntries(sortBy: 'default'),
          ListOfEntries(sortBy: 'Projects'),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 0, 193, 113),
              ),
              child: Center(
                child: Text(
                  'Menu',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.folder, color: Colors.black),
              title: Text('Projects'),
              onTap: () {
                Navigator.pushNamed(context, '/manage_projects');
              },
            ),
            ListTile(
              leading: Icon(Icons.task, color: Colors.black),
              title: Text('Tasks'),
              onTap: () {
                Navigator.pushNamed(context, '/manage_tasks');
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.yellow[700],
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddOrUpdateEntry()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class ListOfEntries extends StatefulWidget {
  final String sortBy;

  const ListOfEntries({super.key, required this.sortBy});
  @override
  State<StatefulWidget> createState() {
    return ListOfEntriesState();
  }
}

class ListOfEntriesState extends State<ListOfEntries> {
  @override
  Widget build(BuildContext context) {
   
    return Consumer<TimeEntryProvider>(
      builder: (context, provider, child) {
        final List<TimeEntry> data = widget.sortBy == 'default'
            ? provider.entries
            : provider.sortedByProject;
        return ListView.builder(
          itemCount: data.length, 
          itemBuilder: (context, index) {
            final entry = data[index];
            return Card(
              margin: EdgeInsets.all(16),
              elevation: 5.0,
              child: ListTile(
                title: Text('${entry.projectName} - ${entry.taskName}'),
                subtitle: Text(
                  'Total Time: ${entry.totalTime}\nDate: ${DateFormat('yyyy-MM-dd').format(entry.date)}\nNote: ${entry.note}',
                ),
                trailing: IconButton(
                  onPressed: () {
                    provider.deleteEntry(entry.id);
                  },
                  icon: Icon(Icons.delete, color: Colors.red),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddOrUpdateEntry(entry: entry),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
