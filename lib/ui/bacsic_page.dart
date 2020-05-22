import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';


class BasicPage extends StatefulWidget {
  BasicPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _BasicPageState createState() => _BasicPageState();
}

class _BasicPageState extends State<BasicPage> {

  final FirebaseDatabase database = FirebaseDatabase.instance;

  void _incrementCounter(){
    database.reference().child("ssDB").set({
      "Firstname" : "Yengmoua",
      "lastname" : "Yongpor",
      "age" : 24
    });

    setState(() {
      database.reference().child("ssDB").once().then((DataSnapshot snapshot){
        Map<dynamic, dynamic> data = snapshot.value;
        print("Value: $data");
      });
    });
  }

  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Basic firebase"),
      ),
      body: Center(
        child: Column(
         
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Basic firebase database:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), 
    );
  }
}
