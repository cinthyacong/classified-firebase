import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:classifiedfire/screens/home.dart';
import 'package:classifiedfire/screens/register.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Login extends StatelessWidget {
  Login({Key? key}) : super(key: key);

  TextEditingController _emailCtrl = TextEditingController();
  TextEditingController _passwordCtrl = TextEditingController();

  // Auth _auth = Get.put(Auth());

  login() {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: _emailCtrl.text, password: _passwordCtrl.text)
        .then((value) {
      print("Login Success");
      Get.to(HomeScreen());
    }).catchError((e) {
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Container(
            color: Colors.white,
            child: Center(
                child: SingleChildScrollView(
              reverse: true,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                          height: 300,
                          width: double.infinity,
                          child: Image.network(
                              "https://i.postimg.cc/yJrkHqD9/background.png",
                              fit: BoxFit.cover)),
                      Container(
                        child: Image.network(
                            "https://i.postimg.cc/ZBB0YfNQ/logo.png"),
                      ),
                    ],
                  ),
                  Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          TextField(
                            controller: _emailCtrl,
                            style: TextStyle(color: Colors.black),
                            decoration: new InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.black26, width: 2.0),
                              ),
                              border: new OutlineInputBorder(
                                  borderSide:
                                      new BorderSide(color: Colors.black26)),
                              labelText: 'Email Address',
                              labelStyle: TextStyle(color: Colors.black26),
                            ),
                          ),
                          SizedBox(
                            child: Container(
                              height: 30,
                            ),
                          ),
                          TextField(
                            controller: _passwordCtrl,
                            style: TextStyle(color: Colors.black),
                            decoration: new InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.black26, width: 2.0),
                              ),
                              border: new OutlineInputBorder(
                                  borderSide:
                                      new BorderSide(color: Colors.black26)),
                              labelText: 'Password',
                              labelStyle: TextStyle(color: Colors.black26),
                            ),
                          ),
                          SizedBox(
                            child: Container(
                              height: 30,
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.deepOrange,
                                minimumSize: Size(double.infinity, 50)),
                            onPressed: () {
                              login();
                            },
                            child: Text(
                              'Login',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                                minimumSize: Size(double.infinity, 50)),
                            onPressed: () => Get.to(Register()),
                            child: Text(
                              "Don't have any account",
                              style: TextStyle(
                                  color: Colors.deepOrange, fontSize: 15),
                            ),
                          ),
                        ],
                      ))
                ],
              ),
            ))),
      ),
    );
  }
}

// class LoginScreen extends StatelessWidget {
//   LoginScreen({Key? key}) : super(key: key);

//   TextEditingController _emailCtrl = TextEditingController();
//   TextEditingController _pwdCtrl = TextEditingController();

//   login() {
//     FirebaseAuth.instance
//         .signInWithEmailAndPassword(
//             email: _emailCtrl.text, password: _pwdCtrl.text)
//         .then((value) {
//       print("Login Success");
//       // Get.to(HomeScreen());
//     }).catchError((e) {
//       print(e);
//     });
//   }

//   register() {
//     FirebaseAuth.instance
//         .createUserWithEmailAndPassword(
//             email: _emailCtrl.text, password: _pwdCtrl.text)
//         .then((res) {
//       print("Register Success");
//       // FirebaseFirestore.instance.collection("users").add({
//       //   "email": _emailCtrl.text,
//       //   "uid": res.user?.uid,
//       // });
//       var uid = res.user?.uid;
//       FirebaseFirestore.instance.collection("users").doc(uid).set({
//         "email": _emailCtrl.text,
//         "uid": res.user?.uid,
//       });
//       // Get.to(HomeScreen());
//     }).catchError((e) {
//       print(e);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: Container(
//         width: double.infinity,
//         child: Column(
//           children: [
//             TextField(
//               controller: _emailCtrl,
//             ),
//             TextField(
//               controller: _pwdCtrl,
//             ),
//             Row(
//               children: [
//                 TextButton(
//                   child: Text("Login"),
//                   onPressed: () {
//                     login();
//                   },
//                 ),
//                 TextButton(
//                   child: Text("Register"),
//                   onPressed: () {
//                     register();
//                   },
//                 )
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
