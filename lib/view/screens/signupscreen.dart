import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jeevana/view/components/constantValues.dart';
import 'package:jeevana/view/components/main_button.dart';
import 'package:jeevana/view/screens/loginscreen.dart';
import 'package:http/http.dart'as http;
import '../components/base_url.dart';
import '../components/textField.dart';
enum SignUpOption { Driver, Customer }
enum Gender { Male, Female, Others }
enum Type { Type1,Type2}
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String genderVal = 'male';
  String vehicleType = '1';


  Future SignUpAPI() async{
    var map = Map<String,dynamic>();
    map['email'] = _email.text.toString();
    map['name'] = _name.text.toString();
    map['gender'] = genderVal.toString();
    map['password'] = _password.text.toString();
    map['address'] = _address.text.toString();
    map['phone'] = _phone.text.toString();
    if(_character == SignUpOption.Driver){
      map['ambulance_type'] = vehicleType.toString();
      map['vehicle_name'] = _vehicleName.text.toString();
      map['vehicle_no'] = _vehicleNo.text.toString();
      map['licence_no'] = _licenceNo.text.toString();

    }
    print({"Signup Map: ",map});
    final response = await http.post(
      Uri.parse(
          _character == SignUpOption.Customer?
          baseUrl+'/api/User-register' :
          baseUrl+'/api/Driver-register' ,
      ),
      body: map,
      headers: {
        'Accept':"application/json"
      }
    );
    var jsonData = jsonDecode(response.body);
    print({"Sign up response : ", jsonData});
    if(jsonData['status'] == 'false'){
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Error'),
          content: const Text("Check the data you have entered or the user already exits" ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else if(jsonData['status'] == 'true') {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Success'),
          content: const Text("User registered successfully." ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginScreen())),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Error'),
          content: const Text("An error occured" ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  final TextEditingController _email = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _vehicleNo = TextEditingController();
  final TextEditingController _vehicleName = TextEditingController();
  final TextEditingController _licenceNo = TextEditingController();
  SignUpOption? _character = SignUpOption.Customer;
  Gender? _sex = Gender.Male;
  Type? _vType = Type.Type1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:  Colors.white,
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height/20,
                ),
                Text("Sign Up",style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700
                ),),
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
                TextFieldLogin(
                  OnTap: (){},
                  OnChange: (username){
                    print(_email.text);
                    print(username);
                  },
                  Controller: _email,
                  hinttext: 'Email',obscured:false,icon: Icon(Icons.email_outlined),),
                TextFieldLogin(
                  OnTap: (){},
                  OnChange: (name){
                    print(_name.text);
                    print(name);
                  },
                  Controller: _name,
                  hinttext: 'Name',obscured:false,icon: Icon(Icons.account_circle_outlined,),),
                TextFieldLogin(
                  OnTap: (){},
                  OnChange: (password){
                    print(_password.text);
                    print(password);
                  },
                  Controller: _password,
                  hinttext: 'Password',obscured: true,icon: Icon(Icons.lock,),),
                TextFieldLogin(
                  OnTap: (){},
                  OnChange: (address){
                    print(_address.text);
                    print(address);
                  },
                  Controller: _address,
                  hinttext: 'Address',obscured: false,icon: Icon(Icons.place_outlined,),),
                TextFieldLogin(
                  OnTap: (){},
                  OnChange: (phone){
                    print(_phone.text);
                    print(phone);
                  },
                  Controller: _phone,
                  hinttext: 'Phone no',obscured: false,icon:Icon(Icons.phone_android,),),
                _character.toString() == "SignUpOption.Driver" ?
                TextFieldLogin(
                  OnTap: (){},
                  OnChange: (phone){
                    print(_vehicleName.text);
                    print(phone);
                  },
                  Controller: _vehicleName,
                  hinttext: 'Vehicle Name',obscured: false,icon:Icon(Icons.fire_truck_outlined,),):
                Container(),
                _character.toString() == "SignUpOption.Driver" ?
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width/2,
                      height: 50,
                      child: ListTile(
                        title: const Text('ICU Type'),
                        leading: Radio<Type>(
                          activeColor: Colors.redAccent,
                          value: Type.Type1,
                          groupValue: _vType,
                          onChanged: (Type? value) {
                            vTypeValidation(value);
                            print(_vType);
                            setState(() {
                              _vType = value;
                            });
                          },
                        ),
                      ),
                    ),
                    Container(
                      width:  MediaQuery.of(context).size.width/2,
                      height: 50,
                      child: ListTile(
                        title:  Text('Normal'),
                        leading: Radio<Type>(
                          activeColor: Colors.redAccent,
                          value: Type.Type2,
                          groupValue: _vType,
                          onChanged: (Type? value) {
                            vTypeValidation(value);
                            setState(() {
                              _vType = value;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ):
                SizedBox(),
                _character.toString() == "SignUpOption.Driver" ?
                TextFieldLogin(
                  OnTap: (){},
                  OnChange: (phone){
                    print(_vehicleNo.text);
                    print(phone);
                  },
                  Controller: _vehicleNo,
                  hinttext: 'Vehicle Number',obscured: false,icon:Icon(Icons.fire_truck_outlined,),):
                Container(),
                _character.toString() == "SignUpOption.Driver" ?
                TextFieldLogin(
                  OnTap: (){},
                  OnChange: (phone){
                    print(_licenceNo.text);
                    print(phone);
                  },
                  Controller: _licenceNo,
                  hinttext: 'Licence Number',obscured: false,icon:Icon(Icons.perm_identity_sharp,),):
                Container(),

                Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width/2,
                          height: 50,
                          child: ListTile(
                            title: const Text('Male'),
                            leading: Radio<Gender>(
                              activeColor: Colors.redAccent,
                              value: Gender.Male,
                              groupValue: _sex,
                              onChanged: (Gender? value) async{
                                await GenderValidation(value);
                                print(value);
                                setState(() {
                                  _sex = value;
                                });
                              },
                            ),
                          ),
                        ),
                        Container(
                          width:  MediaQuery.of(context).size.width/2,
                          height: 50,
                          child: ListTile(
                            title:  Text('Female'),
                            leading: Radio<Gender>(
                              activeColor: Colors.redAccent,
                              value: Gender.Female,
                              groupValue: _sex,
                              onChanged: (Gender? value) {
                                GenderValidation(value);
                                print(_sex);
                                setState(() {
                                  _sex = value;
                                });
                              },
                            ),
                          ),
                        ),
                        Container(
                          width:  MediaQuery.of(context).size.width/2,
                          height: 50,
                          child: ListTile(
                            title:  Text('Others'),
                            leading: Radio<Gender>(
                              activeColor: Colors.redAccent,
                              value: Gender.Others,
                              groupValue: _sex,
                              onChanged: (Gender? value) {
                                GenderValidation(value);
                                print(_sex);
                                setState(() {
                                  _sex = value;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an Account ?",style: TextStyle(fontSize: 16),),
                    InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
                        },
                        child: Text(" Click here to continue.",style: TextStyle(fontSize: 16,color: Colors.redAccent),)),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                MainButton(title: "SIGN UP",textColor:Colors.redAccent,color: Colors.white,borderColor:Colors.grey, onPressed: () {

                  SignUpAPI();
                },),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        )

    );
  }
  GenderValidation(value){
    if(value == Gender.Male){
      setState(() {
        genderVal = 'male';
        print({"VALUE :",genderVal});
      });
    } else if(value == Gender.Female){
      setState(() {
        genderVal = 'female';
        print({"VALUE :",genderVal});
      });
    } else {
      setState(() {
        genderVal = 'others';
        print({"VALUE :",genderVal});
      });
    }
  }
  vTypeValidation(value){
    if(value == Type.Type1){
      setState(() {
        vehicleType = '1';
        print(vehicleType);
      });
    } else{
      setState(() {
        vehicleType = '2';
        print(vehicleType);
      });
    }
  }
}



