
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
