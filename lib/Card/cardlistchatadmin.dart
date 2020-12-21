import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class CardListChatAdmin extends StatelessWidget {
  final String status;
  final String nama;
  final String tanggal;
  final String newmessage;
  final String doc_id;

  const CardListChatAdmin({
    Key key,
    @required this.status,
    @required this.nama,
    @required this.tanggal,
    this.newmessage,
    this.doc_id,
  }) : super(key: key);

  Future<void> acceptstatus(doc_id) async{
    await Firebase.initializeApp();
    CollectionReference collectionReference = FirebaseFirestore.instance.collection("jadwalkonseling");
    collectionReference
    .doc(doc_id)
    .update({"status":"open"});
  }
  Future<void> rejectstatus(doc_id) async{
    await Firebase.initializeApp();
    CollectionReference collectionReference = FirebaseFirestore.instance.collection("jadwalkonseling");
    collectionReference
        .doc(doc_id)
        .update({"status":"reject"});
  }
  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 20.0),
        decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(10)
        ),
        padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
        child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 25.0,
                    backgroundColor: Colors.white,
                    child: Text("M",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0),),
                  ),
                  SizedBox(width: 10.0,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(nama,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 18.0,color: Colors.white,fontWeight: FontWeight.bold),),
                        SizedBox(height: 5.0,),
                        Text("Patient",style: TextStyle(color: Colors.white),),
                        SizedBox(height: 5.0,),
                        Text(tanggal,style: TextStyle(color: Colors.white),),
                      ],
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15.0,vertical: 5.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0)
                    ),
                    child: Text( status == "open" ? 'Open' : "Waiting",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold),),
                  )
                ],
              ),
              SizedBox(height: 10.0,),
              status=="open" ? Container(
                padding: EdgeInsets.only(top: 10.0),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(width: 1.0, color: Colors.grey[400]),
                  ),
                ),
                child:
                Row(

                  children: [
                    int.parse(newmessage) > 0 ?
                    SizedBox(width: 35.0,)
                        : SizedBox(),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Start Counseling",style: TextStyle(color: Colors.white),),
                          Icon(Icons.keyboard_arrow_right,color: Colors.white,),],
                      ),
                    ),
                    int.parse(newmessage) > 0 ?
                    Container(
                      padding: EdgeInsets.symmetric(vertical:5.0,horizontal: 9.0),
                      decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(20.0)
                      ),
                      child: Text(int.parse(newmessage)>99? "99+":newmessage,style: TextStyle(fontSize: 14.0,color: Colors.white),),
                    ): Container()
                  ],
                ),
              ) : Container(
                padding: EdgeInsets.only(top: 10.0),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(width: 1.0, color: Colors.grey[400]),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: (){
                        rejectstatus(doc_id);
                      },
                      child: Row(
                        children: [
                          Icon(Icons.highlight_off,color: Colors.white,),
                          SizedBox(width: 5,),
                          Text("Reject",style: TextStyle(color: Colors.white),)

                        ],
                      ),
                    ),
                    SizedBox(height: 25.0,width: 1.0,child: const DecoratedBox(
                      decoration: const BoxDecoration(
                          color: Colors.white
                      ),
                    ),),
                    GestureDetector(
                      onTap: (){
                        acceptstatus(doc_id);
                      },
                      child: Row(
                        children: [
                          Icon(Icons.check_circle_outline,color: Colors.white,),
                          SizedBox(width: 5,),
                          Text("Accept",style: TextStyle(color: Colors.white),)

                        ],
                      ),
                    )
                  ],
                ),
              ),

            ]
        )
    );
  }
}
