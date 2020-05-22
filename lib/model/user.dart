import 'package:firebase_database/firebase_database.dart';

class User{
  String firstName;
  String lastName;
  String age;
  String key;

  User({this.firstName, this.lastName, this.age, this.key});

  User.forSnapshot(DataSnapshot snapshot) : key = snapshot.key,
  firstName = snapshot.value["Firstname"],
  lastName = snapshot.value["lastname"],
  age  = snapshot.value["age"];

  toJson(){
    return{
      "Firstname" : firstName,
      "lastname" : lastName,
      "age" : age,
    };
  }
}