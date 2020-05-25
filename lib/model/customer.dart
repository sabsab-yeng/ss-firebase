import 'package:firebase_database/firebase_database.dart';

class Customer {

  String _id;
  String _fname;
  String _lname;
  String _gender;
  String _phone;

  Customer(this._id, this._fname, this._lname, this._gender, this._phone);

  String get fname => _fname;

  String get lname => _lname;

  String get gender => _gender;

  String get phone => _phone;

  String get id => _id;

  Customer.fromSnapshot(DataSnapshot snapshot) {
    _id = snapshot.key;
    _fname = snapshot.value['fname'];
    _lname = snapshot.value['lname'];
    _gender = snapshot.value['gender'];
    _phone = snapshot.value['phone'];
  }
}