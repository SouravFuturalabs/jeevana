import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:jeevana/view/screens/live_tracking.dart';
import 'package:jeevana/view/screens/schedule_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/constantValues.dart';
import 'lliveTrackingForUser.dart';

class ShowUserBooking extends StatefulWidget {
  const ShowUserBooking({Key? key}) : super(key: key);

  @override
  State<ShowUserBooking> createState() => _ShowUserBookingState();
}

class _ShowUserBookingState extends State<ShowUserBooking> {
  Future ShowBooking() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userID = sharedPreferences.getString('userId');
    String? token = sharedPreferences.getString('token');
    var map = new Map<String, dynamic>();
    map['user_id'] = userID.toString();
    print(map);
    final response = await http.post(
      Uri.parse(
        "https://jeevana.projectsvn.com/api/UserBookingHistory",
      ),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + token.toString()
      },
      body: map,
    );
    var jsondata = jsonDecode(response.body);
    print(" booking details ${jsondata}");
    return jsondata;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text("BOOKINGS"),
        centerTitle: true,
        titleTextStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
      ),
      body: Column(
        children: [
          MySizedBox(),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(20),
              // height: MediaQuery.of(context).size.height - 90,
              width: MediaQuery.of(context).size.width,
              child: FutureBuilder(
                future: ShowBooking(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Colors.redAccent,
                      ),
                    );
                  } else {
                    return ListView.builder(
                        itemCount: snapshot.data["data"].length,
                        itemBuilder: (BuildContext context, int index) {
                          return MyTile(
                            rideStues: snapshot.data["data"][index]
                                    ['ride_status']
                                .toString(),
                            pickUpAddress: snapshot.data["data"][index]
                                    ['pickup_location']
                                .toString(),
                            destination: snapshot.data["data"][index]
                                    ['destination']
                                .toString(),
                            status: snapshot.data["data"][index]
                                    ['booking_status']
                                .toString(),
                            onTap: () {

                              ////---------------------------------------------------- function
                              print(snapshot.data["data"][index]['ride_status']
                                  .toString());
                              print(snapshot.data["data"][index]
                                      ['booking_status']
                                  .toString());

                              if (snapshot.data["data"][index]['ride_status']
                                      .toString() ==
                                  "0") {
                                if (snapshot.data["data"][index]
                                                ['booking_status']
                                            .toString() ==
                                        "1" ||
                                    snapshot.data["data"][index]
                                                ['booking_status']
                                            .toString() ==
                                        "2") {
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => LiveTranckingForUser( booking_id: snapshot
                                                    .data["data"][index]['id']
                                                    .toString(),
                                                driver_id: snapshot.data["data"]
                                                        [index]['driver_id']
                                                    .toString(), pending: snapshot.data["data"][index]
                                                ['booking_status']
                                            .toString(),),)).then((value){
                                              setState(() {
                                                
                                              });
                                            });

                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) => LiveTracking(
                                  //               booking_id: snapshot
                                  //                   .data["data"][index]['id']
                                  //                   .toString(),
                                  //               driver_id: snapshot.data["data"]
                                  //                       [index]['driver_id']
                                  //                   .toString(),
                                  //             )));
                                }else{
                                          ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              "Already completed or The drive rejected the request")));
                                }
                              }
                              else{
                                          ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              "Already completed or The drive rejected the request")));
                                }

                              // if (snapshot.data["data"][index]['booking_status']
                              //             .toString() ==
                              //         "1" &&
                              //     snapshot.data["data"][index]['booking_status']
                              //             .toString() ==
                              //         "2") {
                              //   Navigator.push(
                              //       context,
                              //       MaterialPageRoute(
                              //           builder: (context) => LiveTracking(
                              //                 booking_id: snapshot.data["data"]
                              //                         [index]['id']
                              //                     .toString(),
                              //                 driver_id: snapshot.data["data"]
                              //                         [index]['driver_id']
                              //                     .toString(),
                              //               )));
                              // }

                              // if (snapshot.data["data"][index]['ride_status']
                              //             .toString() !=
                              //         "0" &&
                              //     snapshot.data["data"][index]['booking_status']
                              //             .toString() ==
                              //         "3") {
                              //   Navigator.push(
                              //       context,
                              //       MaterialPageRoute(
                              //           builder: (context) => LiveTracking(
                              //                 booking_id: snapshot.data["data"]
                              //                         [index]['id']
                              //                     .toString(),
                              //                 driver_id: snapshot.data["data"]
                              //                         [index]['driver_id']
                              //                     .toString(),
                              //               )));
                              // }

                              // if (snapshot.data["data"][index]['booking_status']
                              //         .toString() ==
                              //     "3") {

                              //     print(
                              //         "  >>>>>>>  ${snapshot.data["data"][index]["users"]['drive_status'].toString()}");
                              //     Navigator.push(
                              //         context,
                              //         MaterialPageRoute(
                              //             builder: (context) => LiveTracking(
                              //                   booking_id: snapshot
                              //                       .data["data"][index]['id']
                              //                       .toString(),
                              //                   driver_id: snapshot.data["data"]
                              //                           [index]['driver_id']
                              //                       .toString(),
                              //                 )));
                              //   } else {
                              //     ScaffoldMessenger.of(context).showSnackBar(
                              //         SnackBar(
                              //             content: Text(
                              //                 "The drive rejected the request")));
                              //   }
                            },
                            time: snapshot.data["data"][index]['booking_later']
                                .toString(), driver: snapshot.data["data"][index]['driver_id']
                              .toString(),
                          );
                        });
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MyTile extends StatefulWidget {
  String? pickUpAddress;
  String? time;
  String? destination;
  String? status;
  String? rideStues;
  String? driver;
  final GestureTapCallback onTap;
  MyTile(
      {Key? key,
      required this.pickUpAddress,
        required this.driver,
      required this.destination,
      required this.time,
      required this.status,
      required this.rideStues,
      required this.onTap})
      : super(key: key);

  @override
  State<MyTile> createState() => _MyTileState();
}

class _MyTileState extends State<MyTile> {



  String? driverName ="Not avilable";
  String? driverPhone ="Not avilable";
  String? vehicle_name ="Not avilable";

  Future<void> GetProfile()async{
    SharedPreferences sharedPreferences =await SharedPreferences.getInstance();
    String? sub_status = sharedPreferences.getString('accountStat');
    String? userID = sharedPreferences.getString('userId');
    String? token = sharedPreferences.getString('token');
    var map = new Map<String,dynamic>();
    // if(sub_status == 'user'){
    //   map['user_id'] = userID.toString();
    // } else{
    //
    // }
    map['driver_id'] = widget.driver.toString();
    print(map);
    final response = await http.post(
      Uri.parse(

        "https://jeevana.projectsvn.com/api/driver-get-profile"
        ,
      ),
      headers: {
        'Accept':'application/json',
        'Authorization':'Bearer '+token.toString()
      },
      body: map,
    );
    print({"profile map : ",map});
    print(response.body);



    var detials =  jsonDecode(response.body);
    print(detials["profile"]["name"].toString());
    setState(() {
      driverName= detials["profile"]["name"].toString();
      driverPhone= detials["profile"]["phone"].toString();
      vehicle_name= detials["profile"]["vehicle_name"].toString();
    });

    // print({"Gett Profile :",jsondata['profile']['name'].toString()});


  }

  @override
  void initState() {
    // TODO: implement initState
    GetProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 20),
        // height: 120,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.all(Radius.circular(16)),
            border: Border.all(width: 1, color: Colors.redAccent)),
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
                        children: [
                          Text(
                            "Driver :   ",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 16),
                          ),
                          Text(
                            driverName!,
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 16),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text(
                            "phone :   ",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 16),
                          ),
                          Text(
                            driverPhone!,
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 16),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text(
                            "Vehicle name :   ",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 16),
                          ),
                          Text(
                            vehicle_name!,
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 16),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text(
                            "Address :   ",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 16),
                          ),
                          Text(
                            widget.pickUpAddress!,
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 16),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text(
                            "Destination :   ",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 16),
                          ),
                          Text(
                            widget.destination!,
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 16),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text(
                            "Time :   ",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 16),
                          ),
                          Text(
                            widget.time == 'null' ? 'NOW' : widget.time!,
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 16),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text(
                            "Status :  ",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 16),
                          ),
                          widget.rideStues == "0"
                              ? Text(
                                  widget.status == "1"
                                      ? "Pending"
                                      : widget.status == "2"
                                          ? "Driver Accepted"
                                          : "Driver Rejected"!,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16),
                                )
                              : Text(
                                  "Drive Completed",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16),
                                ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
