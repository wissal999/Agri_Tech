import 'dart:convert';
import 'package:agri_tech/AddReclamation.dart';
import 'package:agri_tech/ListReclamations.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Login.dart';





class SettingsPage extends StatefulWidget{

  @override
  _SettingsPageState createState()=>_SettingsPageState() ;

}

class _SettingsPageState extends State<SettingsPage> {
  void logout() async{
    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    sharedPreferences.remove('idUser');
    sharedPreferences.remove('email');
    sharedPreferences.remove('username');
    sharedPreferences.remove('password');
    sharedPreferences.remove('phoneNumber');
    Navigator.push(context,MaterialPageRoute(builder: (context)=> Login()));

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Paramettres"),
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF22780F),
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(20),
          children: [
              SimpleSettingsTile(
                title:"Profile",
                subtitle: "",
                leading: Icon(Icons.person),

              ),
              SimpleSettingsTile(
                title:"Liste de  Reclamations",
                subtitle: "",
                leading: Icon(Icons.list),
                  onTap: (){
                    Navigator.push(context,MaterialPageRoute(builder: (context)=> ListReclamations()));
                  }
              ),
              SimpleSettingsTile(
                title:"Deconnexion",
                subtitle: "",
                leading: Icon(Icons.logout),
                  onTap: (){
                    logout();

                  }
              ),
            SettingsGroup(title: "General",
                children:[
                  SimpleSettingsTile(
                    title:"A propos de nous",
                    subtitle: "",
                    leading: Icon(Icons.info),

                  ),
                  SimpleSettingsTile(
                    title:"Ajout reclamation",
                    subtitle: "",
                    leading: Icon(Icons.add_comment),
                    onTap: (){
                      Navigator.push(context,MaterialPageRoute(builder: (context)=> AddReclamation()));
                    }),


            ])
          ],
        ),
      ),
    );
  }
}