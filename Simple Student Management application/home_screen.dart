import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'student_model.dart';
import 'student_provider.dart';
import 'edit_screen.dart';

class homescreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
   return Scaffold(
    appBar: AppBar(
      title: const Text('Student List'),
      actions: [  
        PopupMenuButton<String>(
          icon: const Icon(Icons.sort),
          onSelected: (value) => Provider.of<StudentProvider>(context, listen: false).sortBy(value),
          itemBuilder: (context) {
            return [
              PopupMenuItem(value: 'name',child: const Text('Sort by Name')),
              PopupMenuItem(value: 'age',child: const Text('Sort by Age')),
              PopupMenuItem(value: 'major',child: const Text('Sort by Major'))
            ];
          },)
      ],
    ),
    body: Consumer<StudentProvider>(
      builder:(context,provider,child) {
        return ListView.builder(
          itemCount: provider.students.length,
          itemBuilder: (context, index) {
            final student = provider.students[index];
            return ListTile(
              title: Text('${student.firstName} ${student.lastName}'),
              subtitle: Text('Age ${student.age} - Major ${student.major}'),
              trailing: IconButton(
                onPressed:() async {
                  final confirm = await showDialog<bool>(
                   context: context,
                   builder: (context)=> AlertDialog(
                    title: const Text('Delete Student'),
                    content: const Text('Are you sure you want to delete this student ?'),
                    actions: [
                      TextButton(
                        onPressed: ()=> Navigator.pop(context,false),
                        child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: ()=>Navigator.pop(context,true),
                          child: const Text('Delete', style: TextStyle(color: Colors.red),))
                    ],
                   ),);
                   if (confirm == true){
                    Provider.of<StudentProvider>(context, listen: false).removeStudent(student.id);
                   }
                },
                icon: const Icon(Icons.delete, color: Colors.red,)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context)=> EditScreen(student: student,)
                  ),
                  );
              },
            );
          }
          );
      },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context,
          MaterialPageRoute(
            builder: (context)=>EditScreen())
            );
        },
        child: Icon(Icons.add),
        tooltip: 'Add Student',),
   );
  }
}
