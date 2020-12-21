import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../animation/FadeAnimation.dart';
import '../main.dart';


void main() => runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DaftarBK(),
    )
);

class DaftarBK extends StatefulWidget {
  @override
  _DaftarBKState createState() => _DaftarBKState();
}

class _DaftarBKState extends State<DaftarBK> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController email = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  String token;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  Future<void> _daftar() async{
    await Firebase.initializeApp();



    CollectionReference collectionReference = FirebaseFirestore.instance.collection('user');
    FirebaseFirestore.instance
        .collection('user')
        .doc(username.text)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (!documentSnapshot.exists) {
        print('Document does not exist on the database');
        collectionReference.doc(username.text).set({
          'email': email.text,
          'fullname':"none",
          'username': username.text, // John Doe
          'password': password.text, // Stokes and Sons
          'role': "nonadmin",
          'screen':"none",
          'tokenandroid':token
        })
            .then((value) => print("User Added"))
            .catchError((error) => print("Failed to add user: $error"));
        Navigator.push(context, new MaterialPageRoute(
            builder: (context) => LoginBK()
        ));

      }else{
        print('Document udah ada');
        Fluttertoast.showToast(
            msg: "username already exists",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0
        );
    }});
  }

  void validate(){
    if(formkey.currentState.validate()){
      print("validasi");
      _daftar();
    }else{
      print("not validated");
    }
  }

  String validasiusername(value){
    if(value.isEmpty){
      return "Required";
    }else{
      if(value.length<6) {
        return "At least 6 characters";
      }
      if(value.length>10) {
        return "Up to 10 characters";
      }
    }
  }

  String validasipass(value){
    if(value.isEmpty){
      return "Required";
    }else{
      if(value.length<6) {
        return "At least 6 characters";
      }
    }
  }

  String validasiemail(value){
    if(value.isEmpty){
      return "Required";
    }else{
      if(!EmailValidator.validate(value)) {
        return "Email format is wrong";
      }
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firebaseMessaging.getToken().then((val) {
      print('Token: '+val);
      token = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                colors: [
                  Colors.blue[900],
                  Colors.blue[800],
                  Colors.blue[400]
                ]
            )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 80,),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FadeAnimation(1, Text("Register", style: TextStyle(color: Colors.white, fontSize: 40),)),
                  SizedBox(height: 10,),
                  FadeAnimation(1.3, Text("Welcome to BK-SMA app", style: TextStyle(color: Colors.white, fontSize: 18),)),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(60), topRight: Radius.circular(60))
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 60,),
                        FadeAnimation(1.4, Container(
                          padding: EdgeInsets.only(bottom: 10.0),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [BoxShadow(
                                  color: Colors.blue[100],
                                  blurRadius: 20,
                                  offset: Offset(0, 10)
                              )]
                          ),
                          child: Form(
                            key: formkey,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(10),

                                  child: TextFormField(
                                    controller: email,
                                    inputFormatters: [BlacklistingTextInputFormatter(new RegExp('[ -]'))],
                                    decoration: const InputDecoration(
                                      icon: Icon(Icons.mail_outline),
                                      hintText: 'Your e-mail',
                                      labelText: 'Email',
                                    ),
                                    onSaved: (String value) {
                                      // This optional block of code can be used to run
                                      // code when the user saves the form.
                                    },
                                    validator: validasiemail,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(10),

                                  child: TextFormField(
                                    controller: username,
                                    keyboardType: TextInputType.name,
                                    inputFormatters: [BlacklistingTextInputFormatter(new RegExp('[ -]'))],
                                    decoration: const InputDecoration(
                                      icon: Icon(Icons.person_outline),
                                      hintText: 'Your Username',
                                      labelText: 'Username',
                                    ),
                                    onSaved: (String value) {
                                      // This optional block of code can be used to run
                                      // code when the user saves the form.
                                    },
                                    validator: validasiusername,
                                  ),
                                ),
                                Container(

                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      border: Border(bottom: BorderSide(color: Colors.grey[200]))
                                  ),
                                  child:  TextFormField(
                                    controller: password,
                                    keyboardType: TextInputType.visiblePassword,
                                    inputFormatters: [BlacklistingTextInputFormatter(new RegExp('[ -]'))],
                                    decoration: const InputDecoration(
                                      icon: Icon(Icons.lock_outline),
                                      hintText: 'Your Password',
                                      labelText: 'Password',
                                    ),
                                    autofocus: false,
                                    obscureText: true,
                                    onSaved: (String value) {
                                      // This optional block of code can be used to run
                                      // code when the user saves the form.
                                    },
                                    validator: validasipass,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
                        SizedBox(height: 40,),
                        SizedBox(height: 40,),
                        GestureDetector(
                          onTap:validate,
                          child: FadeAnimation(1.6, Container(
                            height: 50,
                            margin: EdgeInsets.symmetric(horizontal: 50),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.blue[800]
                            ),
                            child: Center(
                              child: Text("Register", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                            ),
                          )),
                        ),
                        SizedBox(height: 50,),
                        FadeAnimation(1.7, Text("© Copyright 2020 BIMA", style: TextStyle(color: Colors.grey),)),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}


