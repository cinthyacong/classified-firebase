import 'package:flutter/material.dart';
import 'package:classifiedfire/screens/home.dart';
import 'package:classifiedfire/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ValidateScreen extends StatefulWidget {
  const ValidateScreen({Key? key}) : super(key: key);

  @override
  _ValidateScreenState createState() => _ValidateScreenState();
}

class _ValidateScreenState extends State<ValidateScreen> {
  var _isLoggedIn = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    validateAuth();
  }

  validateAuth() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      // FirebaseAuth.instance
      print(user);
      if (user == null) {
        setState(() {
          _isLoggedIn = false;
        });
      } else {
        setState(() {
          _isLoggedIn = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoggedIn ? HomeScreen() : Login();
  }
}
