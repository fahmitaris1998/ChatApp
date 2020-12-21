import 'package:cloud_firestore/cloud_firestore.dart';
import 'file:///D:/project%20flutter/crud_firebase/lib/user/daftarBK.dart';
import 'file:///D:/project%20flutter/crud_firebase/lib/ScreenAdmin/dashboardadmin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'animation/FadeAnimation.dart';
import 'user/dashboard.dart';
import 'user/login.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var usernamesp = preferences.getString('username');
  var role = preferences.getString('role');
  runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: usernamesp == null ? LoginBK() : role == "admin" ? DashboardAdmin(): Dashboard(),
      )
  );
}

class LoginBK extends StatefulWidget {
  @override
  _LoginBKState createState() => _LoginBKState();
}

class _LoginBKState extends State<LoginBK> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  var error = "";


  Future<void> _login() async{
    await Firebase.initializeApp();

    CollectionReference collectionReference = FirebaseFirestore.instance.collection('user');
    collectionReference
        .doc(username.text)
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
      if(documentSnapshot.exists){
        print('ada boskuu');
        Map data = documentSnapshot.data();
        String pass = data['password'];

        if (pass != password.text){
          print("Password salah");
          setState(() {
            error = "Password not match";
          });
        }else{
          print("password benar");
          setState(() {
            error="";
          });
          SharedPreferences preferences = await SharedPreferences.getInstance();
          preferences.setString('username', username.text.toString());
          preferences.setString('role', data['role']);
          print(data['role']);

          _firebaseMessaging.getToken().then((val) {
            print('Token: '+val);

            collectionReference
            .doc(username.text)
            .update({"tokenandroid": val});
          });

          if(data['role']=="nonadmin"){

            setState(() {
              Navigator.pushReplacement(context, new MaterialPageRoute(
                  builder: (context) => Dashboard()
              ));
            });

          }else{
            setState(() {
              Navigator.pushReplacement(context, new MaterialPageRoute(
                  builder: (context) => DashboardAdmin()
              ));
            });

          }

        }

      }else{
        setState(() {
          error="User not found";
        });
        print("nda ada bosku");
      }
    });
  }

  void validate(){
    if(formkey.currentState.validate()){
      print("validasi");
      _login();
      if (error!=""){
        Fluttertoast.showToast(
            msg: error.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }


    }else{
      print("not validated");
    }
  }

  String validasiusername(value){
    if(value.isEmpty){
      return "Required";
    }else{
      return null;
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
    );
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
                  FadeAnimation(1, Text("Login", style: TextStyle(color: Colors.white, fontSize: 40),)),
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
                                    controller: username,
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
                        GestureDetector(
                            onTap: (){
                            },
                            child: FadeAnimation(1.5, Text("Forgot Password?", style: TextStyle(color: Colors.grey),))),
                        SizedBox(height: 10.0,),
                        GestureDetector(
                            onTap: (){
                              Navigator.push(context, new MaterialPageRoute(
                                  builder: (context) => DaftarBK()
                              ));
                            },
                            child: FadeAnimation(1.5, Text("Create New Account?", style: TextStyle(color: Colors.grey),))),
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
                              child: Text("Login", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
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


