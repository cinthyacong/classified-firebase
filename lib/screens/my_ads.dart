import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore_platform_interface/src/settings.dart';
import 'package:classifiedfire/screens/edit_ad.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:classifiedfire/screens/settings.dart';

class MyAds extends StatefulWidget {
  const MyAds({Key? key}) : super(key: key);

  _MyAdsState createState() => _MyAdsState();
}

class _MyAdsState extends State<MyAds> {
  var ads = [];

  fetchAds() {
    var uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance
        .collection("ads")
        .where("uid", isEqualTo: uid)
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
  void initState() {
    super.initState();
    fetchAds();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Ads"),
        backgroundColor: Colors.black,
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.blueGrey.shade200),
            onPressed: () {
              Get.to(SettingsScreen());
            }),
      ),
      body: Container(
        child: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: ads.length,
          itemBuilder: (bc, index) {
            return GestureDetector(
                onTap: () => Get.to(EditAd(
                    imgURL: ads[index]['imageURL'],
                    title: ads[index]['title'],
                    description: ads[index]['description'],
                    price: ads[index]['price'],
                    mobile: ads[index]['mobile'])),
                child: Card(
                    child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      height: 70,
                      width: 70,
                      child: Image.network("${ads[index]['imageURL']}",
                          fit: BoxFit.cover),
                      // child: CachedNetworkImage(
                      //   imageUrl: "${ads[index]['imageURL']}",
                      //   progressIndicatorBuilder:
                      //       (context, url, downloadProgress) =>
                      //           CircularProgressIndicator(
                      //               value: downloadProgress.progress),
                      //   errorWidget: (context, url, error) =>
                      //       Icon(Icons.error),
                      // )
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${ads[index]['title']}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3.0),
                          child: Row(
                            children: [
                              Icon(Icons.timer_outlined),
                              Text(
                                "8 days ago",
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              )
                            ],
                          ),
                        ),
                        Text("${ads[index]['price']}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.orange)),
                      ],
                    ),
                  ],
                )));
          },
        ),
      ),
    );
  }
}
