import 'package:flutter/material.dart';
import 'student_model.dart';
import 'student_provider.dart';
import 'package:provider/provider.dart';


class EditScreen extends StatefulWidget {
 final Student? student;

  const EditScreen({super.key, this.student});

  @override
  State<StatefulWidget> createState() {
    return _editStudentScreen();
  }
}

class _editStudentScreen extends State<EditScreen>{
  final TextEditingController _firstnameController =TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _majorController = TextEditingController();
  


  @override
  void initState() {
    super.initState();
    if(widget.student != null) {
      _firstnameController.text = widget.student!.firstName;
      _lastnameController.text = widget.student!.lastName;
      _ageController.text = widget.student!.age.toString();
      _majorController.text=widget.student!.major;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(widget.student==null ? 'Add student' : 'Edit Student'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _firstnameController,
              decoration: InputDecoration(labelText: 'First Name'),
            ),TextField(
              controller: _lastnameController,
              decoration: InputDecoration(labelText: 'Last Name'),
            ),TextField(
              controller: _ageController,
              decoration: InputDecoration(labelText: 'Age'),
            ),TextField(
              controller: _majorController,
              decoration: InputDecoration(labelText: 'Major'),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: (){
                print('pressed');
               _saveStudent(context);
               },
              child: const Text('Save Student'),
              ),
          ],
        ),
        ),
    );  
  }


void _saveStudent(BuildContext context) {
final student = Student(
  id: widget.student?.id ?? DateTime.now().millisecondsSinceEpoch,
  firstName: _firstnameController.text,
  lastName: _lastnameController.text,
  age: int.parse(_ageController.text),
  major: _majorController.text);

  if(widget.student == null) {
    Provider.of<StudentProvider>(context, listen:false).addStudent(student);
     
  }else {
    Provider.of<StudentProvider>(context, listen: false).updateStudent(student);
    
  }
  print("Saving student...");
 Navigator.pop(context); 
print("Closing screen...");
}

  @override
  void dispose() {
   _firstnameController.dispose();
   _lastnameController.dispose();
   _ageController.dispose();
   _majorController.dispose();
    super.dispose();
  }

}

