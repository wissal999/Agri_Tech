import 'dart:async';

import 'package:agri_tech/BottomNavigation.dart';
import 'package:agri_tech/Login.dart';

import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';


class SplashScreen extends StatefulWidget{

  @override
  State<StatefulWidget> createState()=>_SplashScreenState() ;

}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(const Duration(seconds: 5), () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login() ));
    //Navigator.push(context, MaterialPageRoute(builder: (context) => BottomNavigation() ));
    });
  }
    @override
  Widget build(BuildContext context) {

    return Scaffold(
  backgroundColor: Color(0xFFFFFFFF),

        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:<Widget> [
              SizedBox(height:130,),
              Container(
                width: 200,
                height: 200,


                    child:Image.asset("assets/logo.png"),

              ),
              SizedBox(height: 150,),


              Padding(padding: EdgeInsets.only(left: 20,right:20 ),
                child: LinearPercentIndicator(
                  animation: true,
                  lineHeight: 15,
                  animationDuration: 3000,
                  percent: 1,
                  linearStrokeCap: LinearStrokeCap.roundAll,
                  progressColor: Color(0xFF22780F),
                ),

              )
            ],

          ),

        ));





  }
}
