import 'package:flutter/material.dart';
import 'package:student_data_local_storage/home.dart';
import 'student_model.dart';
import 'student_provider.dart';
import 'package:provider/provider.dart';
import 'package:localstorage/localstorage.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initLocalStorage();
  runApp(MainApp(localStorage: localStorage));
}

class MainApp extends StatelessWidget {
  final LocalStorage localStorage;

  const MainApp({super.key, required this.localStorage});
  @override
  Widget build(BuildContext context) {
  return ChangeNotifierProvider<StudentProvider>(
    create:(_) =>StudentProvider(storage: localStorage),
    child: MaterialApp(
      title: 'Student Management App',
      home: homescreen(), 
    ),
    );
 
  }
}


  
