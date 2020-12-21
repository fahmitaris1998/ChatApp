import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailKotakMasuk extends StatelessWidget {

  final String read;
  final String nama;
  final String subject;
  final String message;
  final String tgl;

  const DetailKotakMasuk({
    Key key,
    this.nama,
    this.subject,
    this.tgl,
    this.read,
    this.message
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(

          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.grey[800]),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Colors.white,
          title: Text("Detail Mailbox", style: TextStyle(color: Colors.grey[900]),),
          elevation: 1,
        ),
        body: Container(
          height: double.infinity,
            color: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 10.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 25.0,
                        child: Text(nama.substring(0,1).toUpperCase(),style: TextStyle(
                          fontSize: 25.0
                        ),
                        ),
                      ),
                      SizedBox(width: 10.0,),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(nama,style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold),),
                            SizedBox(height: 5.0,),
                            Text(tgl)
                          ],
                        ),
                      ),
                      Icon(Icons.more_vert_rounded),

                    ],
                  ),
                  SizedBox(height: 30.0,),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15.0,vertical: 5.0),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10.0)
                      ),
                      child: Text("Topic",
                        style: TextStyle(
                            fontSize: 17.0,
                            color: Colors.white),
                      )
                  ),
                  SizedBox(height: 10.0,),
                  Container(
                    margin: EdgeInsets.only(left: 10.0,right: 10.0),
                    child: Text(subject,
                      style: TextStyle(
                          fontSize: 17.0,
                          color: Colors.black,fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 30.0,),
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 15.0,vertical: 5.0),
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10.0)
                      ),
                      child: Text("Message",
                        style: TextStyle(
                            fontSize: 17.0,
                            color: Colors.white),
                      )
                  ),
                  SizedBox(height: 10.0,),
                  Container(
                    margin: EdgeInsets.only(left: 10.0,right: 10.0),
                    child: Text(message, textAlign: TextAlign.justify,
                      style: TextStyle(
                          fontSize: 17.0,
                          color: Colors.black),
                    ),
                  )
                ],
              ),
            ),
          ),

      ),
    );
  }
}
