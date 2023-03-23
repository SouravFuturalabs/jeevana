import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jeevana/view/screens/live_tracking.dart';
import 'package:http/http.dart'as http;
import 'package:shared_preferences/shared_preferences.dart';

class DriverSchedule extends StatefulWidget {
  const DriverSchedule({Key? key}) : super(key: key);

  @override
  State<DriverSchedule> createState() => _DriverScheduleState();
}

class _DriverScheduleState extends State<DriverSchedule> {

  Future AcceptRequest(id) async{
    SharedPreferences sharedPreferences =await SharedPreferences.getInstance();
    String? userID = sharedPreferences.getString('userId');
    String? token = sharedPreferences.getString('token');
    var map = new Map<String,dynamic>();
    map['driver_id'] = userID.toString();
    map['booking_id'] = id.toString();
    print(map);
    final response = await http.post(
      Uri.parse(
        "https://jeevana.projectsvn.com/api/driver-accept",
      ),
      headers: {
        'Accept':'application/json',
        'Authorization':'Bearer '+token.toString()
      },
      body: map,
    );
    var jsondata=jsonDecode(response.body);
    print({"Accept request :",jsondata});
    if(jsondata['status'] == 'true'){
      showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Accepted'),
          content: const Text("You have ACCEPTED the booking" ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context, 'OK');
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LiveTracking(booking_id: id.toString(),)));
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }
  Future DeclineRequest(id) async{
    SharedPreferences sharedPreferences =await SharedPreferences.getInstance();
    String? userID = sharedPreferences.getString('userId');
    String? token = sharedPreferences.getString('token');
    var map = new Map<String,dynamic>();
    map['driver_id'] = userID.toString();
    map['booking_id'] = id.toString();
    print(map);
    final response = await http.post(
      Uri.parse(
        "https://jeevana.projectsvn.com/api/driver-decline",
      ),
      headers: {
        'Accept':'application/json',
        'Authorization':'Bearer '+token.toString()
      },
      body: map,
    );
    var jsondata=jsonDecode(response.body);
    print({"Decline request :",jsondata});
    if(jsondata['status'] == 'true'){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>DriverSchedule()));
    }
  }

  Future GetBookings()async{
    SharedPreferences sharedPreferences =await SharedPreferences.getInstance();
    String? userID = sharedPreferences.getString('userId');
    String? token = sharedPreferences.getString('token');
    var map = new Map<String,dynamic>();
    map['driver_id'] = userID.toString();
    print(map);
    final response = await http.post(
      Uri.parse(
        "https://jeevana.projectsvn.com/api/driver-booking-list",
      ),
      headers: {
        'Accept':'application/json',
        'Authorization':'Bearer '+token.toString()
      },
      body: map,
    );
    print({"Get Bookings map : ",map});
    var jsondata=jsonDecode(response.body);
    print({"Get Bookings :",jsondata});
    return jsondata;
  }
@override
  void initState() {
    GetBookings();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text("SCHEDULE"),
        centerTitle: true,
        titleTextStyle: TextStyle(fontSize: 22,fontWeight: FontWeight.w800),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              // height: MediaQuery.of(context).size.height - 80,
              width: MediaQuery.of(context).size.width,
              child: FutureBuilder(
                future: GetBookings(),
                builder: (BuildContext context,AsyncSnapshot snapshot){
                  print({"SNAP : ", snapshot.data});
                  if(!snapshot.hasData){
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  else if(snapshot.data['data'].length == 0){
                    return Center(
                      child: Text("No Jobs"),
                    );
                  } else {
                    return ListView.builder(
                        itemCount: snapshot.data['data'].length,
                        itemBuilder: (BuildContext context, int index) {
                          print({"SNAP : ", snapshot.data['data']});
                          return MyTile(
                            name: snapshot.data['data'][index]['users']['name']
                                .toString(),
                            destination: snapshot
                                .data['data'][index]['destination'].toString(),
                            pickUpAddress: snapshot
                                .data['data'][index]['pickup_location']
                                .toString(),
                            onTapAccept: () {
                              AcceptRequest(snapshot.data['data'][index]['id']);
                            },
                            onTapDecline: () {
                              DeclineRequest(snapshot.data['data'][index]['id']);
                            },
                            bookingStat: snapshot.data['data'][index]['booking_status'].toString(),
                          );
                        });
                  }
                  // return SizedBox();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MyTile extends StatelessWidget {
  String ? name;
  String ? pickUpAddress;
  String ? destination;
  String ? bookingStat;
  final GestureTapCallback  onTapAccept;
  final GestureTapCallback onTapDecline;
  MyTile({Key? key,required this.name,required this.pickUpAddress,required this.destination,required this.onTapAccept,required this.onTapDecline,required this.bookingStat}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      // height: 160,
      width: MediaQuery.of(context).size.width,

      decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.all(Radius.circular(16)),
          border: Border.all(width: 1,color: Colors.redAccent)
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(

                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Name :   ",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16),),
                        Text(name!,style: TextStyle(fontWeight: FontWeight.w400,fontSize: 16),overflow: TextOverflow.ellipsis),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      children: [
                        Text("Address :   ",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16),),
                        Text(pickUpAddress!,style: TextStyle(fontWeight: FontWeight.w400,fontSize: 16),),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      children: [
                        Text("Destination :   ",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16),),
                        Text(destination!,style: TextStyle(fontWeight: FontWeight.w400,fontSize: 16),),
                      ],
                    ),
                    SizedBox(height: 10,),
                  ],
                ),
              ],
            ),
            bookingStat == '1'?
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MyTileButton(title: 'Accept',OnTap: onTapAccept),
                MyTileButton(title: 'Decline',OnTap: onTapDecline),
              ],
            ):
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyTileButton(title: 'Continue',OnTap: onTapAccept),              ],
            )
            ,
          ],
        ),
      ),
    );
  }
}

class MyTileButton extends StatelessWidget {
  final String title;
  final GestureTapCallback OnTap;
   MyTileButton({Key? key,required this.title,required this.OnTap,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: OnTap,
        child: Container(
          alignment: Alignment.center,
          height: 30,
          width: MediaQuery.of(context).size.width/2.8,
          decoration: BoxDecoration(
            color: Colors.redAccent,
            borderRadius: BorderRadius.all(Radius.circular(8))
          ),
          child: Text(title,style: TextStyle(color: Colors.white),),
        )
    );
  }
}

