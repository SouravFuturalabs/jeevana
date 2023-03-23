import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jeevana/view/components/main_button.dart';
import 'package:http/http.dart'as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../components/textField.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController _newPassword = TextEditingController();
  final TextEditingController _currentPassword = TextEditingController();
  Future ChangePasswordFn(context)async{
    SharedPreferences sharedPreferences =await SharedPreferences.getInstance();
    String? sub_status = sharedPreferences.getString('accountStat');
    String? userID = sharedPreferences.getString('userId');
    String? token = sharedPreferences.getString('token');
    var map = new Map<String,dynamic>();
    if(sub_status == 'user') {
      map['user_id'] = userID.toString();
    } else {
      map['driver_id'] = userID.toString();
    }
    map['currnt_password'] = _currentPassword.text;
    map['new_password'] = _newPassword.text;
    print(map);
    final response = await http.post(
        Uri.parse(
          sub_status == 'user'?
            "https://jeevana.projectsvn.com/api/user-changePassword":
            "https://jeevana.projectsvn.com/api/changePassword"
        ),
        body: map,
        headers: {
          'Accept':'application/json',
          "Authorization" : "Bearer "+token.toString(),
        }
    );
    var jsondata=jsonDecode(response.body);
    print({"Change Password Response :",jsondata});
    if(jsondata['message'] != 'current password changed'){
      showDialog(
          context: context,
          // barrierDismissible: false,
          builder: (context) =>
              AlertDialog(
                  content: Text("Enter atleast 6 characters"),
                  title: Text("Error"),
                  actions: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextButton(onPressed: (){
                          Navigator.pop(context);
                        }, child: Text("OK"))
                      ],
                    ),
                  ]));
    } else {
      showDialog(
          context: context,
          // barrierDismissible: false,
          builder: (context) =>
              AlertDialog(
                content: Text('Password Changed Successfully.'),
                title: Text("Success"),
                actions: [
                  TextButton(onPressed: (){
                    Navigator.pop(context);
                  }, child: Text("OK"))
                ],
              ));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
      ),
        backgroundColor:  Colors.white,
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height/10,
                ),
                Center(
                  child: Container(
                    height:200,
                    width: 200,
                    decoration: BoxDecoration(
                        image:DecorationImage(image:
                        AssetImage("assets/lock.png"),
                            fit: BoxFit.cover
                        )
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Text("Change Password",style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700
                ),),
                SizedBox(
                  height:  MediaQuery.of(context).size.height/6,
                ),
                TextFieldLogin(
                  OnTap: (){},
                  OnChange: (email){
                  },
                  Controller: _currentPassword,
                  hinttext: 'Current Password',obscured:false,icon: Icon(Icons.lock_open_outlined,),),

                SizedBox(
                  height:  10
                ),
                TextFieldLogin(
                  OnTap: (){},
                  OnChange: (email){
                  },
                  Controller: _newPassword,
                  hinttext: 'New Password',obscured:false,icon: Icon(Icons.lock_open_outlined,),),

                SizedBox(
                  height:  20
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MainButton(title: "Change",textColor:Colors.white,color: Colors.redAccent,borderColor:Colors.redAccent, onPressed: () {
                      ChangePasswordFn(context);
                    },),
                  ],
                ),
              ],
            ),
          ),
        )

    );
  }
}



