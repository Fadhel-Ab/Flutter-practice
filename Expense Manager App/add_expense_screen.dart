import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'expense_model.dart';
import 'expense_provider.dart';

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
