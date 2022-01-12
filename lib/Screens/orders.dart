import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restaurant_app/Widgets/Button.dart';
import 'package:restaurant_app/Widgets/OrderContainer1.dart';
import 'package:restaurant_app/sizeConfig/sizeConfig.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class Orders extends StatefulWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  String userid = FirebaseAuth.instance.currentUser!.uid;
  String status = "No Orders Yet";

  Future getStatus() async {
    var Snapshot = await FirebaseFirestore.instance
        .collection("orders")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    if (Snapshot.exists) {
      setState(() {
        this.status = Snapshot.get('status').toString();
      });
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStatus();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: SizeConfig.height! * 25,
                              width: SizeConfig.width! * 2,
                              decoration: BoxDecoration(
                                  image: new DecorationImage(
                                      image: AssetImage("assets/history.png"),
                                      fit: BoxFit.fill)),
                            ),
                          )),
                      Expanded(
                          flex: 2,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: SizeConfig.height! * 3),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Your Orders  🍱",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline2!
                                          .merge(TextStyle(
                                          fontSize:
                                          SizeConfig.height! * 4)),
                                    ),
                                  ),
                                ),
                                Divider(
                                  height: SizeConfig.height! * 2,
                                  color: Theme.of(context).focusColor,
                                ),
                                Expanded(
                                  child: Container(
                                      alignment: Alignment.centerRight,
                                      child: RichText(
                                        text: TextSpan(
                                          text: "Order Status : ",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1!
                                              .merge(TextStyle(
                                              color: Theme.of(context)
                                                  .buttonColor)),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: '$status'.toUpperCase(),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Theme.of(context)
                                                        .focusColor)),
                                          ],
                                        ),
                                      )),
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                )),

            Expanded(
              flex: 8,
                child: FutureBuilder<QuerySnapshot>(
                  future: FirebaseFirestore.instance
                      .collection("userdetails")
                      .doc(userid)
                      .collection("currentOrders")
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Scaffold(
                        body: Center(
                          child: Text("Error : ${snapshot.error}"),
                        ),
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.done) {
                      return snapshot.data!.docs.isEmpty
                          ? Center(
                          child: Column(
                            children: [
                              Container(
                                height: SizeConfig.height! * 40,
                                width: SizeConfig.width! * 60,
                                decoration: BoxDecoration(
                                    image: new DecorationImage(
                                        image: AssetImage("assets/empty.png"),
                                        fit: BoxFit.fill)),
                              ),
                              SizedBox(
                                height: SizeConfig.height! * 5,
                              ),
                              Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "No order has been placed !",
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1!
                                        .merge(TextStyle(
                                        fontSize:
                                        SizeConfig.height! * 3)),
                                  )),
                            ],
                          ))
                          : Container(
                        height: SizeConfig.height! * 250,
                        child: ListView(
                            children: snapshot.data!.docs.map((document) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: SizeConfig.height! * 14,
                                  child: OrderContainer(
                                    collectionName:
                                    document['Collection_name'],
                                    name: document['name'],
                                    img: document['image'],
                                    price: document['price'],
                                    type: document['type'],
                                    count: document['count'],
                                    doc_id: document['doc_id'],
                                  ),
                                ),
                              );
                            }).toList()),
                      );
                    }
                    return Scaffold(
                      body: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  },
                )),
            Expanded(
                child: Center(
                    child: Container(
                        alignment: Alignment.center,
                        margin:
                        EdgeInsets.only(left: SizeConfig.width! * 2),
                        child: button(
                            txt: "Continue Shopping",
                            height: SizeConfig.height! * 4,
                            width: SizeConfig.width! * 45,
                            color: Theme.of(context).accentColor,
                            function: () {
                              Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          helper_class2()));
                            })))),

          ],
        ),
      ),
    );
  }
}
