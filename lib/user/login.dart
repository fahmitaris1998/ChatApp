import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_firebase/maincrud.dart';
import 'package:crud_firebase/palette.dart';
import 'package:crud_firebase/screentwo.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/scheduler.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: Login() ,
  ),
  );
}
class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  Future<void> _data() async{
    CollectionReference collectionReference = FirebaseFirestore.instance.collection('user');
    collectionReference
        .doc(username.text)
        .get()
        .then((DocumentSnapshot documentSnapshot){
          if(documentSnapshot.exists){
            print('ada boskuu');
          }else{
            print("nda ada bosku");
          }
    });
  }
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Login", style: TextStyle(fontSize: 30.0),),
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
