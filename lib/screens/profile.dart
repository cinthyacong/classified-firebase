import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:classifiedfire/screens/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:math';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Profile extends StatefulWidget {
  Profile({Key? key}) : super(key: key);

  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  void initState() {
    super.initState();
    readUserData();
  }

  TextEditingController _nameUpdate = TextEditingController();
  TextEditingController _emailUpdate = TextEditingController();
  TextEditingController _mobileUpdate = TextEditingController();
  // TextEditingController _imageUpdate = TextEditingController();
  String imgURL = "";

  uploadImage() async {
    var picker = ImagePicker();
    var pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile!.path.length != 0) {
      File image = File(pickedFile.path);
      var rng = new Random();

      FirebaseStorage.instance
          .ref()
          .child("images")
          .child(rng.nextInt(10000).toString())
          .putFile(image)
          .then((res) {
        print(res);
        res.ref.getDownloadURL().then((url) {
          setState(() {
            imgURL = url;
          });
        });
      }).catchError((e) {
        print(e);
      });
    } else {
      print("No file picked");
    }
  }

  logout() {
    FirebaseAuth.instance.signOut().then((value) {
      Get.offAll(Login());
    });
  }

  readUserData() {
    var uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance.collection("users").doc(uid).get().then((user) {
      print(user.data());
      var userData = user.data()!;
      _nameUpdate.text = userData["username"];
      _emailUpdate.text = userData["email"];
      _mobileUpdate.text = userData["mobile"];
      imgURL = userData["imageURL"];
      print(imgURL);
    });
  }

  updateProfile() {
    var uid = FirebaseAuth.instance.currentUser!.uid;

    FirebaseFirestore.instance.collection("users").doc(uid).update({
      "username": _nameUpdate.text,
      "email": _emailUpdate.text,
      "mobile": _mobileUpdate.text,
      "imageURL": imgURL,
    }).then((value) {
      print("Update");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Text("Edit Profile"),
      ),
      body: Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          color: Colors.white,
          // child: Center(
          child: SingleChildScrollView(
            // reverse: true,
            child: Column(
              children: [
                SizedBox(
                  child: Container(
                    height: 25,
                  ),
                ),
                Container(
                  child: CircleAvatar(
                    radius: 50,
                    // child: GestureDetector(
                    //   onTap: (uploadImage()),
                    child: ClipOval(
                        child: CachedNetworkImage(
                      imageUrl: imgURL,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) =>
                              CircularProgressIndicator(
                                  value: downloadProgress.progress),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    )),
                  ),
                ),
                // ),
                SizedBox(
                  child: Container(
                    height: 30,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextField(
                      controller: _nameUpdate,
                      style: TextStyle(color: Colors.black),
                      decoration: new InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black26, width: 2.0),
                        ),
                        border: new OutlineInputBorder(
                            borderSide: new BorderSide(color: Colors.black26)),
                        // labelText: _user['name'],
                        labelStyle: TextStyle(color: Colors.black54),
                      ),
                    ),
                    SizedBox(
                      child: Container(
                        height: 20,
                      ),
                    ),
                    TextField(
                      controller: _emailUpdate,
                      style: TextStyle(color: Colors.black),
                      decoration: new InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black26, width: 2.0),
                        ),
                        border: new OutlineInputBorder(
                            borderSide: new BorderSide(color: Colors.black26)),
                        // labelText: _user['email'],
                        labelStyle: TextStyle(color: Colors.black54),
                      ),
                    ),
                    SizedBox(
                      child: Container(
                        height: 20,
                      ),
                    ),
                    TextField(
                      controller: _mobileUpdate,
                      style: TextStyle(color: Colors.black),
                      decoration: new InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black26, width: 2.0),
                          ),
                          border: new OutlineInputBorder(
                              borderSide:
                                  new BorderSide(color: Colors.black26)),
                          // labelText: _user['mobile'],
                          labelStyle: TextStyle(
                            color: Colors.black54,
                          )),
                    ),
                    SizedBox(
                      child: Container(
                        height: 20,
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.deepOrange,
                          minimumSize: Size(double.infinity, 50)),
                      onPressed: () {
                        updateProfile();
                      },
                      child: Text(
                        'Update Profile',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                    SizedBox(
                      child: Container(
                        height: 30,
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          primary: Colors.white,
                          minimumSize: Size(double.infinity, 50)),
                      onPressed: () {
                        logout();
                      },
                      child: Text(
                        'Logout',
                        style:
                            TextStyle(color: Colors.deepOrange, fontSize: 15),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )),
    );
  }
}
