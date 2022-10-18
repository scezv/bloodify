import 'package:bloodify/screen/authenticate/forgot_password.dart';
import 'package:bloodify/services/auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({required this.toggleView});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();

  //text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.red,
        elevation: 0.0,
        title: Text('Welcome'),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text('Register'),
            onPressed: () {
              widget.toggleView();
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
            child: Form(
              key: _formKey,
              child: Column(children: <Widget>[
                Container(
                  child: Image.asset('assets/img/logo.png'),
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                      hintText: 'Enter your email address',
                      labelText: 'Email',
                      floatingLabelStyle: TextStyle(color: Colors.red),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red))),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your email address';
                    }
                    // Check if the entered email has the right format
                    if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    // Return null if the entered email is valid
                    return null;
                  },
                  onChanged: (val) {
                    setState(() {
                      email = val;
                    });
                  },
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                      hintText: 'Password',
                      labelText: 'Password',
                      floatingLabelStyle: TextStyle(color: Colors.red),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red))),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'This field is required';
                    }
                    if (value.trim().length < 6) {
                      return 'Password must be at least 6 characters in length';
                    }
                    // Return null if the entered password is valid
                    return null;
                  },
                  obscureText: true,
                  onChanged: (val) {
                    setState(() => password = val);
                  },
                ),
                const SizedBox(height: 10.0),
                RichText(
                  // textAlign: TextAlign.right,
                  text: TextSpan(
                    children: [
                      TextSpan(
                          text: 'Forgot Password?',
                          style: const TextStyle(
                            color: Colors.red,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ForgetPassword(),
                                ),
                              );
                            }),
                    ],
                  ),
                ),
                SizedBox(height: 20.0),
                SizedBox(
                  height: 50.0,
                  width: 150.0,
                  child: ElevatedButton(
                    //color: Colors.red,
                    child: Text("Sign In".toUpperCase(),
                        style: TextStyle(fontSize: 14)),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                      elevation: 3,
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        dynamic result =
                            _auth.signInWithEmailAndPassword(email, password);
                        print('result is $result');
                        if (result == null) {
                          setState(() {
                            error = 'Sign in failed with these credentials';
                          });
                        }
                      }
                    },
                  ),
                ),
                const SizedBox(
                  height: 12.0,
                ),
                Text(
                  error,
                  style: const TextStyle(color: Colors.red, fontSize: 14.0),
                ),
              ]),
            )),
      ),
    );
  }
}
