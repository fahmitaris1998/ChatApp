import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_firebase/palette.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MainLogin());
}
class MainLogin extends StatefulWidget {
  @override
  _MainLoginState createState() => _MainLoginState();
}

class _MainLoginState extends State<MainLogin> {
  Map data;
  int k = 0;

  addData(){
    Map<String,dynamic> demodata = {"name":"taris","password":"rahasiia123"};
    CollectionReference collectionReference = Firestore.instance.collection('user').doc('skuuuut').set(demodata) as CollectionReference;
//    FirebaseFirestore.instance
//        .collection('data')
//        .doc('JBYUVHVKpHKN9IPj8ogQ')
//        .get()
//        .then((DocumentSnapshot documentSnapshot) {
//      if (documentSnapshot.exists) {
//        print('Document data: ${documentSnapshot.data()}');
//      } else {
//        print('Document does not exist on the database');
//      }
//    });
//    print("addd");
  }

  fetchData(){
    CollectionReference collectionReference = Firestore.instance.collection('data');
    collectionReference.snapshots().listen((event) {
      setState(() {
        data = event.documents[0].data();
        k = event.documents.length;
        print("nilainya : ${k}");
      });
    });
  }

  deletedata() async{
    CollectionReference collectionReference = Firestore.instance.collection('data');
    QuerySnapshot querySnapshot = await collectionReference.getDocuments();
    querySnapshot.documents[0].reference.delete();
  }


  updatedata() async{
    CollectionReference collectionReference = Firestore.instance.collection('data');
    QuerySnapshot querySnapshot = await collectionReference.getDocuments();
    querySnapshot.documents[0].reference.updateData({"name": "fawass","kelas":"mana saja"});
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Facebook UI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Container(
        decoration: BoxDecoration(
          color: Colors.white
        ),
        child:  Column(
          children: [
            RaisedButton(
              onPressed: addData,
              textColor: Colors.white,
              padding: const EdgeInsets.all(0.0),
              child: Container(
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
                const Text('Add Data', style: TextStyle(fontSize: 20)),
              ),
            ),
            SizedBox(height: 15.0,),
            RaisedButton(
              onPressed: fetchData,
              textColor: Colors.white,
              padding: const EdgeInsets.all(0.0),
              child: Container(
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
                const Text('Get Data', style: TextStyle(fontSize: 20)),
              ),
            ),
            SizedBox(height: 10.0,),
            RaisedButton(
              onPressed: deletedata,
              textColor: Colors.white,
              padding: const EdgeInsets.all(0.0),
              child: Container(
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
                const Text('Delete Data', style: TextStyle(fontSize: 20)),
              ),
            ),
            SizedBox(height: 10.0,),
            RaisedButton(
              onPressed: updatedata,
              textColor: Colors.white,
              padding: const EdgeInsets.all(0.0),
              child: Container(
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
                const Text('Update Data', style: TextStyle(fontSize: 20)),
              ),
            ),
            SizedBox(height: 10.0,),
            Text(data.toString(),textAlign: TextAlign.center,style: TextStyle(fontSize: 20),),
            SizedBox(height: 10.0,),
            Text(k.toString(),textAlign: TextAlign.center,style: TextStyle(fontSize: 20),)

          ],
        ),
      ),
    );
  }
}
