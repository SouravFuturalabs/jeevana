import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart'as http;
import 'package:jeevana/view/screens/chat.dart';
import 'package:jeevana/view/screens/ride_complete_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class LiveTracking extends StatefulWidget {
  String booking_id;
  String? driver_id;
  LiveTracking({Key? key, required this.booking_id, this.driver_id}) : super(key: key);
  @override
  _LiveTrackingState createState() => _LiveTrackingState();
}

class _LiveTrackingState extends State<LiveTracking> {
  String? _userType;
  String? serType;
  String? driverStatus;
  int _countDown = 3;
  @override
  Future<String?> GetStoredData()async{
    SharedPreferences sharedPreferences =await SharedPreferences.getInstance();
    String? sub_status = sharedPreferences.getString('accountStat');
    String? userID = sharedPreferences.getString('userId');
    print({"Store Data : ",sub_status,userID,widget.driver_id});
    setState(() {
      _userType = sub_status.toString();
    });
  }
  Future<void> LiveTrackingAPIDriver(status)async{
    SharedPreferences sharedPreferences =await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString('token');
    String? userID = sharedPreferences.getString('userId');
    var map = new Map<String,dynamic>();
    map['driver_id'] = userID.toString();
    map['booking_id'] = widget.booking_id.toString();
    map['tracking_status'] = status.toString();
    print(map);
    final response = await http.post(
      Uri.parse(
        "https://jeevana.projectsvn.com/api/live-tracking",
      ),
      headers: {
        'Accept':'application/json',
        'Authorization':'Bearer '+token.toString()
      },
      body: map,
    );
    print({"Tracking status map : ",map});
    var jsondata=jsonDecode(response.body);
    if(status == 3){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>RideComplete(ddriver_id: widget.driver_id.toString(),)));
    }
    print({"Tracking status :",jsondata});
  }
  Future<void> LiveTrackingAPICustomer()async{
    SharedPreferences sharedPreferences =await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString('token');
    var map = new Map<String,dynamic>();
    map['booking_id'] = widget.booking_id.toString();
    print(map);
    final response = await http.post(
      Uri.parse(
        "https://jeevana.projectsvn.com/api/driver-tracking",
      ),
      headers: {
        'Accept':'application/json',
        'Authorization':'Bearer '+token.toString()
      },
      body: map,
    );
    print({"Tracking status map : ",map});
    var jsondata=jsonDecode(response.body);
    print({"Tracking status :",jsondata});
    if(jsondata['status'] == 'driver is not accepted'){
      print("not accepted!!");
      return null;
    }
    if(jsondata['status'] == 'on the way'){
      print("on the way!!");
      _currentStep < 3 ?
      setState(() => _currentStep = 1): null;
    } else if(jsondata['status'] == 'driver on pickup'){
      print("pickup!!");
      _currentStep < 3 ?
      setState(() => _currentStep = 2): null;
    }else {
      print("destination!!");
      _currentStep < 3 ?
      setState(() => _currentStep = 3): null;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>RideComplete(ddriver_id: widget.driver_id.toString(),)));
    }
  }

  StartCountDown(){
     return Timer.periodic(Duration(seconds: 1), (timer) {
        if (_countDown == 0) {
          setState(() => _currentStep = 1);
          return timer.cancel();
        } else {
          setState(() {
            _countDown--;
          });
        }
      });
  }

  void initState() {
      GetStoredData().then((value) => StartCountDown());
      super.initState();
  }
  int _currentStep = 0;
  StepperType stepperType = StepperType.vertical;


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text('LIVE TRACKING'),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
      ),
      body:  Container(
        child: Column(
          children: [
            Expanded(
              child: Stepper(
                type: stepperType,
                physics: ScrollPhysics(),
                currentStep: _currentStep,
                onStepTapped: (step) {
                      tapped(step);
                },
                onStepContinue: _userType != 'user' ? continued : null,
                // onStepCancel: _userType != 'user' ? cancel : null,
                steps: <Step>[
                  Step(
                    title: new Text('Start the Ambulance!'),
                    content:Container(
                      child: Text(_countDown.toString(),style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700)),
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
                _userType == 'user'?
                ElevatedButton(onPressed: (){
                  LiveTrackingAPICustomer();
                },
                    child: Text("Reload"),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        padding: EdgeInsets.only(left: 50,right: 50)
                    )
                ) : SizedBox(),
                // ElevatedButton(onPressed: (){
                //   Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatScreen()));
                // },
                //     child: Text("Chat"),
                //     style: ElevatedButton.styleFrom(
                //         backgroundColor: Colors.redAccent,
                //         padding: EdgeInsets.only(left: 50,right: 50)
                //     )
                // ),
              ],
            ),

          ],
        ),
      ),

    );
  }
  switchStepsType() {
    setState(() => stepperType == StepperType.vertical
        ? stepperType = StepperType.horizontal
        : stepperType = StepperType.vertical);
  }

  tapped(int step){
    setState(() => _currentStep = step);
  }

  continued(){
    print(_currentStep);
    _currentStep < 3 ?
    setState(() => _currentStep += 1): null;
    if(_currentStep == 0){
      LiveTrackingAPIDriver(0);
    }else if(_currentStep == 1){
      LiveTrackingAPIDriver(1);
    }else if(_currentStep == 2){
      LiveTrackingAPIDriver(2);
    } else if(_currentStep == 3) {
      LiveTrackingAPIDriver(3);
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>RideComplete(ddriver_id: widget.driver_id.toString(),)));
    }
    print({"C step : ",_currentStep});
  }
  onTheWay(){
    _currentStep < 3 ?
    setState(() => _currentStep += 1): null;
    LiveTrackingAPIDriver(1);
  }
  PickupLoc(){
    _currentStep < 3 ?
    setState(() => _currentStep += 1): null;
    LiveTrackingAPIDriver(2);
  }
  Destination(){
    _currentStep < 3 ?
    setState(() => _currentStep += 1): null;
    LiveTrackingAPIDriver(3);
  }
  cancel(){
    _currentStep > 0 ?
    setState(() => _currentStep -= 1) : null;
    print({"C step : ",_currentStep});
  }
}