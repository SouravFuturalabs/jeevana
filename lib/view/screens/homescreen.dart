import 'dart:convert';
import 'package:jeevana/view/screens/driver_list.dart';
import 'package:jeevana/view/screens/driver_wallet.dart';
import 'package:jeevana/view/screens/schedule_screen.dart';
import 'package:jeevana/view/screens/show_bookings_user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jeevana/view/screens/live_tracking.dart';
import 'package:jeevana/view/screens/profile_screen.dart';
import 'package:lottie/lottie.dart';

import '../components/constantValues.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    GetStoredData().then((value) => ReadJSON());

    super.initState();
  }

  String? _userType;

  Future<String?> GetStoredData()async{
    SharedPreferences sharedPreferences =await SharedPreferences.getInstance();
    String? sub_status = sharedPreferences.getString('accountStat');
    String? userID = sharedPreferences.getString('userId');
    print({"Store Data : ",sub_status,userID});
    setState(() {
      _userType = sub_status.toString();
    });
    print(_userType);
    print(_userType.runtimeType);
    return sub_status;
  }

  Future<void> ReadJSON()async{
    final String response = await rootBundle.loadString('assets/homeJson.json');
    final data = await json.decode(response);
    print(data);
    return data;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text("JEEVANA"),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: (){
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => ProfileScreen()));
            },
            child: Container(height: 20,
              width: MediaQuery.of(context).size.width/6,
              child: Center(
                child: Icon(Icons.account_circle_outlined),
              ),
            ),
          )
        ],
        // titleSpacing: MediaQuery.of(context).size.width/4,
        leading: Container(),
        titleTextStyle: TextStyle(fontSize: 22,fontWeight: FontWeight.w800),
      ),
      body:
      Column(
        children: [
          MySizedBox(),
                  Container(
                      height: 200,
                      width:  MediaQuery.of(context).size.width,
                      child: Lottie.asset('assets/ambulance.json',repeat: true)),
                 MySizedBox(),
          _userType == 'user' ?
          Text("Customer Account" ,style:SampleTextStyle()) :
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("Driver Account",style:SampleTextStyle()),
              // InkWell(
              //   onTap: (){
              //     GetStoredData();
              //   },
              //   child: Column(
              //     children: [
              //       Container(
              //         alignment: Alignment.center,
              //         height: 40,
              //         width: 40,
              //         child: Icon(Icons.account_balance_wallet_outlined),
              //       ),
              //       Text("Wallet",style:TextStyle(fontSize: 12,color: Colors.black),)
              //     ],
              //   ),
              // )
            ],
          ),
          MySizedBox(),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(20),
              // height: MediaQuery.of(context).size.height - 350,
              // width: MediaQuery.of(context).size.width,
              child: 
              _userType == 'user'?
              FutureBuilder(
                future: ReadJSON(),
                builder: (BuildContext context,AsyncSnapshot snapshot){
                  print({"Snapshot : ",snapshot.data});
                  if(!snapshot.hasData){
                   return Center(child: CircularProgressIndicator(color: Colors.redAccent),);
                  }else {
                    return ListView.builder(
                        itemCount: snapshot.data["items"].length,
                        itemBuilder: (BuildContext context, int index) {
                          return MyTile2(title: snapshot
                              .data["items"][index]["name"], onTap: () {
                            if (snapshot.data["items"][index]["id"] == "1") {
                              Navigator.push(
                                  context, MaterialPageRoute(builder: (context) =>
                                  DriverList(Type: '1',)));
                            }
                            if (snapshot.data["items"][index]["id"] == "2") {
                              Navigator.push(
                                  context, MaterialPageRoute(builder: (context) =>
                                  DriverList(Type: '2',)));
                            }
                            if (snapshot.data["items"][index]["id"] == "3") {
                              Navigator.push(
                                  context, MaterialPageRoute(builder: (context) =>
                                  ShowUserBooking()));
                            }
                          });
                        });
                    // return SizedBox();
                  }
                },
              ):
              Column(
                children: [
                  MyTile2(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> DriverSchedule()));
                    },
                    title: "Check My Schedule",
                  ),
                  MyTile2(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> MyEarnings()));
                    },
                    title: "My Earnings",
                  ),
                ],
              ),
            ),
          ),
        ],
      )
    );
  }
}

class MyTile2 extends StatelessWidget {
  final GestureTapCallback onTap;
  String? title;
   MyTile2({Key? key,required this.onTap,required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 20),
        alignment: Alignment.center,
        height: 120,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(title!,style: TextStyle(fontSize: 22,color: Colors.white,fontWeight: FontWeight.w700),),
            Icon(Icons.arrow_forward_ios,color: Colors.white,)
          ],
        ),
      ),
    );
  }
}
