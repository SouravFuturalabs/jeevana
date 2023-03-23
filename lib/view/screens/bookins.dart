import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../components/constantValues.dart';

class Bookings extends StatefulWidget {
  const Bookings({Key? key}) : super(key: key);

  @override
  State<Bookings> createState() => _BookingsState();
}

class _BookingsState extends State<Bookings> {
  Future<void> ReadJSON()async{
    final String response = await rootBundle.loadString('assets/homeJson.json');
    final data = await json.decode(response);
    print(data);
    return data;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text("Book for Later"),
        centerTitle: true,
        titleTextStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
      ),
      body: Column(
        children: [

          MySizedBox(),
          Container(
            padding: EdgeInsets.all(20),
            height: MediaQuery.of(context).size.height - 200,
            width: MediaQuery.of(context).size.width,
            child: FutureBuilder(
              future: ReadJSON(),
              builder: (BuildContext context,AsyncSnapshot snapshot){
                print({"Snapshot : ",snapshot.data});
                return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemCount: snapshot.data["items"].length,
                    itemBuilder: (BuildContext context,int index){
                      return MyTile(
                        indexNo: snapshot.data["items"][index]["id"].toString(),
                          title: snapshot.data["items"][index]["name"],
                          onPressed: (){

                      });
                    });

              },
            ),
          ),
        ],
      ),
    );
  }
}

class MyTile extends StatelessWidget {
  String title;
  String indexNo;
  final GestureTapCallback ? onPressed;
  MyTile({Key? key,required this.title,required this.onPressed,required this.indexNo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      height: 500,
      width: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.redAccent,
      ),
      child: RawMaterialButton(
        splashColor: Colors.white,
        onPressed: onPressed,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Booking id : $indexNo",style: SampleTextStyle2(),),
            MySizedBox(),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}