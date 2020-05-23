import 'package:firebase_app/ui/login/signup_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../home_page.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  String _email, _password;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> signIn() async {
    final formState = _formKey.currentState;

    if (formState.validate()) {
      formState.save();
      //
      try {
        AuthResult user = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _email, password: _password);

        print("User name: " + user.user.email + "Password: " + _password);

        Navigator.pop(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      } catch (e) {
        print(e.message);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 200, left: 20, right: 20, bottom: 20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                   validator: (inout){
                    if(inout.isEmpty){
                      return "Please enter your email";
                    }
                  },
                   onSaved: (input) => _email = input,
                  decoration: InputDecoration(hintText: "Email"),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                   validator: (inout){
                    if(inout.isEmpty){
                      return "Please enter your password";
                    }
                  },
                  obscureText: true,
                  onSaved: (input) => _password = input,
                  decoration: InputDecoration(hintText: "Password"),
                ),
                SizedBox(
                  height: 20,
                ),
                RaisedButton(
                  child: Text("login"),
                  onPressed: signIn,
                ),
                FlatButton(
                  child: Text("SignUp"),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SignUpPage()));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
