import 'package:flutter/material.dart';

import '../components/constantValues.dart';
import '../components/main_button.dart';
import '../components/textField.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final TextEditingController _userId = TextEditingController();
  final TextEditingController _upiId = TextEditingController();
  final TextEditingController _amount = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.redAccent,
          title: Text("Information"),
          centerTitle: true,
          titleTextStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
        ),
        body: Container(
          margin: EdgeInsets.only(top: 50),
          alignment: Alignment.center,
          child: Column(
            children: [
              Text(
                "Enter Your Details to Continue",
                style: SampleTextStyle(),
              ),
              TextFieldLogin(
                  OnTap: (){},
                  hinttext: "Enter your username",
                  obscured: false,
                  icon: Icon(Icons.account_circle_outlined),
                  Controller: _userId,
                  OnChange: (uname){
                  }),
              MySizedBox(),
              TextFieldLogin(
                  OnTap: (){},
                  hinttext: "Enter your UPI ID",
                  obscured: false,
                  icon: Icon(Icons.phone),
                  Controller: _upiId,
                  OnChange: (phone){
                    print(_userId.text);
                  }),
              MySizedBox(),
              TextFieldLogin(
                  OnTap: (){},
                  hinttext: "Enter Amount",
                  obscured: false,
                  icon: Icon(Icons.place_outlined),
                  Controller: _amount,
                  OnChange: (address){
                    print(_userId.text);
                  }),
              MySizedBox(),
              MySizedBox(),
              MainButton(title: "Pay Now", onPressed: (){}, color: Colors.redAccent, borderColor: Colors.grey, textColor: Colors.white)
            ],
          ),
        ));
  }
}
