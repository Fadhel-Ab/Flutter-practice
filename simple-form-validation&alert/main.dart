import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
       appBar: AppBar(
        title: Text('Flutter Form Exercise'),
        centerTitle: true,
       ),
       body: Myform(),
      ),
    );
  }
}

class Myform extends StatefulWidget{
  @override
  _MyFormState createState() => _MyFormState();
}
class _MyFormState extends State<Myform>{
  final _myFormKey = GlobalKey<FormState>();   // form key to access state 
  final  _logger = Logger();                  // creating a logger to display some more detailed message for better debugging 
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _myFormKey,
      child: Center(
        child: Column(
          children: <Widget>[
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
               Icon(Icons.star, color: Colors.blue,),
               Icon(Icons.favorite,color: Colors.red,),
               Icon(Icons.thumb_up, color: Colors.green,), 
              ],
            ),
            Text('The form is here'),
            TextFormField(
              decoration: InputDecoration(labelText: 'Enter your Name'),
              validator: (value) {
                if(value == null || value.isEmpty){
                  return 'please Enter some Text';
                } return null;
              },
            ),
            ElevatedButton(onPressed: (){
              if (_myFormKey.currentState!.validate()){ //calling the validator through the global key.currentState - (!) needed to tell its not null
                _logger.i('form is valid user input is logged');
                _popup(context,'Form Submitted', 'User input is logged.');
              }
            }, child: Text('Submit'))
          ],
        ),
      ));
  }
}

void _popup(BuildContext context, String title, String message){
  showDialog(     //popup message/widget
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context){
      return AlertDialog(           
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: (){
              Navigator.pop(context);
            },
             child: const Text('OK',))
        ],
      );
    },
  );
}

