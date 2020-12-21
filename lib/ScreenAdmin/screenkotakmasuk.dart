import 'package:cloud_firestore/cloud_firestore.dart';
import 'file:///D:/project%20flutter/crud_firebase/lib/Card/cardkotakmasuk.dart';
import 'file:///D:/project%20flutter/crud_firebase/lib/ScreenAdmin/detailkotakmasuk.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../main.dart';
import '../Card/mymessage.dart';
import '../Card/othermessage.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  return runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ScreenKotakMasuk(),
  ));
}
class ScreenKotakMasuk extends StatefulWidget {
  @override
  _ScreenKotakMasukState createState() => _ScreenKotakMasukState();
}

class _ScreenKotakMasukState extends State<ScreenKotakMasuk> {

  Future logout(BuildContext context) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    CollectionReference collectionReference = FirebaseFirestore.instance.collection('user');
//    var username = preferences.getString('username');
    collectionReference
        .doc(preferences.getString('username'))
        .update({'tokenandroid':"none"});
    preferences.remove('username');
    preferences.remove('role');
    Navigator.pushReplacement(context, new MaterialPageRoute(
        builder: (context) => LoginBK()
    ));

  }
  CollectionReference collectionReference = FirebaseFirestore.instance.collection('kotakmasuk');
  final Query query = FirebaseFirestore.instance.collection('kotakmasuk').orderBy('taggalsort',descending: true);

  List data;
  Future<void> updateUser(doc_id) {
    return collectionReference
        .doc(doc_id)
        .update({'read': 'read'})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }
  @override

  void initState() {
    // TODO: implement initState
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);
    print(formattedDate);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(

        appBar:  AppBar(
          backgroundColor: Colors.blue,
          title: Text("Mailbox", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
          elevation: 1,
          actions: [
            Container(
              margin: EdgeInsets.only(right: 15.0),
              child:
              GestureDetector(
                onTap: (){
                  showDialog(
                    context: context,
                    child: new AlertDialog(
                      content: GestureDetector(
                        onTap: (){
                          logout(context);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          decoration: BoxDecoration(

                          ),
                          child: Row(
                            children: [
                              Icon(Icons.logout),
                              SizedBox(width: 10.0,),
                              Text("Logout"),

                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 17.0,
                  child: Text("M",style: TextStyle(color: Colors.blue),),
                ),
              ),
            )

          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: query.snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }
            return new ListView(
                children: snapshot.data.documents.map((DocumentSnapshot document) {
              return new GestureDetector(
                        onTap: (){
                         updateUser(document.documentID.toString());
                         setState(() {
                           Navigator.push(context, new MaterialPageRoute(
                               builder: (context) => DetailKotakMasuk(nama: document.data()['From'], subject: document.data()['subject'] ,message:document.data()['message'], tgl: document.data()['tanggaldetail'],)
                           ));
                         });

                        },
                        child: CardKotakMasuk(nama: document.data()['From'], subject: document.data()['subject'],tgl: document.data()['tanggal'], read: document.data()['read'],message: document.data()['message'])
              );
                }).toList(),
            );
//
          },
        )

    );
  }
}


