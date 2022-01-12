import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restaurant_app/Widgets/Button.dart';
import 'package:restaurant_app/sizeConfig/sizeConfig.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:intl/intl.dart';

import '../main.dart';
import 'delevired.dart';

class ResDetails extends StatefulWidget {

  final String? name;
  final double? number;
  final double? Total_Amount;
  final int? Total_count;
  final Timestamp? time;
  final String? userid;
  final String? status;

  const ResDetails({Key? key, this.name, this.number, this.Total_Amount, this.Total_count, this.time, this.userid, this.status}) : super(key: key);

  @override
  _ResDetailsState createState() => _ResDetailsState();
}

class _ResDetailsState extends State<ResDetails> {


  Future<void> _alertDialogBox(String text) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Confirmation",style: TextStyle(color: Colors.white),),
            content:
                Container(
                  child: button(height: SizeConfig.height!*5, width: SizeConfig.width!*15, color: Theme.of(context).accentColor, txt: "Order Completed !!",function: (){
                    Navigator.pop(context);
                    adddetails();
                    movehistroyorder();
                    deleteusercart();
                    deletefromcart();
                    Navigator.push(context,MaterialPageRoute(builder: (context)=>helper_class3()));
                  },)
                ),
          );
        });
  }



  var today = new DateTime.now();

  Future adddetails() async{
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    String formatted = formatter.format(today);
    var snapshot = await FirebaseFirestore.instance.collection("Completed Order").doc(formatted).collection("Orders").doc(widget.userid).set({
      "Name" : widget.name,
      "Number" : widget.number,
      "User Id" : widget.userid,
    });
  }

  Future movehistroyorder() async{
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    String formattedTime = DateFormat.Hms().format(today);
    String formatted = formatter.format(today);
    DocumentReference doc_ref =FirebaseFirestore.instance.collection("Completed Order").doc(formatted).collection("Orders").doc(widget.userid).collection("Orders").doc();
    var snapshot = await FirebaseFirestore.instance.collection("orders").doc(widget.userid).collection("orders").get().then((snap){
      snap.docs.forEach((doc) async{
        await doc_ref.set({
          "Date" : formatted,
          "Time" : formattedTime,
          "Id" : doc_ref.id
        }).whenComplete(() async => {
          await doc_ref.collection("Order Data").add(doc.data())
        });
      });
    });
  }

    Future movehistroyorderdetails() async{
    var snapshot = await FirebaseFirestore.instance.collection("orders").get().then((snap){
      snap.docs.forEach((doc) async{
        await FirebaseFirestore.instance.collection("Completed Order").doc(widget.userid).collection("User Details").add(doc.data());
      });
    }).whenComplete(() => print("Details Created"));
  }

  Future deletefromcart() async{
    var snapshot = FirebaseFirestore.instance.collection("orders").doc(widget.userid).collection("orders").get().then((snap) => {
      for(DocumentSnapshot ds in snap.docs){
        ds.reference.delete()
      }
    }).whenComplete(() => FirebaseFirestore.instance.collection("orders").doc(widget.userid).delete());
  }

  Future deleteusercart() async{
    var snapshot = await FirebaseFirestore.instance.collection("userdetails").doc(widget.userid).collection('currentOrders').get().then((snap) =>{
      for(DocumentSnapshot ds in snap.docs)
        {
          ds.reference.delete(),
        }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    setState(() {

    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    var food_type = ["Order Received", "Preparing", "Ready for Delivery"];
    String? initial = widget.status!;

    Future updateStatus(String value) async {
      Map<String, dynamic> data = {
        "status": value,
      };

      FirebaseFirestore.instance
          .collection("orders")
          .doc(widget.userid)
          .update(data);

    }


    return SafeArea(child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(5.0),
          child: Container(
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                            decoration: BoxDecoration(
                                image: new DecorationImage(
                                    image: AssetImage("assets/details.png")
                                )
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(
                            child: Text("Order Details",textAlign: TextAlign.center,style: Theme.of(context).textTheme.headline2!.merge(TextStyle(fontSize: SizeConfig.height! * 5))),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Container(
                    child: Column(
                      children: [
                        SizedBox(height: SizeConfig.height! * 1,),
                        Expanded(
                          flex: 2,
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: SizeConfig.width! * 2,),
                                    child: Container(
                                      //color: Colors.black,
                                      margin: EdgeInsets.only(top: SizeConfig.height! * 2),
                                      alignment: Alignment.centerLeft,
                                      child: Text(widget.name!.toUpperCase(),style: Theme.of(context).textTheme.headline2!.merge(TextStyle(fontSize: SizeConfig.height! * 2.5)),),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: SizeConfig.width! * 2),
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text("${widget.number!.truncate()}",style: Theme.of(context).textTheme.subtitle1,),
                                              IconButton(
                                                onPressed: ()async{
                                                  var num = (widget.number!.truncate()).abs().toString();
                                                  await FlutterPhoneDirectCaller.callNumber(num);
                                                  //launch(('tel://${num}'));
                                                },
                                                icon: Icon(Icons.call),
                                                color: Theme.of(context).accentColor,
                                                iconSize: SizeConfig.height! * 3,
                                              ),
                                            ],
                                          ),
                                          Container(
                                              alignment: Alignment.center,
                                              child: DropdownButton(
                                                dropdownColor:
                                                Theme.of(context).accentColor,
                                                items: food_type.map((food_types) {
                                                  return DropdownMenuItem(
                                                      value: food_types,
                                                      child: Text(food_types));
                                                }).toList(),
                                                onChanged: (type) {
                                                  setState(() {
                                                    initial = type.toString();
                                                    updateStatus(initial!);
                                                  });
                                                },
                                                value: initial,
                                              )),
                                        ],
                                      ),

                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 8,
                          child: Container(
                            child: FutureBuilder<QuerySnapshot>(
                                future: FirebaseFirestore.instance.collection('orders').doc(widget.userid).collection('orders').get(),
                                builder: (context, AsyncSnapshot snapshot) {
                                  if (snapshot.hasError) {
                                    return Scaffold(
                                      body: Center(
                                        child: Text("error: ${snapshot.error}"),
                                      ),
                                    );
                                  }

                                  if (snapshot.connectionState == ConnectionState.done) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 12),
                                      child: ListView(
                                        children: snapshot.data!.docs.map<Widget>((document) {
                                          return Padding(
                                            padding: EdgeInsets.symmetric(vertical: SizeConfig.height! * 2,horizontal: SizeConfig.width! * 2),
                                            child: Container(
                                                height: SizeConfig.height! * 10,
                                                width: SizeConfig.width! * 25,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(15),
                                                    color: Theme.of(context).primaryColor
                                                ),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.only(topLeft: Radius.circular(15),bottomLeft: Radius.circular(15)),
                                                              image: new DecorationImage(
                                                                image: NetworkImage(document['image']),
                                                                fit: BoxFit.cover,
                                                              )
                                                          ),
                                                        )
                                                    ),
                                                    Expanded(
                                                        flex: 2,
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.only(topRight: Radius.circular(15),bottomRight: Radius.circular(15)),
                                                          ),
                                                          alignment: Alignment.center,
                                                          child: Text("${document['name']}".toUpperCase(),style: Theme.of(context).textTheme.subtitle1,),
                                                        )
                                                    ),
                                                    Expanded(
                                                        child: Container(
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                            children: [
                                                              Text("Count",style: Theme.of(context).textTheme.subtitle1,),
                                                              Text(document['count'],style: Theme.of(context).textTheme.headline2,),
                                                            ],
                                                          ),
                                                        )
                                                    ),
                                                  ],
                                                )
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    );
                                  }

                                  return Scaffold(
                                    body: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                }),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            margin: EdgeInsets.only(right: SizeConfig.width! * 2),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(15)
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(width: SizeConfig.width! * 0.5,),
                                    Expanded(
                                        child: Container(
                                            alignment: Alignment.center,
                                            child: Text(
                                              "Total Count: ",
                                              textAlign: TextAlign.center,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle2,
                                            ))),
                                    Expanded(
                                      child: Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                            "${widget.Total_count}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline2!.merge(TextStyle(fontSize: SizeConfig.height! * 2.5,color: Theme.of(context).focusColor)),
                                          )),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    SizedBox(width: SizeConfig.width! * 0.5,),
                                    Expanded(
                                        child: Container(
                                            alignment: Alignment.center,
                                            child: Text(
                                              "Total Amount: ",
                                              textAlign: TextAlign.center,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle2,
                                            ))),
                                    Expanded(
                                      child: Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                            "₹ ${widget.Total_Amount}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline2!.merge(TextStyle(fontSize: SizeConfig.height! * 2.5,color: Theme.of(context).focusColor)),
                                          )),
                                    )
                                  ],
                                ),

                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: SizeConfig.width! * 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8.0),
                                  child: GestureDetector(
                                    onTap: (){
                                      Navigator.of(context).pop();
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: Text("BACK TO ORDERS",style: Theme.of(context).textTheme.subtitle1,),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8.0),
                                  child: GestureDetector(
                                    onTap: (){
                                      _alertDialogBox("Order Completed !!!");

                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: Text("COMPLETED",style: Theme.of(context).textTheme.subtitle1,),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
    ));
  }
}
