import 'package:bloodify/screen/authenticate/sign_in.dart';
import 'package:bloodify/services/auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ForgetPassword extends StatefulWidget {
  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();

  //text field state
  String email = '';
  String password = '';
  String status = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.red,
        elevation: 0.0,
        title: Text('Forgot Password'),
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
            child: Form(
              key: _formKey,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                        "We'll send the password reset link if you're registered with the given email address"),
                    const SizedBox(
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
                    const SizedBox(
                      height: 10.0,
                    ),
                    SizedBox(
                      height: 50.0,
                      width: 150.0,
                      child: ElevatedButton(
                        //color: Colors.red,
                        child: Text("Register".toUpperCase(),
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
                            await _auth.resetPassword(email);
                            // setState(() {
                            //   status =
                            //       "We've sent the password reset link in the given email address";
                            // }
                            Navigator.pop(context);
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 12.0,
                    ),
                    Text(
                      status,
                      style:
                          const TextStyle(color: Colors.black, fontSize: 14.0),
                    ),
                  ]),
            )),
      ),
    );
  }
}