import 'package:flutter/material.dart';
import 'package:flutter_final_project/expense_provider.dart';
import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'add_expense_screen.dart';
import 'category_tag_managementScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initLocalStorage();
  runApp(MainApp(localStorage: localStorage));
}

class MainApp extends StatelessWidget {
  final LocalStorage localStorage;
  MainApp({super.key, required this.localStorage});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ExpenseProvider>(
      create: (_) => ExpenseProvider(storage: localStorage),
      child: MaterialApp(title: 'Expense Manager',
       debugShowCheckedModeBanner: false,
       initialRoute: '/',
       routes: {
        '/': (context)=>HomeScreen(),
        '/manage_categories':(context)=>CategoryManagementScreen(),
        '/manage_tags':(context)=>TagManagementScreen(),
       },
     ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen>
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
        title: Text('Expenses List'),
        centerTitle: true,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(text: 'By Date'),
            Tab(text: 'By Category'),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: 74,
              child: const DrawerHeader(
                decoration: BoxDecoration(color: Colors.green),
                child: Text(
                  'Menu',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.category,color: Colors.green,),
              title: Text('Manage Category'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/manage_categories');
              },
            ),
            ListTile(
              leading: Icon(Icons.tag,color: Colors.green,),
              title: Text('Manage Tags'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/manage_tags');
              },
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ExpenseList(sortType: 'Date'),
          ExpenseList(sortType: 'Category'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddExpenseScreen()),
          );
        },
        tooltip: 'Add expense',
        child: Icon(Icons.add),
      ),
    );
  }
}

class ExpenseList extends StatefulWidget {
  final String sortType;

  const ExpenseList({super.key, required this.sortType});

  @override
  State<StatefulWidget> createState() {
    return ExpenseListState();
  }
}

class ExpenseListState extends State<ExpenseList> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<ExpenseProvider>(
        context,
        listen: false,
      ).setSortType(widget.sortType);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseProvider>(
      builder: (context, provider, child) {
        return ListView.builder(
          itemCount: provider.expenses.length,
          itemBuilder: (context, index) {
            final expense = provider.expenses[index];
            return ListTile(
              title: Text('${expense.payee} - \$${expense.amount}'),
              subtitle: Text(
                'Category: ${expense.categoryId} - Date: ${DateFormat('yyyy-MM-dd').format(expense.date)}',
              ),
              trailing: IconButton(
                onPressed: () {
                  provider.removeExpense(expense.id);
                },
                icon: Icon(Icons.delete, color: Colors.red),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AddExpenseScreen(initialExpense: expense),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}



/*

*/







                                                   
