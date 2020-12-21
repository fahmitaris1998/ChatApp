import 'package:flutter/material.dart';

class CardListChat extends StatelessWidget {
  final String status;
  final String nama;
  final String tanggal;
  final String newmessage;

  const CardListChat({
    Key key,
    @required this.status,
    @required this.nama,
    @required this.tanggal,
    this.newmessage,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
          width: double.infinity,
          margin: EdgeInsets.only(bottom: 20.0),
          decoration: BoxDecoration(
            color: Colors.white,
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
                          style: TextStyle(fontSize: 18.0,color: Colors.black,fontWeight: FontWeight.bold),),
                        SizedBox(height: 5.0,),
                        Text("Counselor"),
                        SizedBox(height: 5.0,),
                        Text(tanggal),
                      ],
                  ),
                ),

                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15.0,vertical: 5.0),
                  decoration: BoxDecoration(
                    color: Colors.lightBlue,
                    borderRadius: BorderRadius.circular(20.0)
                  ),
                  child: Text( status == "open" ? 'Open' : "Waiting",style: TextStyle(color: Colors.white),),
                )
              ],
            ),
              SizedBox(height: 10.0,),
              status=="open" ? Container(
                padding: EdgeInsets.only(top: 5.0),
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
                          Text("Start Counseling"),
                          Icon(Icons.keyboard_arrow_right),],
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
              ) : Container(),

            ]
          )
    );
  }
}
