import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:http/http.dart' as http;
import 'package:jeevana/view/screens/ride_complete_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LiveTranckingForUser extends StatefulWidget {
  LiveTranckingForUser(
      {super.key, required this.booking_id, required this.driver_id,required this.pending});

  String booking_id;
  String? driver_id;
  String? pending;
  @override
  State<LiveTranckingForUser> createState() => _LiveTranckingForUserState();
}

class _LiveTranckingForUserState extends State<LiveTranckingForUser> {
  int _currentStep = 0;
  bool reached = false;
  Future<void> LiveTrackingAPICustomer() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString('token');
    var map = new Map<String, dynamic>();
    map['booking_id'] = widget.booking_id.toString();
    print(map);
    final response = await http.post(
      Uri.parse(
        "https://jeevana.projectsvn.com/api/driver-tracking",
      ),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + token.toString()
      },
      body: map,
    );
    print({"Tracking status map : ", map});
    var jsondata = jsonDecode(response.body);
    print({"Tracking status :", jsondata});
    if (jsondata['status'] == 'driver is not accepted') {
      print("not accepted!!");
      return null;
    }
    if (jsondata['status'] == 'on the way') {
      print("on the way!!");
      _currentStep < 3 ? setState(() => _currentStep = 1) : null;
    } else if (jsondata['status'] == 'driver on pickup') {
      print("pickup!!");
      _currentStep < 3 ? setState(() => _currentStep = 2) : null;
    } else {
      print("destination!!");
      _currentStep < 3 ? setState(() {
        _currentStep = 3;
        reached = true;
      } ) : null;
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>RideComplete(ddriver_id: widget.driver_id.toString(),)));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    LiveTrackingAPICustomer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LIVE TRACKING'),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
      ),
      body: widget.pending != "1" ?Column(children: [
       Expanded(
              child: Stepper(
                type: StepperType.vertical,
                physics: ScrollPhysics(),
                currentStep: _currentStep,
                onStepTapped: (step) {
                     // tapped(step);
                },
                onStepContinue:  null,
                onStepCancel:  null,
                steps: <Step>[
                  Step(
                    title: new Text('Start the Ambulance!'),
                    content:Container(
                      child: Text("",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700)),
                    ),
                    isActive: _currentStep >= 0,
                    state: _currentStep >= 0 ?
                    StepState.complete : StepState.disabled,
                  ),
                  Step(
                    title: new Text('On the way'),
                    content:Container(
                      child: Text("Driver is on the way.",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700),),
                    ),
                    isActive: _currentStep >= 0,
                    state: _currentStep >= 1 ?
                    StepState.complete : StepState.disabled,
                  ),
                  Step(
                    title: new Text('Pickup Location'),
                    content:Container(
                      child: Text("Driver has reached the Pick Up location.",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700)),
                    ),
                    isActive:_currentStep >= 0,
                    state: _currentStep >= 2 ?
                    StepState.complete : StepState.disabled,
                  ),
                  Step(
                    title: new Text('Destination'),
                    content:Container(
                      child: Text("Driver has reached the destination.",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700)),
                    ),
                    isActive:_currentStep >= 0,
                    state: _currentStep >= 3 ?
                    StepState.complete : StepState.disabled,
                  ),
                ],
              ),
            ),
             Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                
                ElevatedButton(onPressed: (){
                  reached == false ?LiveTrackingAPICustomer():ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Already Reached")));
                },
                    child: Text("Reload"),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        padding: EdgeInsets.only(left: 50,right: 50)
                    ))])
                
      ]):Center(child: Text("The request was pending",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700)),),
    );
  }
}
