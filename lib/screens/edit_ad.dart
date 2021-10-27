// import 'package:classified_app/screens/add_list.dart';
import 'package:classifiedfire/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:math';

class EditAd extends StatefulWidget {
  var imgURL = [];
  String title = "";
  String description = "";
  String price = "";
  String mobile = "";

  // // int id;

  EditAd({
    required this.imgURL,
    required this.title,
    required this.description,
    required this.price,
    required this.mobile,
  });

  _EditAdState createState() => _EditAdState();
}

class _EditAdState extends State<EditAd> {
  @override
  void initState() {
    setState(() {
      _titleUpdate.text = widget.title;
      _descriptionUpdate.text = widget.description;
      _priceUpdate.text = widget.price;
      _mobileUpdate.text = widget.mobile;
      // userID = widget.user;
    });
    super.initState();
  }

  TextEditingController _titleUpdate = TextEditingController();
  TextEditingController _descriptionUpdate = TextEditingController();
  TextEditingController _priceUpdate = TextEditingController();
  TextEditingController _mobileUpdate = TextEditingController();

  var ImgUpdate = [];

  uploadImage() async {
    var picker = ImagePicker();
    var pickedFiles = await picker.pickMultiImage();
    if (pickedFiles!.isNotEmpty) {
      ImgUpdate.clear();
      for (var image in pickedFiles) {
        File img = File(image.path);
        var rng = Random();
        FirebaseStorage.instance
            .ref()
            .child("images")
            .child(rng.nextInt(10000).toString())
            .putFile(img)
            .then((res) {
          res.ref.getDownloadURL().then((url) {
            setState(() {
              ImgUpdate.add(url);
            });
          });
        }).catchError((e) {});
      }
    }
  }

  updateAd() {
    var uid = FirebaseAuth.instance.currentUser!.uid;

    FirebaseFirestore.instance.collection("ads").doc(uid).update({
      "username": _titleUpdate.text,
      "email": _descriptionUpdate.text,
      "price": _priceUpdate.text,
      "mobile": _mobileUpdate.text,
      "imageURL": ImgUpdate,
    }).then((value) {
      print("Update Ad");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.blueGrey.shade200),
            onPressed: () => Get.to(HomeScreen()),
          ),
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            IconButton(
              icon: const Icon(Icons.add_a_photo_outlined),
              iconSize: 50,

              // tooltip: 'Increase volume by 10',
              onPressed: () {
                uploadImage();
              },
            ),
            Text('Tap to Upload'),
            SizedBox(height: 20),
            GridView.builder(
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
              itemCount: widget.imgURL.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, index) {
                return Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      height: 70,
                      width: 70,
                      child: Image.network(
                        widget.imgURL[index],
                      ),
                    )
                  ],
                );
              },
            ),
            SizedBox(height: 20),
            Container(
              margin: EdgeInsets.only(right: 10, left: 10),
              child: Column(
                children: [
                  TextField(
                    controller: _titleUpdate,
                    style: TextStyle(color: Colors.black),
                    decoration: new InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black26, width: 2.0),
                      ),
                      border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.black26)),
                      labelText: 'Title',
                      labelStyle: TextStyle(color: Colors.black54),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _priceUpdate,
                    style: TextStyle(color: Colors.black),
                    decoration: new InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black26, width: 2.0),
                      ),
                      border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.black26)),
                      labelText: 'Price',
                      labelStyle: TextStyle(color: Colors.black54),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _mobileUpdate,
                    style: TextStyle(color: Colors.black),
                    decoration: new InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black26, width: 2.0),
                      ),
                      border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.black26)),
                      labelText: 'Mobile',
                      labelStyle: TextStyle(color: Colors.black54),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _descriptionUpdate,
                    style: TextStyle(color: Colors.black),
                    decoration: new InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black26, width: 2.0),
                      ),
                      border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.black26)),
                      labelText: 'Description',
                      labelStyle: TextStyle(color: Colors.black54),
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
                      updateAd();
                      Get.to(HomeScreen());
                    },
                    child: Text(
                      'Update Ad',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                ],
              ),
            )
          ],
        )));

    // ));
  }
}
