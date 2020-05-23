import 'package:firebase_app/ui/login/signin_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String _email, _password;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> signUp() async {
    final formState = _formKey.currentState;

    if (formState.validate()) {
      formState.save();
      //
      try {
        AuthResult user = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: _email, password: _password);

        print("User name: " + user.user.email);

        Navigator.pop(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignInPage()));
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
                TextFormField(
                  decoration: InputDecoration(hintText: "Comfirm password"),
                ),
                SizedBox(
                  height: 20,
                ),
                RaisedButton(
                  child: Text("Sign Up"),
                  onPressed: signUp,
                ),
                FlatButton(
                  child: Text("Sign In"),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SignInPage()));
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
