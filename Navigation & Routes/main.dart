import 'package:flutter/material.dart';
import 'second_screen.dart';
void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navigation  ',
      initialRoute: '/',
      routes: {
        '/': (context) =>  const HomeScreen(),
       '/second': (context) => const SecondScreen(),
      },
    );
  }
}

class HomeScreen extends StatefulWidget{
   const HomeScreen({super.key});
   @override
  _HomeScreenState createState() => _HomeScreenState();
  
}

class _HomeScreenState extends State<HomeScreen>{
  final _formKey= GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _selectedGender = 'Male';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Registration'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child:  Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if(value == null || value.isEmpty){
                    return 'please Enter a valid name';
                  }return null;
                },
              ),
              TextFormField(
                controller: _ageController,
                decoration: InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if(value == null || value.isEmpty){
                    return 'Please Enter a valid age';
                  }return null;
                },
              ),
                ListTile(
                title: const Text('Date of Birth'),
                subtitle: Text('${_selectedDate.toLocal()}'.split(' ')[0]),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null && picked != _selectedDate) {
                    setState(() {
                      _selectedDate = picked;
                    });
                  }
                },
              ),
               DropdownButtonFormField<String>(
                initialValue: _selectedGender,
                decoration: const InputDecoration(labelText: 'Gender'),
                items: ['Male', 'Female', 'Other']
                    .map((String value) => DropdownMenuItem<String>(
                          value: value, 
                          child: Text(value),
                        ))
                    .toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedGender = newValue!;
                  });
                },
              ),
              const SizedBox(height: 20),
                ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pushNamed(
                      context,
                      '/second',
                      arguments: {
                        'name': _nameController.text,
                        'age': _ageController.text,
                        'dateOfBirth': _selectedDate,
                        'gender': _selectedGender,
                      },
                    );
                  }
                },
                child: const Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
