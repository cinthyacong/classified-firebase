import 'package:classifiedfire/screens/creat_ad.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore_platform_interface/src/settings.dart';
import 'package:classifiedfire/screens/contact_seller.dart';
import 'package:classifiedfire/screens/settings.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    allAds();
    super.initState();
  }

  var ads = [];

  allAds(){
    var uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance
        .collection("ads")
        // .where("uid", isEqualTo: uid)
        // .orderBy("price", descending: true)
        // .limit(3)
        .get()
        .then((res) {
      var tmpAds = [];
      res.docs.forEach((ad) {
        tmpAds.add({
          "title": ad.data()["title"],
          "description": ad.data()["description"],
          "price": ad.data()["price"],
          "imageURL": ad.data()["imageURL"]
        });
      });
      setState(() {
        ads = tmpAds;
      });
    }).catchError((e) {
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          titleSpacing: 0.0,
          backgroundColor: Colors.black,
          elevation: 0,
          title: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                    child: Text(
                  "Ads Listing",
                  style: TextStyle(fontSize: 18),
                )),
                GestureDetector(
                  onTap: () => Get.to(SettingsScreen()),
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0, 8, 10, 8),
                    child: CircleAvatar(
                      backgroundImage:
                          NetworkImage("https://picsum.photos/200"),
                    ),
                    decoration: new BoxDecoration(
                      border: new Border.all(),
                      borderRadius:
                          new BorderRadius.all(new Radius.circular(50.0)),
                    ),
                  ),
                ),
              ],
            ),
          )),
      body: GridView.builder(
        itemCount: ads.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemBuilder: (BuildContext context, index) {
          return GestureDetector(
            onTap: () => Get.to(ContactDetail(
              imgURL: ads[index]['imageURL'],
              // id: _adds[index]['_id'],
              title: ads[index]['title'],
              description: ads[index]['description'],
              price: ads[index]['price'],
           
            )),
            child: Stack(
              children: [
                Align(
                  // alignment: Alignment.center,
                  child: Container(
                    margin: EdgeInsets.only(top: 10),
                    height: double.infinity,
                    width: double.infinity,
                    child: Image.network(
                      "${ads[index]['imageURL']}",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 50,
                    color: Colors.black.withOpacity(0.8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FittedBox(
                                child: Container(
                                  margin: EdgeInsets.only(left: 5),
                                  child: Text(
                                    "${ads[index]['title']}",
                                    overflow: TextOverflow.fade,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              FittedBox(
                                child: Container(
                                  margin: EdgeInsets.only(top: 2, left: 5),
                                  child: Text(
                                    "${ads[index]['price']}",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.orange,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrange,
        child: Icon(Icons.add_a_photo_outlined),
        onPressed: () => Get.to(CreateAd()),
      ),
    );
  }
}
