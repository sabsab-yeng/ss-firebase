import 'package:firebase_app/model/user.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class AdvancePage extends StatefulWidget {
  @override
  _AdvancePageState createState() => _AdvancePageState();
}

class _AdvancePageState extends State<AdvancePage> {
  final FirebaseDatabase database = FirebaseDatabase.instance;

  List<User> listUser = List();

  User user;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  DatabaseReference databaseReference;

  @override
  void initState() {
    super.initState();

    user = User();

    databaseReference = database.reference().child("ssDB");
    databaseReference.onChildAdded.listen((_onAddData));
    databaseReference.onChildChanged.listen((_onChanged));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Advance firebase"),
      ),
      body: Column(
        children: [
          Flexible(
            flex: 0,
            child: Form(
              key: formKey,
              child: Flex(
                direction: Axis.vertical,
                children: [
                  ListTile(
                    leading: Icon(Icons.person),
                    title: TextFormField(
                      initialValue: "",
                      validator: (val) => val == "" ? val : null,
                      onSaved: (val) => user.firstName = val,
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.laptop),
                    title: TextFormField(
                      initialValue: "",
                      validator: (val) => val == "" ? val : null,
                      onSaved: (val) => user.lastName = val,
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.assignment_turned_in),
                    title: TextFormField(
                      initialValue: "",
                      validator: (val) => val == "" ? val : null,
                      onSaved: (val) => user.age = val,
                    ),
                  ),
                  RaisedButton(
                    child: Text("POST"),
                    onPressed: () {
                      handlePostData();
                    },
                  )
                ],
              ),
            ),
          ),
          Flexible(
            child: FirebaseAnimatedList(
              query: databaseReference,
              itemBuilder: (context, DataSnapshot snapshot,
                  Animation<double> animation, int index) {
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.black,
                    ),
                    title: Row(
                      children: [
                        Expanded(child: Text(listUser[index].firstName)),
                        Text(listUser[index].age),
                      ],
                    ),
                    // subtitle: Text(listUser[index].age),
                    subtitle: Text(listUser[index].lastName),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  void _onAddData(Event event) {
    setState(() {
      listUser.add(User.forSnapshot(event.snapshot));
    });
  }

  void handlePostData() {
    final FormState form = formKey.currentState;
    if (form.validate()) {
      form.save();
      form.reset();

      //Save data to database
      databaseReference.push().set(user.toJson());
    }
  }

  void _onChanged(Event event){
      var oldData = listUser.singleWhere((entry){
        return entry.key == event.snapshot.key;
      });

      setState(() {
        listUser[listUser.indexOf(oldData)] = User.forSnapshot(event.snapshot);
      });
  }

}
