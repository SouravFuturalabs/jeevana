import 'package:flutter/material.dart';
import 'package:jeevana/view/components/constantValues.dart';
import 'package:lottie/lottie.dart';
import '../components/main_button.dart';
import 'dart:convert';
import 'package:http/http.dart'as http;
import 'package:shared_preferences/shared_preferences.dart';
class RideComplete extends StatefulWidget {
  String ddriver_id;
   RideComplete({Key? key,required this.ddriver_id}) : super(key: key);

  @override
  State<RideComplete> createState() => _RideCompleteState();
}

class _RideCompleteState extends State<RideComplete> {
  final TextEditingController _textFieldController = TextEditingController();
  Future<void> FeedbackAPI()async{
    SharedPreferences sharedPreferences =await SharedPreferences.getInstance();
    String? sub_status = sharedPreferences.getString('accountStat');
    String? userID = sharedPreferences.getString('userId');
    String? token = sharedPreferences.getString('token');
    var map = new Map<String,dynamic>();
    map['user_id'] = userID.toString();
    map['feedback'] = _textFieldController.text.toString();
    map['driver_id'] = widget.ddriver_id.toString();
    print(map);
    final response = await http.post(
      Uri.parse(
          "https://jeevana.projectsvn.com/api/feedback"
      ),
      headers: {
        'Authorization':'Bearer '+token.toString()
      },
      body: map,
    );
    var jsondata=jsonDecode(response.body);
    print({"Feedback :",jsondata});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Feedback Send")),
    );

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('RIDE COMPLETE'),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
      ),
      body: Column(
        children: [
          Container(
            alignment: Alignment.center,
              height: 250,
              width:  MediaQuery.of(context).size.width,
              child: Lottie.asset('assets/rideComplete.json',repeat: false)),
          Text("Ride Completed",style: SampleTextStyle(),),
          MySizedBox(),
          MySizedBox(),

          Center(
            child: MainButton(title: "Feedback", onPressed: (){
              showDialog<String>(
                context: context,
                builder: (BuildContext context) =>
                    AlertDialog(
                      // backgroundColor: Colors.grey,
                      title: Text('Feedback'),
                      content: TextField(
                        onChanged: (value) { },
                        controller: _textFieldController,
                        decoration: InputDecoration(hintText: "Enter your feedback here"),
                      ),
                      actions: [
                        TextButton(
                            onPressed: (){
                              Navigator.pop(context);
                            },
                            child: Text("Cancel",style: TextStyle(
                                fontSize: 16
                            ),)
                        ),
                        TextButton(
                            onPressed: (){
                              Navigator.pop(context);
                              FeedbackAPI();
                            },
                            child: Text("Send",style: TextStyle(
                                fontSize: 16
                            ),)
                        ),
                      ],
                    ),
              );
            }, color: Colors.white, borderColor: Colors.black26, textColor: Colors.redAccent),
          )
        ],
      ),
    );
  }
}
