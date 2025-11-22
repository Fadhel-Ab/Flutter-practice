import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'expense_model.dart';

class ExpenseProvider with ChangeNotifier {
  final LocalStorage storage;
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

  ExpenseProvider({required this.storage}) {
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
  }

  void addExpense(Expense value) {
    _expenses.add(value);
    _saveExpensesToStorage();
    notifyListeners();
    _sortBy();
  }

  void removeExpense(String id) {
    _expenses.removeWhere((expense) => expense.id == id);
    _saveExpensesToStorage();
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
    _saveExpensesToStorage(); // Save the updated list to local storage
    _sortBy();
    notifyListeners();
  }

  void addCategory(Category value) {
    _categories.add(value);
    _saveExpensesToStorage();
    notifyListeners();
  }

  void removeCategory(String id) {
    _categories.removeWhere((category) => category.id == id);
    _saveExpensesToStorage();
    notifyListeners();
  }

  void addOrUpdateCategory(Category newCategory) {
    int index = _categories.indexWhere((value) => value.id == newCategory.id);
    if (index != -1) {
      _categories[index] = newCategory;
    } else {
      _categories.add(newCategory);
    }
    _saveExpensesToStorage();
    notifyListeners();
  }

  void addTag(Tag value) {
    _tags.add(value);
    _saveExpensesToStorage();
    notifyListeners();
  }

  void removeTag(String id) {
    _tags.removeWhere((tag) => tag.id == id);
    _saveExpensesToStorage();
    notifyListeners();
  }

  void addOrUpdateTag(Tag newTag) {
    int index = _tags.indexWhere((value) => value.id == newTag.id);
    if (index != -1) {
      _tags[index] = newTag;
    } else {
      _tags.add(newTag);
    }
    _saveExpensesToStorage();
    notifyListeners();
  }
}
