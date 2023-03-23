import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jeevana/view/components/constantValues.dart';
import 'package:jeevana/view/components/main_button.dart';
import 'package:http/http.dart'as http;
import 'package:jeevana/view/screens/changepassword.dart';
import 'package:jeevana/view/screens/loginscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _bankInfo = TextEditingController();

  bool editStatus = false;
  String? _userType;
  @override
  void initState() {
    GetProfile();
    super.initState();
  }

  Future<Set<Future<bool>>> StoreData(String userType,userID,token,sub)async{
    print({"SetString:",userType,userID});
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.reload();
    return await {
      sharedPreferences.setString('accountStat',userType),
      sharedPreferences.setString('userId',userID),
      sharedPreferences.setString('token',token),
      sharedPreferences.setString('subscription',sub),
    };
  }

  Future<void> EditProfile()async{
    SharedPreferences sharedPreferences =await SharedPreferences.getInstance();
    String? sub_status = sharedPreferences.getString('accountStat');
    String? userID = sharedPreferences.getString('userId');
    String? token = sharedPreferences.getString('token');
    var map = new Map<String,dynamic>();
    if(sub_status == 'user') {
      map['user_id'] = userID.toString();
    }else {
      map['driver_id'] = userID.toString();
    }
      map['name'] = _username.text.toString();
      map['phone'] = _phone.text.toString();
      map['address'] = _address.text.toString();
      print(map);
      final response = await http.post(
      Uri.parse(
          sub_status == 'user' ?
          "https://jeevana.projectsvn.com/api/update-userprofile":
          "https://jeevana.projectsvn.com/api/update-driverprofile"
      ),
      headers: {
        'Authorization':'Bearer '+token.toString()
      },
      body: map,
    );
    var jsondata=jsonDecode(response.body);
    print({"Edit Profile :",jsondata});
    if(jsondata['status'] == 200 || jsondata['status'] == 'true'){
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Success'),
          content: const Text('Profile edited successfully'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> GetProfile()async{
    SharedPreferences sharedPreferences =await SharedPreferences.getInstance();
    String? sub_status = sharedPreferences.getString('accountStat');
    String? userID = sharedPreferences.getString('userId');
    String? token = sharedPreferences.getString('token');
    var map = new Map<String,dynamic>();
    if(sub_status == 'user'){
      map['user_id'] = userID.toString();
    } else{
      map['driver_id'] = userID.toString();
    }
    print(map);
    final response = await http.post(
      Uri.parse(
        sub_status == 'user' ?
        "https://jeevana.projectsvn.com/api/user-get-profile":
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
    var jsondata=jsonDecode(response.body);
    print({"Gett Profile :",jsondata['profile']['name'].toString()});

    setState(() {
      _username.text = jsondata['profile']['name'].toString();
      _email.text = jsondata['profile']['email'].toString();
      _phone.text = jsondata['profile']['phone'].toString();
      _address.text = jsondata['profile']['address'].toString();
      // AccountStat = sub_status.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.redAccent,
          title: Text("PROFILE"),
          titleTextStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
        ),
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 100,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    image:
                        DecorationImage(image: AssetImage('assets/user.png')),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                DetailingText(
                  primaryText: "Username : ",
                  Controller: _username
                ),
                DetailingText(
                  primaryText: "Phone : ",
                  Controller: _phone,
                ),
                DetailingText(
                  primaryText: "Email : ",
                  Controller: _email,
                ),
                DetailingText(
                  primaryText: "Address : ",
                  Controller: _address,
                ),
                MainButton(
                    title: "Edit Profile",
                    onPressed: () {
                      EditProfile();
                    },
                    color: Colors.redAccent,
                    borderColor: Colors.redAccent.shade100,
                    textColor: Colors.white),
                MySizedBox(),
                MainButton(title: "Password", onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> ChangePassword()));
                }, color: Colors.white, borderColor: Colors.black26, textColor: Colors.redAccent),
                // MySizedBox(),
                // MainButton(title: "Feedback", onPressed: (){
                //   showDialog<String>(
                //     context: context,
                //     builder: (BuildContext context) =>
                //        Container(
                //        child: Padding(
                //          padding: EdgeInsets.only(top: 150,bottom: 150,left: 30,right: 30),
                //          child: Container(
                //            height: 100,
                //            width: 200,
                //            decoration: BoxDecoration(
                //              borderRadius: BorderRadius.all(
                //                Radius.circular(8),
                //              ),
                //              color:Colors.white,
                //            ),
                //          ),
                //        ),
                //   ),
                //   );
                // }, color: Colors.white, borderColor: Colors.black26, textColor: Colors.redAccent),
                MySizedBox(),
                MainButton(title: "Logout", onPressed: () async {
                  await StoreData('', '', '', '');
                  Navigator.of(context)..pop();
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (context) => LoginScreen()));
                }, color: Colors.white, borderColor: Colors.black26, textColor: Colors.redAccent)
              ],
            ),
          ),
        ));
  }
}

class DetailingText extends StatelessWidget {
  String primaryText;
  final Controller;
  DetailingText(
      {Key? key,
      required this.primaryText,
      required this.Controller,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            primaryText,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          Container(
            height: 50,
            width: MediaQuery.of(context).size.width / 2,
            child: TextField(
              controller: Controller,
            ),
          )
        ],
      ),
    );
  }
}
