import 'package:classifiedfire/screens/my_ads.dart';
import 'package:classifiedfire/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:classifiedfire/screens/profile.dart';
import 'package:classifiedfire/screens/creat_ad.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({Key? key}) : super(key: key);

  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    readAdsData();
    readUserData();
  }

  List _adsData = [];
  String name = "";
  String mobile = "";
  String image = "";

  readAdsData() {
    var uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("ads")
        .get()
        .then((snapshot) {
      snapshot.docs.forEach((doc) {
        // adDataList.add(doc.data());
        _adsData.add({"adID": doc.id, "adData": doc.data()});
      });
      setState(() {});
    });
  }

  readUserData() {
    var uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance.collection("users").doc(uid).get().then((resp) {
      name = resp["username"];
      mobile = resp["mobile"];
      image = resp["imageURL"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.blueGrey.shade200),
          onPressed: () => Get.to(HomeScreen()),
        ),
      ),
      body: ListView(
        children: [
          GestureDetector(
            onTap: () => Get.to(Profile()),
            child: ListTile(
              leading: CircleAvatar(
                radius: 20,
                child: ClipOval(
                    child: CachedNetworkImage(
                  imageUrl: image,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      CircularProgressIndicator(
                          value: downloadProgress.progress),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                )),
              ),
              title: Row(
                children: [
                  Text(name),
                ],
              ),
              subtitle: Text(mobile),
              trailing: Text(
                "Edit",
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.orange,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Get.to(MyAds()),
            child: ListTile(
                leading: Icon(
                  Icons.post_add,
                  size: 27.0,
                ),
                title: Text("My Ads")),
          ),
          ListTile(
              leading: Icon(
                Icons.person,
                size: 27.0,
              ),
              title: Text("About Us")),
          ListTile(
              leading: Icon(
                Icons.contacts,
                size: 27.0,
              ),
              title: Text("Contact Us")),
        ],
      ),
    );
  }
}
