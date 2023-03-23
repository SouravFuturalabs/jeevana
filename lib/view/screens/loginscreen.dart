import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
import 'package:jeevana/view/components/main_button.dart';
import 'package:jeevana/view/screens/homescreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jeevana/view/screens/signupscreen.dart';
import '../components/base_url.dart';
import '../components/textField.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
enum SignUpOption { Driver, Customer }
class _LoginScreenState extends State<LoginScreen> {
  SignUpOption? _character = SignUpOption.Customer;
  LoginVal(){
    if(_username.text == '' || _password.text == '') {
      bool error = false;
      return error;
    }
  }

  Future LoginAPI() async{
    var map = Map<String,dynamic>();
    map['email'] = _username.text.toString();
    map['password'] = _password.text.toString();
    print({"Params : ",map});
    final response = await http.post(
        Uri.parse(
          _character == SignUpOption.Customer?
          baseUrl+'/api/login-user':
          baseUrl+'/api/login-driver',
        ),
        body: map,
        headers: {
          'Accept':"application/json"
        }
    );
    var jsonData = jsonDecode(response.body);
    print({"Login response : ", jsonData});
    if(LoginVal() == false){
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Invalid Data'),
          content: const Text("Username or Password Can't be empty" ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
    else if(jsonData['status'] == 'false'){
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Invalid Data'),
          content: const Text("Please check the data you have entered."),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      String userType = jsonData['data']['module'].toString();
      String userID = jsonData['data']['id'].toString();
      String token = jsonData['token'].toString();
      String email = jsonData['email'].toString();
      String phone = jsonData['phone'].toString();
      String address = jsonData['address'].toString();
      StoreData(userType, userID, token,email,phone,address);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> HomeScreen()));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login Success")),
      );
    }
  }

  Future<Set<Future<bool>>> StoreData(String userType,userID,token,email,phone,address)async{
    print({"SetString:",userType,userID,token,email});
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await {
      sharedPreferences.setString('accountStat',userType),
      sharedPreferences.setString('userId',userID),
      sharedPreferences.setString('token',token),
      sharedPreferences.setString('email',email),
      sharedPreferences.setString('phone',phone),
      sharedPreferences.setString('address',address),
    };
  }

  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
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
                  height:300,
                  width: 300,
                  decoration: BoxDecoration(
                      image:DecorationImage(image:
                      AssetImage("assets/loginImage.jpg"),
                          fit: BoxFit.cover
                      )
                  ),
                ),
              ),
              Text("Login",style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700
              ),),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width/2,
                    height: 50,
                    child: ListTile(
                      title: const Text('Driver'),
                      leading: Radio<SignUpOption>(
                        activeColor: Colors.redAccent,
                        value: SignUpOption.Driver,
                        groupValue: _character,
                        onChanged: (SignUpOption? value) {
                          print(_character);
                          setState(() {
                            _character = value;
                          });
                        },
                      ),
                    ),
                  ),
                  Container(
                    width:  MediaQuery.of(context).size.width/2,
                    height: 50,
                    child: ListTile(
                      title:  Text('Customer'),
                      leading: Radio<SignUpOption>(
                        activeColor: Colors.redAccent,
                        value: SignUpOption.Customer,
                        groupValue: _character,
                        onChanged: (SignUpOption? value) {
                          setState(() {
                            _character = value;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              TextFieldLogin(
                OnTap: (){},
                OnChange: (username){
                  print(_username.text);
                  print(username);
                },
                Controller: _username,
                hinttext: 'Username',obscured:false,icon: Icon(Icons.account_circle_outlined,),),
              TextFieldLogin(
                OnTap: (){},
                OnChange: (password){
                  print(_password.text);
                  print(password);
                },
                Controller: _password,
                hinttext: 'Password',obscured: true,icon: Icon(Icons.lock,),),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Do not have an account?",style: TextStyle(fontSize: 16),),
                  InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUpScreen()));
                      },
                      child: Text(" Click here to continue.",style: TextStyle(fontSize: 16,color: Colors.redAccent),)),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MainButton(title: "LOGIN",textColor:Colors.white,color: Colors.redAccent,borderColor:Colors.redAccent, onPressed: () async{
                   await LoginAPI();
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





