import 'dart:convert';
import 'package:http/http.dart'as http;
import 'package:jeevana/view/screens/detail_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class DriverList extends StatelessWidget {
  String Type;

   DriverList({Key? key,required this.Type}) : super(key: key);

  Future<void> GetDrivers()async{
    SharedPreferences sharedPreferences =await SharedPreferences.getInstance();
    String? sub_status = sharedPreferences.getString('accountStat');
    String? userID = sharedPreferences.getString('userId');
    String? token = sharedPreferences.getString('token');
    var map = new Map<String,dynamic>();
      map['driver_id'] = userID.toString();
    print(map);
    final response = await http.post(
      Uri.parse(
        "https://jeevana.projectsvn.com/api/driver-list",
      ),
      headers: {
        'Accept':'application/json',
        'Authorization':'Bearer '+token.toString()
      },
      body: map,
    );
    print({"Driver List Map : ",map});
    var jsondata=jsonDecode(response.body);
    print({"Driver List :",jsondata});
    return jsondata;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
      backgroundColor: Colors.redAccent,
      title: Text("DRIVERS"),
      titleTextStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
    ),
      body: FutureBuilder(
        future: GetDrivers(),
        builder: (BuildContext context,AsyncSnapshot snapshot){
          if(!snapshot.hasData){
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
              itemCount: snapshot.data['driver_list'].length,
              itemBuilder: (BuildContext context,int index){
                print({"SNAP : ",snapshot.data[['driver_list']]});
                // return SizedBox();
                return MyTile(
                  vehicle_name: snapshot.data['driver_list'][index]['vehicle_name'].toString(),
                  phone:snapshot.data['driver_list'][index]['phone'].toString() ,
                  name: snapshot.data['driver_list'][index]['name'].toString(),
                  gender: snapshot.data['driver_list'][index]['gender'].toString(),
                  licence: snapshot.data['driver_list'][index]['licence_no'].toString(),
                  imgPath: snapshot.data['driver_list'][index]['ambulance_type'].toString() == '1' ?
                  'assets/ambulance.png':'assets/normalAmb.png',
                  icu: snapshot.data['driver_list'][index]['ambulance_type'].toString() == '1' ?
                  'YES':'NO',
                  onTap: (){

                    if(snapshot.data['driver_list'][index]['driver_status'].toString() == "3"){
                      if(Type == '1') {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) =>
                          Detailscreen(
                            driver_id: snapshot.data['driver_list'][index]['id'].toString(),
                            type: Type,
                          )));
                    } else {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) =>
                          Detailscreen(
                               driver_id: snapshot.data['driver_list'][index]['id'].toString(),
                              type: Type)));
                    }
                    }else{
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Driver busy")));
                    }
                    
                  },
                );
              });
          // return SizedBox();
        },
      ),
    );
  }
}

class MyTile extends StatelessWidget {
  String ? name;
  String ? gender;
  String? vehicle_name;
  String? phone;
  String ? licence;
  String ? imgPath;
  String ? icu;
  final GestureTapCallback onTap;
   MyTile({Key? key,required this.phone,required this.vehicle_name,required this.name,required this.gender,required this.licence,required this.imgPath,required this.icu,required this.onTap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(20),
       // height: 170,
        width: MediaQuery.of(context).size.width,

        decoration: BoxDecoration(
          color: Colors.grey.shade200,

          borderRadius: BorderRadius.all(Radius.circular(16)),
          border: Border.all(width: 1,color: Colors.redAccent)
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Text("Name :   ",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16),),
                      Text(name!,style: TextStyle(fontWeight: FontWeight.w400,fontSize: 16),),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Text("Phone :   ",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16),),
                      Text(phone!,style: TextStyle(fontWeight: FontWeight.w400,fontSize: 16),),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Text("Vehicle name :   ",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16),),
                      Text(vehicle_name!,style: TextStyle(fontWeight: FontWeight.w400,fontSize: 16),),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Text("Gender :   ",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16),),
                      Text(gender!,style: TextStyle(fontWeight: FontWeight.w400,fontSize: 16),),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Text("Licence No. :   ",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16),),
                      Text(licence!,style: TextStyle(fontWeight: FontWeight.w400,fontSize: 16),),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Text("ICU :   ",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16),),
                      Text(icu!,style: TextStyle(fontWeight: FontWeight.w400,fontSize: 16),),
                    ],
                  ),
                ],
              ),
              Container(
                height: 80,
              width: 100,
              decoration: BoxDecoration(
              image: DecorationImage(scale: 2.5, image: AssetImage(imgPath!)),
              ))
            ],
          ),
        ),
      ),
    );
  }
}

