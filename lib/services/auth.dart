import 'package:bloodify/models/user.dart';
import 'package:bloodify/screen/home/globals.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //create user object based on FirebaseUser
  Userr? _userFromFirebase(User? user) {
    return user != null ? Userr(uid: user.uid) : null;
  }

  //auth change user stream
  Stream<Userr?> get user {
    return _auth
        .authStateChanges()
        .map((User? user) => _userFromFirebase(user));
  }

  //sign in anon
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userFromFirebase(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    //print('$email and $password');
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      print('user signed in');
      User? user = result.user;
      return _userFromFirebase(user);
    } on FirebaseAuthException catch (e) {
      if (e.message ==
          'There is no user record corresponding to this identifier. The user may have been deleted.') {
        final SnackBar snackBar =
            SnackBar(content: Text("No user with this email"));
        snackbarKey.currentState?.showSnackBar(snackBar);
      } else {
        final SnackBar snackBar = SnackBar(content: Text("${e.message}"));
        snackbarKey.currentState?.showSnackBar(snackBar);
      }
      return null;
    }
  }

  //register with email and password
  Future registerWithEmailAndPassword(String email, String password) async {
    print('$email and $password');
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      //print('user created');
      User? user = result.user;
      return _userFromFirebase(user);
    } on FirebaseAuthException catch (e) {
      //print(e.message);
      final SnackBar snackBar = SnackBar(content: Text("${e.message}"));
      snackbarKey.currentState?.showSnackBar(snackBar);
      return null;
    }
  }

  //sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
      //print('user signed out');
    } on FirebaseAuthException catch (e) {
      final SnackBar snackBar = SnackBar(content: Text("${e.message}"));
      snackbarKey.currentState?.showSnackBar(snackBar);
      return null;
    }
  }

  //reset password
  Future resetPassword(email) async {
    print(email);
    try {
      await _auth.sendPasswordResetEmail(email: email);
      final SnackBar snackBar = SnackBar(content: Text("Reset e-mail sent"));
      snackbarKey.currentState?.showSnackBar(snackBar);
    } on FirebaseAuthException catch (e) {
      //print(e.code);
      //print(e.message);
      if (e.message ==
          'There is no user record corresponding to this identifier. The user may have been deleted.') {
        final SnackBar snackBar =
            SnackBar(content: Text("No user with this email"));
        snackbarKey.currentState?.showSnackBar(snackBar);
      } else {
        final SnackBar snackBar = SnackBar(content: Text("${e.message}"));
        snackbarKey.currentState?.showSnackBar(snackBar);
      }
    }
  }
}
