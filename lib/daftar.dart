import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_firebase/maincrud.dart';
import 'package:crud_firebase/palette.dart';
import 'package:crud_firebase/screentwo.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/scheduler.dart';

import 'user/login.dart';

//void main() async{
//  WidgetsFlutterBinding.ensureInitialized();
//  await Firebase.initializeApp();
//  runApp(Daftar());
//}
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //ERROR NAVIGATOR GUNAKAN MATERIALAPP
  runApp(MaterialApp(
    home: Daftar() ,
  ),
  );
}

class Daftar extends StatefulWidget {
  @override
  _DaftarState createState() => _DaftarState();
}

class _DaftarState extends State<Daftar> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  String data = "";
  Random random = new Random();

  Future<void> _data() async {
//    int rand = random.nextInt(99999);
    await Firebase.initializeApp();
    setState(() {
      data = username.text;
    });

    CollectionReference collectionReference = FirebaseFirestore.instance.collection('user');
    FirebaseFirestore.instance
        .collection('user')
        .doc(data)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (!documentSnapshot.exists) {
        print('Document does not exist on the database');
        collectionReference.doc(data).set({
          'full_name': username.text, // John Doe
          'password': password.text, // Stokes and Sons
        })
            .then((value) => print("User Added"))
            .catchError((error) => print("Failed to add user: $error"));
        Navigator.push(context, new MaterialPageRoute(
            builder: (context) => Login()
        ));

      }else{
        print('Document udah ada');
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => MainCrud()));
      }
    });

  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Daftar", style: TextStyle(fontSize: 30.0),),
              Container(
                height: 300.0,
                width: 600.0,
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10.0)
                ),
                child:
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextFormField(
                      controller: username,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.person),
                        hintText: 'Your Username',
                        labelText: 'Username',
                      ),
                      onSaved: (String value) {
                        // This optional block of code can be used to run
                        // code when the user saves the form.
                      },
                      validator: (String value) {
                        return value.contains('@') ? 'Do not use the @ char.' : null;
                      },
                    ),

                    TextFormField(
                      controller: password,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.lock),
                        hintText: 'Your Password',
                        labelText: 'Password',
                      ),
                      autofocus: false,
                      obscureText: true,
                      onSaved: (String value) {
                        // This optional block of code can be used to run
                        // code when the user saves the form.
                      },
                      validator: (String value) {
                      },
                    ),

                    RaisedButton(
                      onPressed: _data,
                      textColor: Colors.white,
                      padding: const EdgeInsets.all(0.0),
                      child: Container(
                        width: 1000.0,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: <Color>[
                              Color(0xFF0D47A1),
                              Color(0xFF1976D2),
                              Color(0xFF42A5F5),
                            ],
                          ),
                        ),
                        padding: const EdgeInsets.all(10.0),
                        child:
                        const Text('Daftar',textAlign: TextAlign.center ,style: TextStyle(fontSize: 20)),
                      ),
                    ),
                    Text(data.toString())
                  ],
                )
                ,
              )
            ],
          ),
        ),
      ),
    );
  }
}
