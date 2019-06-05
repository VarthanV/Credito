
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'HomePage.dart';
import 'login.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

Future<void> check() async{
  var prefs= await SharedPreferences.getInstance();
var cookie=prefs.getString('cookie');
if(cookie != null){
  setState(() {
    
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => HomePage(false)));
  });
}
else{
  setState(() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
  });

}
}
@override
void initState(){
  super.initState();
   Timer(Duration(seconds: 3), check);
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Colors.pinkAccent)
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                    
                      Padding(
                        padding: EdgeInsets.only(top: 100.0),
                      ),
                      Text(
                        " Credito",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 30.0,
                            fontFamily: 'OpenSans'),
                      ),
                      
                     
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(
                      backgroundColor: Colors.pinkAccent,
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                    ),
                     
                    
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}