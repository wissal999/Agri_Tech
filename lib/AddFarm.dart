import 'dart:convert';
import 'package:agri_tech/ListFarms.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'Models/Farm.dart';



class AddFarm extends StatefulWidget{

  @override
  State<StatefulWidget> createState()=>_AddFarmState() ;

}

class _AddFarmState extends State<AddFarm> with SingleTickerProviderStateMixin {
 late TextEditingController txtNomFerme,txtLieuFerme;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    txtNomFerme=new TextEditingController();
    txtLieuFerme=new TextEditingController();
  }

  void addFarm() async{
    final uri=Uri.parse("http://192.168.43.130:8080/addFarm");
    var req = await http.post(uri,body: {
      "nom":txtNomFerme.text,
      "lieu":txtLieuFerme.text,
    });
    var response=json.decode(req.body) ;

      Farm farm = Farm(response["id"], response["nom"], response["lieu"]);

    if(farm !=null ){

      Fluttertoast.showToast(msg: "succesful",toastLength: Toast.LENGTH_SHORT);
      Navigator.push(context,MaterialPageRoute(builder: (context)=> ListFarms()));
    }
    else {   Fluttertoast.showToast(msg: "error",toastLength: Toast.LENGTH_SHORT);}



  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body:SingleChildScrollView(
            child: Padding( padding: EdgeInsets.only(left: 30,right: 30),
              child:Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(height: 100,),

                  Container(
                       width: 80,
                      child:Center(
                      child: CircleAvatar(
                        radius: 80,
                        backgroundImage: AssetImage("assets/smart_farm.jpg"),
                      ),
                    ),),
                  SizedBox(height: 30,),
                  TextField(
                    controller: txtNomFerme,
                    decoration: InputDecoration(
                        border:OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5)
                        ),
                      hintText: 'Nom du ferme',
                      isDense: true,                      // Added this
                      contentPadding: EdgeInsets.all(10),
                    ),
                  ),
                  SizedBox(height: 20,),
                  TextField(

                    controller: txtLieuFerme,
                    decoration: InputDecoration(
                        border:OutlineInputBorder(

                            borderRadius: BorderRadius.circular(5)
                        ),
                      hintText: 'Lieu',
                      isDense: true,                      // Added this
                      contentPadding: EdgeInsets.all(10),
                     ),
                  ),

                  SizedBox(height: 20,),
                  MaterialButton(onPressed: () { addFarm();},
                    child:
                    Container(
                      width: 150,
                      height: 45,
                      decoration: BoxDecoration(
                        color: Color(0xFF22780F),
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Save',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  )
                ],
              ),)));






  }
}
