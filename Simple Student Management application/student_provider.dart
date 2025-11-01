import 'dart:convert';

import 'package:flutter/material.dart';
import 'student_model.dart';
import 'package:localstorage/localstorage.dart';

class StudentProvider with ChangeNotifier {
   final LocalStorage storage;
  List<Student> _students =[];
  
  StudentProvider({required this.storage}){
    _loadStudentsFromStorage();
  }

  List<Student> get students=> _students;

  void addStudent( Student student) {
    _students.add(student); 
    _saveToStorage();
    notifyListeners();
  }

  void removeStudent(int id) {
    _students.removeWhere((student)=> student.id==id);
    _saveToStorage();
    notifyListeners();
  }


  void updateStudent(Student updatedStudent){
    var index= _students.indexWhere((student)=>student.id==updatedStudent.id);
    if (index != -1) {
    _students[index]=updatedStudent;
    _saveToStorage();
    notifyListeners();
    } 
  }

  void _loadStudentsFromStorage() async {
    var data = storage.getItem('students');
    String? filterby =storage.getItem('sort');
    if (data !=null){
      _students = List<Student>.from((jsonDecode(data)as List)
      .map((items)=>Student.fromJson(items as Map<String,dynamic>)));
      notifyListeners();
    }
    if(filterby!=null){
      sortBy(filterby);
      notifyListeners();
    }
  }

  void _saveToStorage() {
    storage.setItem('students',
    jsonEncode(_students.map((student)=> student.toMap()).toList()));
  }


  void sortBy(String field){
    storage.setItem("sort", field);
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
