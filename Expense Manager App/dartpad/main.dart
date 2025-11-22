
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
final DateFormat dateFormatter=DateFormat('yyyy-MM-dd');

class Expense {
  final String id;
  final double amount;
  final String categoryId;
  final String payee;
  final String note;
  final DateTime date;
  final String tag;


  Expense({
    required this.id,
    required this.amount,
    required this.categoryId,
    required this.date,
    required this.note,
    required this.payee,
    required this.tag
  });


 factory Expense.fromJson(Map<String, dynamic> json ) {
  return Expense(
   id: json['id'],
   amount: json['amount'],
   categoryId: json['categoryId'],
   date: dateFormatter.parse(json['date']),
   payee: json['payee'],
   note: json['note'],
   tag: json['tag']
  );
 }  

 Map<String,dynamic> toJson(){
  return{
     'id': id,
      'amount': amount,
      'categoryId': categoryId,
      'payee': payee,
      'note': note,
      'date': dateFormatter.format(date),
      'tag': tag,
  };
 }

  

}

class Category {
final String id;
final String name;

Category({required this.id, required this.name});


factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
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


class Tag {
final String id;
final String name;

Tag({required this.id, required this.name});


factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
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



class ExpenseProvider with ChangeNotifier {
 // final LocalStorage storage;
  final String expensesKey = 'expenses';
  final String categoriesKey = 'categories';
  final String tagsKey = 'tags';
  String _sorttype = 'Date';
  List<Expense> _expenses = [];

  List<Category> _categories = [
    Category(id: '1', name: 'Food'),
    Category(id: '2', name: 'Transport'),
    Category(id: '3', name: 'Office'),
  ];

  List<Tag> _tags = [
    Tag(id: '1', name: 'Breakfast'),
    Tag(id: '2', name: 'Lunch'),
    Tag(id: '3', name: 'Dinner'),
    Tag(id: '4', name: 'Treat'),
    Tag(id: '5', name: 'Cafe'),
  ];

  List<Expense> get expenses => _expenses;
  List<Category> get categories => _categories;
  List<Tag> get tags => _tags;

  void setSortType(String sort) {
    _sorttype = sort;
    _sortBy();
    notifyListeners();
  }

  void _sortBy() {
    switch (_sorttype) {
      case 'Date':
        _expenses.sort((a, b) => a.date.compareTo(b.date));
        break;
      case 'Category':
        _expenses.sort((a, b) => a.categoryId.compareTo(b.categoryId));
        break;
    }
    notifyListeners();
  }

  /*ExpenseProvider({required this.storage}) {
    _loadExpensesFromStorage();
  }

  Future<void> _loadExpensesFromStorage() async {
    var storedExpense = await storage.getItem(expensesKey);
    var storedCategory = await storage.getItem(categoriesKey);
    var storedTag = await storage.getItem(tagsKey);

    if (storedExpense != null) {
      //loading expenses
      List<dynamic>? value = jsonDecode(storedExpense);
      _expenses = List<Expense>.from(
        (value as List).map(
          (item) => Expense.fromJson(item as Map<String, dynamic>),
        ),
      );
    }
    if (storedCategory != null) {
      //loading categories
      List<dynamic>? value = jsonDecode(storedCategory);
      _categories = List<Category>.from(
        (value as List).map((item) => Category.fromJson(item)),
      );
    }

    if (storedTag != null) {
      // load tags
      List<dynamic>? value = jsonDecode(storedTag);
      _tags = List<Tag>.from((value as List).map((item) => Tag.fromJson(item)));
    }

    notifyListeners();
  }

  void _saveExpensesToStorage() {
    storage.setItem(
      expensesKey,
      jsonEncode(_expenses.map((e) => e.toJson()).toList()),
    );
    storage.setItem(
      categoriesKey,
      jsonEncode(_categories.map((e) => e.toJson()).toList()),
    );
    storage.setItem(tagsKey, jsonEncode(_tags.map((e) => e.toJson()).toList()));
    notifyListeners();
  }*/

  void addExpense(Expense value) {
    _expenses.add(value);
   // _saveExpensesToStorage();
    notifyListeners();
    _sortBy();
  }

  void removeExpense(String id) {
    _expenses.removeWhere((expense) => expense.id == id);
    //_saveExpensesToStorage();
    _sortBy();
    notifyListeners();
  }

  void addOrUpdateExpense(Expense expense) {
    int index = _expenses.indexWhere((e) => e.id == expense.id);
    if (index != -1) {
      // Update existing expense
      _expenses[index] = expense;
    } else {
      // Add new expense
      _expenses.add(expense);
    }
    //_saveExpensesToStorage(); // Save the updated list to local storage
    _sortBy();
    notifyListeners();
  }

  void addCategory(Category value) {
    _categories.add(value);
   // _saveExpensesToStorage();
    notifyListeners();
  }

  void removeCategory(String id) {
    _categories.removeWhere((category) => category.id == id);
    //_saveExpensesToStorage();
    notifyListeners();
  }

  void addOrUpdateCategory(Category newCategory) {
    int index = _categories.indexWhere((value) => value.id == newCategory.id);
    if (index != -1) {
      _categories[index] = newCategory;
    } else {
      _categories.add(newCategory);
    }
   // _saveExpensesToStorage();
    notifyListeners();
  }

  void addTag(Tag value) {
    _tags.add(value);
    //_saveExpensesToStorage();
    notifyListeners();
  }

  void removeTag(String id) {
    _tags.removeWhere((tag) => tag.id == id);
   // _saveExpensesToStorage();
    notifyListeners();
  }

  void addOrUpdateTag(Tag newTag) {
    int index = _tags.indexWhere((value) => value.id == newTag.id);
    if (index != -1) {
      _tags[index] = newTag;
    } else {
      _tags.add(newTag);
    }
   // _saveExpensesToStorage();
    notifyListeners();
  }
}


class CategoryManagementScreen extends StatelessWidget {
  const CategoryManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Manage Category')),
      body: Consumer<ExpenseProvider>(
        builder: (context, provider, child) {
          return ListView.builder(
            itemCount: provider.categories.length,
            itemBuilder: (context, index) {
              final category = provider.categories[index];
              return ListTile(
                title: Text(category.name),
                trailing: IconButton(
                  onPressed: () {
                    provider.removeCategory(category.id);
                  },
                  icon: Icon(Icons.delete),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AddCategoryDialog(key: key),
          );
        },
        tooltip: 'Add Category',
        child: Icon(Icons.add),
      ),
    );
  }
}

class TagManagementScreen extends StatelessWidget {
  const TagManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Manage Tag')),
      body: Consumer<ExpenseProvider>(
        builder: (context, provider, child) {
          return ListView.builder(
            itemCount: provider.tags.length,
            itemBuilder: (context, index) {
              final tag = provider.tags[index];
              return ListTile(
                title: Text(tag.name),
                trailing: IconButton(
                  onPressed: () {
                    Provider.of<ExpenseProvider>(
                      context,
                      listen: false,
                    ).removeTag(tag.id);
                  },
                  icon: Icon(Icons.delete),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AddTagDialog(key: key),
          );
        },
        tooltip: 'Add Tag',
        child: Icon(Icons.add),
      ),
    );
  }
}


class AddCategoryDialog extends StatefulWidget {
  const AddCategoryDialog({super.key});

  @override
  State<StatefulWidget> createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  final TextEditingController _namecontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Category'),
      content: TextField(
        controller: _namecontroller,
        decoration: InputDecoration(labelText: 'Category Name'),
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
            final categoryName = _namecontroller.text;
            if (categoryName.isNotEmpty) {
              final category = Category(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                name: categoryName,
              );
              Provider.of<ExpenseProvider>(
                context,
                listen: false,
              ).addCategory(category);
              Navigator.of(context).pop(categoryName);
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

class AddTagDialog extends StatefulWidget {
  const AddTagDialog({super.key});
  @override
  State<StatefulWidget> createState() => _AddTagDialogState();
}

class _AddTagDialogState extends State<AddTagDialog> {
  final TextEditingController _namecontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Tag'),
      content: TextField(
        controller: _namecontroller,
        decoration: InputDecoration(labelText: 'Tag Name'),
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
            final tagname = _namecontroller.text;
            if (tagname.isNotEmpty) {
              final tag = Tag(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                name: tagname,
              );
              Provider.of<ExpenseProvider>(context,listen: false).addTag(tag);
              Navigator.of(context).pop(tagname);
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


class AddExpenseScreen extends StatefulWidget {
  final Expense? initialExpense;
  

  const AddExpenseScreen({super.key, this.initialExpense});
  @override
  State<StatefulWidget> createState() {
    return _AddExpenseScreenState();
  }
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _payeeController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  String? selectedCategory;
  String? selectedTag;
 

  @override
  void initState() {
    super.initState();
    if (widget.initialExpense != null) {
      _amountController.text = widget.initialExpense!.amount.toString();
      _payeeController.text = widget.initialExpense!.payee;
      _noteController.text = widget.initialExpense!.note;
      selectedCategory = widget.initialExpense!.categoryId;
      selectedTag = widget.initialExpense!.tag;
      selectedDate = widget.initialExpense!.date;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Expense')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _amountController,
              decoration: InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _payeeController,
              decoration: InputDecoration(labelText: 'Payee'),
            ),
            TextField(
              controller: _noteController,
              decoration: InputDecoration(labelText: 'Note'),
            ),
            ListTile(
              leading: Text('Date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}'),
              trailing: IconButton(
                onPressed: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      selectedDate = pickedDate;
                    });
                  }
                },
                icon: Icon(Icons.calendar_month_outlined),
              ),
            ),
            DropdownMenu<String>(
              width: double.infinity,
              label: Text('Category'),
              initialSelection: selectedCategory,
              dropdownMenuEntries:
                  (Provider.of<ExpenseProvider>(context).categories)
                      .map(
                        (item) => DropdownMenuEntry(
                          value: item.name,
                          label: item.name,
                        ),
                      )
                      .toList(),
              onSelected: (value) {
                setState(() {
                  selectedCategory = value;
                });
              },
            ),
            SizedBox(height: 10),
            DropdownMenu(
              width: double.infinity,
              label: Text('Tag'),
              initialSelection: selectedTag,
              dropdownMenuEntries: (Provider.of<ExpenseProvider>(context).tags)
                  .map(
                    (item) =>
                        DropdownMenuEntry(value: item.name, label: item.name),
                  )
                  .toList(),
              onSelected: (value) {
                setState(() {
                  selectedTag = value;
                });
              },
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        child: ElevatedButton(
          onPressed: () => _saveExpenses(context),
          
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            
          ),
          child: Text('Save Expense'),
        ),
      ),
    );
  }

  void _saveExpenses(BuildContext context) {
    final expense = Expense(
      id: widget.initialExpense?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      amount: double.parse(_amountController.text),
      categoryId: selectedCategory!,
      date: selectedDate,
      note: _noteController.text,
      payee: _payeeController.text,
      tag: selectedTag!,
    );

    if(widget.initialExpense  == null){
    Provider.of<ExpenseProvider>(context, listen: false).addExpense(expense);
    }
    else{
      Provider.of<ExpenseProvider>(context,listen: false).addOrUpdateExpense(expense);
    }

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    _payeeController.dispose();
    super.dispose();
  }
}



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await initLocalStorage();
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  //final LocalStorage localStorage;
  MainApp({super.key, });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ExpenseProvider>(
      create: (_) => ExpenseProvider(),
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
