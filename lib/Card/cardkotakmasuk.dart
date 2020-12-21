import 'package:flutter/material.dart';

class CardKotakMasuk extends StatelessWidget {
  final String read;
  final String nama;
  final String subject;
  final String message;
  final String tgl;

  const CardKotakMasuk({
    Key key,
    this.nama,
    this.subject,
    this.tgl,
    this.read,
    this.message
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15.0,horizontal: 10.0),
      decoration: BoxDecoration(
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20.0,
            child: Text(nama.substring(0,1).toUpperCase()),
          ),
          SizedBox(width: 15.0,),
          Expanded(
            child: read == "read" ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(nama,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.black87, fontSize: 16.0),),
                    Expanded(child: SizedBox(width: 5.0,)),
                    Text(tgl,style: TextStyle(fontSize: 13.0,color: Colors.grey[500]),)
                  ],
                ),

                Text(subject,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.black87, fontSize: 15.0),),
                SizedBox(height: 1.0,),
                Text(message,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.black87, fontSize: 15.0),),
              ],
            ) :Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(nama,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.black, fontSize: 16.0,fontWeight: FontWeight.bold),),
                    Expanded(child: SizedBox(width: 5.0,)),
                    Text(tgl,style: TextStyle(fontSize: 13.0,color: Colors.black,fontWeight: FontWeight.bold),)
                  ],
                ),
                Text(subject,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.black, fontSize: 15.0,fontWeight: FontWeight.bold),),
                SizedBox(height: 1.0,),
                Text(message,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey[600], fontSize: 15.0),),
              ],
            ),
          ),

        ],
      ),
    );
  }
}
