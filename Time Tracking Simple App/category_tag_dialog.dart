import 'package:flutter/material.dart';
import 'package:flutter_final_project/expense_model.dart';
import 'expense_provider.dart';
import 'package:provider/provider.dart';

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
