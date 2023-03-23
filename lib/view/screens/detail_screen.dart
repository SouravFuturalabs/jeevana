import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:jeevana/view/components/main_button.dart';
import 'package:jeevana/view/components/textField.dart';
import 'package:jeevana/view/screens/live_tracking.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../components/constantValues.dart';

class Detailscreen extends StatefulWidget {
  String driver_id;
  String type;
  Detailscreen({Key? key, required this.driver_id, required this.type})
      : super(key: key);

  @override
  State<Detailscreen> createState() => _DetailscreenState();
}

class _DetailscreenState extends State<Detailscreen> {
  @override
  final TextEditingController _username = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _userId = TextEditingController();
  final TextEditingController _upiId = TextEditingController();
  final TextEditingController _amount = TextEditingController();
  final TextEditingController _destination = TextEditingController();
  final TextEditingController _date = TextEditingController();
  Future<void> BookNow() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userID = sharedPreferences.getString('userId');
    String? token = sharedPreferences.getString('token');
    var map = new Map<String, dynamic>();
    map['user_id'] = userID.toString();
    map['driver_id'] = widget.driver_id.toString();
    map['pickup_location'] = _address.text.toString();
    map['destination'] = _destination.text.toString();
    map['upi_id'] = _upiId.text.toString();
    map['Amount_paid'] = _amount.text.toString();
    if (widget.type == '2') {
      map['date_time'] = _date.text.toString();
    }
    print(map);
    final response = await http.post(
      Uri.parse(
        widget.type != '2'
            ? "https://jeevana.projectsvn.com/api/ambulance-booking"
            : "https://jeevana.projectsvn.com/api/book-later",
      ),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + token.toString()
      },
      body: map,
    );
    var jsondata = jsonDecode(response.body);
    print({"Book now :", jsondata});
    if (jsondata['message'] == 'ambulance booking successfully' ||
        jsondata['message'] == 'book later successfully') {
      showDialog<String>(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Success'),
          content: const Text(
              'Your Booking is Successful, please wait for driver to accept.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context, 'OK');
                Navigator.of(context)
                  ..pop()
                  ..pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      showDialog<String>(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Check the data you have entered.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context, 'OK');
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  var pickupLocationLatitude;
  var pickupLocationLongitude;
  bool isPickupLonctionGot = false;

  getpickupLocation() async {
    List<Location> locations = await locationFromAddress(_address.text);
    print(' locationn puckup  >>>>${locations[0].latitude}');

    if (locations != null) {
      setState(() {
        isPickupLonctionGot = true;
        pickupLocationLatitude = locations[0].latitude;
        pickupLocationLongitude = locations[0].longitude;
      });
    } else {
      isPickupLonctionGot = false;
    }
  }

  var destintionLocationLatitude;
  var destintionLocationLongitude;
  bool destinationLocationGot = false;

  getDestintionLocation() async {
    List<Location> locations = await locationFromAddress(_destination.text);
    print(' locationn destintion  >>>>${locations[0].latitude}');
    setState(() {
      destintionLocationLatitude = locations[0].latitude;
      destintionLocationLongitude = locations[0].longitude;
    });

    if (locations != null) {
      getDistances();
      setState(() {
        destinationLocationGot = true;
      });
    } else {}
  }

  getDistances() async {
    var distance = await Geolocator.distanceBetween(
        pickupLocationLatitude,
        pickupLocationLongitude,
        destintionLocationLatitude,
        destintionLocationLongitude);

    print("distance ==== ${distance / 1000}");

    setState(() {
      var km = distance / 1000;
      var totalPrice = km * 399;
      _amount.text = totalPrice.toStringAsFixed(1);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _amount.text = "0.0";
  }

  @override
  Widget build(BuildContext context) {
    // _amount.text = '399';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text("PAYMENT"),
        centerTitle: true,
        titleTextStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 50),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "Enter Your Details to Continue",
                style: SampleTextStyle(),
              ),
              TextFieldLogin(
                  enabled: true,
                  OnTap: () {},
                  hinttext: "Enter Pick Up Address",
                  obscured: false,
                  icon: Icon(Icons.place_outlined),
                  Controller: _address,
                  OnChange: (address) {
                    getpickupLocation();

                    print(_username.text);
                  }),
              MySizedBox(),
              TextFieldLogin(
                  enabled: true,
                  OnTap: () {},
                  hinttext: "Enter Destination",
                  obscured: false,
                  icon: Icon(Icons.place_outlined),
                  Controller: _destination,
                  OnChange: (address) {
                    getDestintionLocation();
                    print(_destination.text);
                  }),
              MySizedBox(),
              TextFieldLogin(
                  enabled: true,
                  OnTap: () {},
                  hinttext: "Enter your UPI ID",
                  obscured: false,
                  icon: Icon(Icons.phone),
                  Controller: _upiId,
                  OnChange: (phone) {
                    print(_userId.text);
                  }),
              MySizedBox(),
              TextFieldLogin(
                  enabled: false,
                  OnTap: () {},
                  hinttext: "Enter Amount",
                  obscured: false,
                  icon: Icon(Icons.currency_rupee),
                  Controller: _amount,
                  OnChange: (address) {
                    print(_userId.text);
                  }),
              MySizedBox(),
              widget.type == '2'
                  ? TextFieldLogin(
                      enabled: true,
                      OnTap: () async {
                        var day;
                        var month;
                        var year;
                        var min;
                        var hour;
                        DateTime? dateTimeList = await showOmniDateTimePicker(
                          context: context,
                          primaryColor: Colors.cyan,
                          backgroundColor: Colors.grey[900],
                          calendarTextColor: Colors.white,
                          tabTextColor: Colors.white,
                          unselectedTabBackgroundColor: Colors.grey[700],
                          buttonTextColor: Colors.white,
                          timeSpinnerTextStyle: const TextStyle(
                              color: Colors.white70, fontSize: 18),
                          timeSpinnerHighlightedTextStyle: const TextStyle(
                              color: Colors.white, fontSize: 24),
                          is24HourMode: true,
                          isShowSeconds: false,
                          startInitialDate: DateTime.now(),
                          startFirstDate: DateTime(1600)
                              .subtract(const Duration(days: 3652)),
                          startLastDate: DateTime.now().add(
                            const Duration(days: 3652),
                          ),
                          borderRadius: const Radius.circular(16),
                        );
                        day = dateTimeList?.day.toString();
                        month = dateTimeList?.month.toString();
                        year = dateTimeList?.year.toString();
                        min = dateTimeList?.minute.toString();
                        hour = dateTimeList?.hour.toString();
                        setState(() {
                          print({"To Pass : ", dateTimeList});
                          _date.text = year +
                              "-" +
                              month +
                              "-" +
                              day +
                              " " +
                              hour +
                              ":" +
                              min +
                              ":" +
                              "00";
                        });
                      },
                      hinttext: "Choose the Time",
                      obscured: false,
                      icon: Icon(Icons.access_time_rounded),
                      Controller: _date,
                      OnChange: (time) {})
                  : MySizedBox(),
              MainButton(
                  title: "Pay Now",
                  onPressed: () {
                    if (isPickupLonctionGot == false) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Please check the pickup address")));
                    }
                    if (destinationLocationGot == false) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content:
                              Text("Please check the destination address")));
                    }
                    if(_upiId.text.isEmpty){
                       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content:
                              Text("Please enter your UPI ID")));
                    }
                    if (isPickupLonctionGot == true &&
                        destinationLocationGot == true &&_upiId.text.isNotEmpty ) {
                      BookNow();
                    }

                    // Navigator.push(context, MaterialPageRoute(builder: (context)=> PaymentScreen()));
                  },
                  color: Colors.redAccent,
                  borderColor: Colors.grey,
                  textColor: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
