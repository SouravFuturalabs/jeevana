import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jeevana/view/screens/loginscreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    _navigateTohome();
    super.initState();
  }
  _navigateTohome()async{

    await Future.delayed(Duration(milliseconds: 4000),(){
    });
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()),);
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 183,29,28,),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                  child: const Text("Jeevana",
                  style: TextStyle(
                    fontSize:50,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.italic
                  ),
                  ),
                ),
            SizedBox(
              height: 30,
            ),
            Container(
              height: 100,
              width: MediaQuery.of(context).size.width/2,
              decoration: BoxDecoration(
                  image:DecorationImage(image:
                  AssetImage("assets/ecg.png"),
                      fit: BoxFit.cover
                  )
              ),
            ),
          ],
        ),
      ),

    );
  }
}