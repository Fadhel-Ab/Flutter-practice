import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:time_tracking/model.dart';
import 'package:time_tracking/project_management.dart';
import 'time_entery_provide.dart';
import 'add_update_entry.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initLocalStorage();
  runApp(MainApp(localStorage: localStorage));
}

class MainApp extends StatelessWidget {
  final LocalStorage localStorage;
  const MainApp({super.key, required this.localStorage});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TimeEntryProvider>(
      create: (_) => TimeEntryProvider(storage: localStorage),
      builder:(context,child)=> MaterialApp(
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
          tabs: [
            Tab(text: 'All Entries'),
            Tab(text: 'Grouped by Projects'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ListOfEntries(sortBy: 'default'),
          ListOfEntries(sortBy: 'Projects'),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 0, 193, 113),
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
            MaterialPageRoute(builder: (context) => AddOrUpdateEntry()),
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
