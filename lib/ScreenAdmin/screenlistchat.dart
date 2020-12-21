import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_firebase/Card/cardlistchat.dart';
import 'package:crud_firebase/Card/cardlistchatadmin.dart';
import 'package:crud_firebase/user/chat.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  return runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ScreenListChat(),
  ));
}

class ScreenListChat extends StatefulWidget {
  @override
  _ScreenListChatState createState() => _ScreenListChatState();
}

class _ScreenListChatState extends State<ScreenListChat> {
  final Query query = FirebaseFirestore.instance.collection('jadwalkonseling').orderBy('date',descending: true);
  String sendfrom;
  String role;


  Future<void> updatescreen(doc_id) async{
    await Firebase.initializeApp();
    CollectionReference collectionReference = FirebaseFirestore.instance.collection('user');
    collectionReference.doc(doc_id).update({"screen":"Dasbiard admin"});

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getusername();
  }

  _getusername() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      sendfrom = preferences.getString("username");
      role = preferences.getString("role");
    });
    updatescreen(sendfrom);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Chat Counseling",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
        elevation: 1,
      ),
      body: Container(
        padding: EdgeInsets.only(top: 20.0,right: 10,left: 10),
        height: double.infinity,
        width: double.infinity,
        color: Colors.white,
        child:StreamBuilder<QuerySnapshot>(
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
                return document.data()['status'] == "open"?
                GestureDetector(
                    onTap: (){
                      Navigator.push(context, new MaterialPageRoute(
                          builder: (context) => Chat(conselor: document.data()["From"],doc_id: document.documentID,sendfrom: sendfrom,refresh: _getusername,id_sendto: document.data()["From"],id_card_screen: document.documentID,)
                      ),);

                    },
                    child: CardListChatAdmin(status: document.data()["status"],nama: document.data()['From'] ,tanggal: document.data()['date'],newmessage: document.data()["nmkonseler"],))
                    : document.data()['status'] == "waiting"? CardListChatAdmin(status: document.data()["status"],nama: document.data()['From'] ,tanggal: document.data()['date'],doc_id: document.documentID,)
                    :Container();

              }).toList(),
            );
//
          },
        ),
      ),
    );
  }
}
