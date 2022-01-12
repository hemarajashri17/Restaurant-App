import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class Checker extends StatefulWidget {
  @override
  _CheckerState createState() => _CheckerState();
}

class _CheckerState extends State<Checker> {
  final Future<FirebaseApp> _intialization = Firebase.initializeApp();
  bool ans = true;
  String? role;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _intialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text("error: ${snapshot.error}"),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, Streamsnapshot) {
                if (Streamsnapshot.hasError) {
                  return Scaffold(
                      body: Center(
                    child: Text(
                      "error: ${Streamsnapshot.error}",
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ));
                }
                if (Streamsnapshot.connectionState == ConnectionState.active) {
                  User? _user = Streamsnapshot.data as User?;
                  if(_user == null){
                    return MyApp();
                  }else{
                    return userfinder();
                  }
                }
                return Scaffold(
                  body: Center(
                    child: Text(
                      "Checking Authentication",
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ),
                );
              },
            );
          }
          return Scaffold(
            body: Center(
              child: Text("Intialising App....."),
            ),
          );
        });
  }
}

class userfinder extends StatefulWidget {

  @override
  _userfinderState createState() => _userfinderState();
}

class _userfinderState extends State<userfinder> {

  String? role;

  Future<void> checkrole() async {
    User user = FirebaseAuth.instance.currentUser!;
    final DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection("userdetails")
        .doc(user.uid)
        .get();
    setState(() {
      role = snap['role'];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkrole();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return (role == 'admin')? helper_class3() : helper_class2();
  }
}
