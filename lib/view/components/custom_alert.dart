import 'package:flutter/material.dart';
import 'package:jeevana/view/components/main_button.dart';

class CustomAlert extends StatelessWidget {
  const CustomAlert({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final colors =[Colors.redAccent.shade400, Colors.redAccent.shade100,Colors.white];
    final stops = [0.0, 0.2];
    return
      Container(
        height: 220,
        width: width,
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: 20.0,

                ),
                Row(

                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[

                    Text(
                      "Choose One",
                      style: TextStyle(fontSize: 20.0,fontWeight:FontWeight.w700),
                    ),

                  ],
                ),
                SizedBox(
                  height: 10.0,

                ), Container(
                  height: 3,

                  decoration: BoxDecoration(

                    gradient: LinearGradient(
                      colors: colors,
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),

                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MainButton(title: 'Mail', onPressed: (){}, color: Colors.redAccent,borderColor: Colors.redAccent,textColor: Colors.white,),
                      SizedBox(height: 20,),
                      MainButton(title: 'Phone', onPressed: (){}, color: Colors.redAccent,borderColor: Colors.redAccent,textColor: Colors.white,),

                    ],
                  ),

                ),
              ],
            ),
          ),
        ),
      );
  }
}
