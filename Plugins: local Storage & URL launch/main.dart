
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:url_launcher/url_launcher.dart';   //also for launcher plugin 

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _mainAppState();
}

class _mainAppState extends State<MainApp>{
  final TextEditingController _controller = TextEditingController();
  String _storedValue='';
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter plugin Lab',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Explore Flutter plugins'),
        ),
        body: Padding(
          padding:EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _controller,
                decoration: const InputDecoration(labelText: 'Enter some text'),
              ),
              const SizedBox(height: 16), // Adds space between TextField and Save button
              ElevatedButton(
                onPressed: _savedData,
                child: const Text('Save Data')),
                const SizedBox(height: 16,),
                ElevatedButton(
                  onPressed: _loadData,
                  child: const Text('Load Data')),
                  const SizedBox(height: 16,),
                  Text('Stored Value $_storedValue'),
            ],
          ),
          ),
      ),
    );
  }

  Future<void> _savedData()   async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('mykey', _controller.text);
 } 


void _loadData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  setState(() {
    _storedValue = prefs.getString('mykey') ?? 'no Data';
  });
}




}


/*class MainApp extends StatelessWidget {   //this part is for the url launcher plugin
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Plugin Lab',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Explore Flutter Plugins'),
        ),  
        body: const Center(
          child: ElevatedButton(
          onPressed: _launchURL,
          child: const Text('Open Flutter Website'),
        ),
      ),
    )
    );
  }
}

void _launchURL() async {
final url =Uri.parse('https://flutter.dev');
if (await canLaunchUrl(url)) {
  await launchUrl(url);
}else{
  throw 'could not launch $url';
}
} 
*/
