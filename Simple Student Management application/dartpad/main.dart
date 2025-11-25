
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Student{
  final int id;
  final String firstName;
  final String lastName;
  final int age;
  final String major;


  Student({ required this.id, required this.firstName,required this.lastName, required this.age, required this.major});


  Map<String, dynamic> toMap(){   
    return{
      'id':id,
      'firstName':firstName,
      'lastName':lastName,
      'age':age,
      'major':major,
    };
  }

  factory Student.fromJson(Map<String, dynamic> json){
    return Student(
    id: json['id'],
    firstName: json['firstName'],
    lastName: json['lastName'],
    age: json['age'],
    major: json['major']);
  }

}



class StudentProvider with ChangeNotifier {
  // final LocalStorage storage;
  List<Student> _students =[];
  
  //StudentProvider({required this.storage}){
 //   _loadStudentsFromStorage();
 // }

  List<Student> get students=> _students;

  void addStudent( Student student) {
    _students.add(student); 
   // _saveToStorage();
    notifyListeners();
  }

  void removeStudent(int id) {
    _students.removeWhere((student)=> student.id==id);
    //_saveToStorage();
    notifyListeners();
  }


  void updateStudent(Student updatedStudent){
    var index= _students.indexWhere((student)=>student.id==updatedStudent.id);
    if (index != -1) {
    _students[index]=updatedStudent;
   // _saveToStorage();
    notifyListeners();
    } 
  }

/*  void _loadStudentsFromStorage() async {
   // var data = storage.getItem('students');
   // String? filterby =storage.getItem('sort');
   // if (data !=null){
      _students = List<Student>.from((jsonDecode(data)as List)
      .map((items)=>Student.fromJson(items as Map<String,dynamic>)));
      notifyListeners();
    }
   // if(filterby!=null){
    //  sortBy(filterby);
      notifyListeners();
    }
  }

  void _saveToStorage() {
   // storage.setItem('students',
    jsonEncode(_students.map((student)=> student.toMap()).toList()));
  }

*/
  void sortBy(String field){
  //  storage.setItem("sort", field);
    switch(field){
      case 'name':
      _students.sort((a,b)=> a.firstName.compareTo(b.firstName));
      break;
      case 'age':
      _students.sort((a,b)=>a.age.compareTo(b.age));
      break;
      case 'major':
      _students.sort((a,b)=>a.major.compareTo(b.major));
      break;
    }
    notifyListeners();
  }
 

}


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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
 // await initLocalStorage();
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  //final LocalStorage localStorage;

  const MainApp({super.key, });
  @override
  Widget build(BuildContext context) {
  return ChangeNotifierProvider<StudentProvider>(
    create:(_) =>StudentProvider(),
    child: MaterialApp(
      title: 'Student Management App',
      debugShowCheckedModeBanner: false,
      home: homescreen(), 
    ),
    );
 
  }
}

