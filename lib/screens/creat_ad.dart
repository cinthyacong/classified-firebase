import 'package:classifiedfire/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'dart:math';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:classifiedfire/screens/login.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateAd extends StatefulWidget {
  CreateAd({Key? key}) : super(key: key);

  @override
  _CreateAdState createState() => _CreateAdState();
}

class _CreateAdState extends State<CreateAd> {
  TextEditingController _titleCtrl = TextEditingController();
  TextEditingController _descriptionCtrl = TextEditingController();
  TextEditingController _priceCtrl = TextEditingController();
  TextEditingController _mobileCtrl = TextEditingController();
  var imageURL = [];

  uploadImage() async {
    var picker = ImagePicker();
    var pickedFiles = await picker.pickMultiImage();
    if (pickedFiles!.isNotEmpty) {
      imageURL.clear();
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
              imageURL.add(url);
            });
          });
        }).catchError((e) {});
      }
    }
  }

  createAd() {
    FirebaseFirestore.instance.collection("ads").add({
      "title": _titleCtrl.text,
      "description": _descriptionCtrl.text,
      "price": _priceCtrl.text,
      "mobile": _mobileCtrl.text,
      "uid": FirebaseAuth.instance.currentUser!.uid,
      "imageURL": imageURL,
    }).then((value) {
      print("Added");
    }).catchError((e) {
      print(e);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.blueGrey.shade200),
          onPressed: () => Get.to(HomeScreen()),
        ),
        title: Text("Create Ad"),
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
                  IconButton(
                    icon: const Icon(Icons.add_a_photo_outlined),
                    iconSize: 50,
                    onPressed: () {
                      uploadImage();
                    },
                  ),
                  Text('Tap to Upload'),
                  imageURL.isNotEmpty
                      ? Container(
                          width: 90,
                          height: 90,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: imageURL.length,
                              itemBuilder: (bc, index) {
                                return Image.network(
                                  imageURL[index],
                                );
                              }))
                      : Container(),
                  Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          SizedBox(
                            child: Container(
                              height: 30,
                            ),
                          ),
                          TextField(
                            controller: _titleCtrl,
                            style: const TextStyle(color: Colors.black),
                            decoration: const InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.black26, width: 2.0),
                              ),
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.black26)),
                              labelText: 'Title',
                              labelStyle: TextStyle(color: Colors.black26),
                            ),
                          ),
                          SizedBox(
                            child: Container(
                              height: 30,
                            ),
                          ),
                          TextField(
                            controller: _priceCtrl,
                            style: const TextStyle(color: Colors.black),
                            decoration: new InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.black26, width: 2.0),
                              ),
                              border: new OutlineInputBorder(
                                  borderSide:
                                      new BorderSide(color: Colors.black26)),
                              labelText: 'Price',
                              labelStyle: TextStyle(color: Colors.black26),
                            ),
                          ),
                          SizedBox(
                            child: Container(
                              height: 30,
                            ),
                          ),
                          TextField(
                            controller: _mobileCtrl,
                            style: TextStyle(color: Colors.black),
                            decoration: new InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.black26, width: 2.0),
                              ),
                              border: new OutlineInputBorder(
                                  borderSide:
                                      new BorderSide(color: Colors.black26)),
                              labelText: 'Contact Number',
                              labelStyle: TextStyle(color: Colors.black26),
                            ),
                          ),
                          SizedBox(
                            child: Container(
                              height: 30,
                            ),
                          ),
                          TextField(
                            controller: _descriptionCtrl,
                            style: TextStyle(color: Colors.black),
                            decoration: new InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.black26, width: 2.0),
                              ),
                              border: new OutlineInputBorder(
                                  borderSide:
                                      new BorderSide(color: Colors.black26)),
                              labelText: 'Description',
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
                              createAd();
                              Get.to(HomeScreen());
                            },
                            child: Text(
                              'Submit Ad ',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
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
