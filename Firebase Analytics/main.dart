import 'package:firebase_analytics/firebase_analytics.dart';
 import 'package:flutter/material.dart';
 import 'package:firebase_core/firebase_core.dart';
 import 'firebase_options.dart';
 import 'package:firebase_analytics/firebase_analytics.dart';
 
void main() async{
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp( MainApp());
}

class MainApp extends StatelessWidget {
   MainApp({super.key});
  static final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(  
      title: 'Firebase Analytics Demo',
      home: MyHomePage(analytics: analytics),
      );
  }
}
class MyHomePage extends StatefulWidget{
  final FirebaseAnalytics analytics;
   const MyHomePage({super.key, required this.analytics});
  @override
  State<StatefulWidget> createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
   void _logButton1Event() {
    widget.analytics.logEvent(
      name: 'button_1_clicked',
      parameters: {'button_name': 'Button 1'},
    );
    print('Button 1 clicked event logged');
  }

  void _logButton2Event() {
    widget.analytics.logEvent(
      name: 'button_2_clicked',
      parameters: {'button_name': 'Button 2'},
    );
    print('Button 2 clicked event logged');
  }
  
  @override
  Widget build(BuildContext context) {
   return Scaffold(
    appBar: AppBar(
      centerTitle: true,
      title: const Text('Firebase Analytics Demo'),
    ),
    body: Padding(padding: EdgeInsets.all(16.0),
    child: Center(
      child: Column(
       mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(onPressed: _logButton1Event, child: const Text('Log Button 1 Event')),
        SizedBox(height: 20,),
        ElevatedButton(onPressed: _logButton2Event, child: const Text('Log Button 2 Event'))
      ],
    ),
    ),
    
    ),
   );
  }
 
}

