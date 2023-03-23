import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jeevana/view/components/constantValues.dart';
import 'package:http/http.dart'as http;
import 'package:shared_preferences/shared_preferences.dart';

class MyEarnings extends StatefulWidget {
  const MyEarnings({Key? key}) : super(key: key);

  @override
  State<MyEarnings> createState() => _MyEarningsState();
}

class _MyEarningsState extends State<MyEarnings> {
  var earnings;

  Future GetBookings()async{
    SharedPreferences sharedPreferences =await SharedPreferences.getInstance();
    String? userID = sharedPreferences.getString('userId');
    String? token = sharedPreferences.getString('token');
    var map = new Map<String,dynamic>();
    map['driver_id'] = userID.toString();
    print(map);
    final response = await http.post(
      Uri.parse(
        "https://jeevana.projectsvn.com/api/driver-earnings",
      ),
      headers: {
        'Accept':'application/json',
        'Authorization':'Bearer '+token.toString()
      },
      body: map,
    );
    print({"Get Earnings map : ",map});
    var jsondata=jsonDecode(response.body);
    print({"Get Earnings :",jsondata['data']});
    setState(() {
      earnings = jsondata['data'].toString();
      print("earing >>>>$earnings");
    });
  }
  @override
  void initState() {
    GetBookings();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text("MY EARNINGS"),
        centerTitle: true,
        titleTextStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height/2,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                SizedBox(
                  height: 100,
                ),
                Text("My Earings",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700,),),
                MySizedBox(),
              earnings != null ?  Text("₹ ${earnings}" ,style: TextStyle(fontSize: 29,fontWeight: FontWeight.w700,),):Text("₹ 0.0" ,style: TextStyle(fontSize: 29,fontWeight: FontWeight.w700,),),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Divider(
                    thickness: 0.8,
                    color: Colors.black26,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Text("Trips",style: TextStyle(fontSize: 18),),
                        MySizedBox(),
                        Text("90"),
                      ],
                    ),
                    Column(
                      children: [
                        Text("Time",style: TextStyle(fontSize: 18),),
                        MySizedBox(),
                        Text("Time"),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Divider(
                    thickness: 0.8,
                    color: Colors.black26,
                  ),
                ),

              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height/2.5,
            width: MediaQuery.of(context).size.width,
          ),
        ],
      ),
    );
  }
}
