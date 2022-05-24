import 'dart:async';
import 'dart:convert';

import 'package:agri_tech/HomePageAdministrator.dart';
import 'package:agri_tech/ListCultures.dart';
import 'package:agri_tech/SignUp.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'BottomNavigation.dart';
import 'Dashbord.dart';
import 'Services/UserService.dart';


class Login extends StatefulWidget{

  @override
  State<StatefulWidget> createState()=>_LoginState() ;

}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  late TextEditingController emailCtrl,passwordCtrl;
  bool isHiddenPassword=true;
  String?  finalEmail,finalPassword;
  GlobalKey<FormState> _formKey= GlobalKey<FormState>();
  void _PasswordView(){

    setState(() {
      isHiddenPassword= !isHiddenPassword;
    });
  }
  Future getValidationData() async{
    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    var email=sharedPreferences.getString("email");
    var password=sharedPreferences.getString("password");
    if (email==null  && password == null) {
      Fluttertoast.showToast(msg: "Welcome",toastLength: Toast.LENGTH_SHORT);
    }
    else if(email=="ouissaltouaty99@gmail.com"){
      Navigator.push(context, MaterialPageRoute(builder: (context) => HomePageAdministrator() ));
    }else{
      Navigator.push(context, MaterialPageRoute(builder: (context) => BottomNavigation() ));
    }



  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    emailCtrl=new TextEditingController();
    passwordCtrl=new TextEditingController();
    getValidationData();

  }
  void login() async{

    Map data = {
      'email':emailCtrl.text,
      'password':passwordCtrl.text
    };
    var res= await UserService().loginService(data, context);
    var body=json.decode(res.body);
    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    sharedPreferences.setString("idUser",body["id"].toString());
    sharedPreferences.setString("email",body["email"]);
    sharedPreferences.setString("username",body["username"]);
    sharedPreferences.setString("password",body["password"]);
    sharedPreferences.setString("phoneNumber",body["phoneNumber"]);

    print(body["id"]);
    if(res.statusCode==200){
      if(emailCtrl.text=="ouissaltouaty99@gmail.com" && passwordCtrl.text=="overlord99"){
        Navigator.push(context, MaterialPageRoute(builder: (context) => HomePageAdministrator() ));
      }else{
        Navigator.push(context, MaterialPageRoute(builder: (context) => BottomNavigation() ));
      }


    }
    else{
      Fluttertoast.showToast(msg: "Failed to connect",toastLength: Toast.LENGTH_SHORT);
      throw Exception('Failed to connect');
    }

  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body:SingleChildScrollView(
            child: Padding( padding: EdgeInsets.only(left: 30,right: 30),
              child:Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(height: 150,),
                Center(
                  child:Text("Login",  style: TextStyle(
                    fontSize: 50,))),
                  SizedBox(height: 30,),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    maxLengthEnforced: false,
                    controller: emailCtrl,
                    decoration: InputDecoration(
                        border:OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5)
                        ),
                        prefixIcon: Icon(Icons.email),hintText: 'E-mail',

                      isDense: true,                      // Added this
                      contentPadding: EdgeInsets.all(10),
                    ),
                    validator: MultiValidator(
                        [
                          RequiredValidator(errorText: 'Champs Obligatoire*'),
                          EmailValidator(errorText: 'Email non valide')
                        ]
                    ),
                  ),
                  SizedBox(height: 20,),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    maxLengthEnforced: false,
                    obscureText: isHiddenPassword,
                    controller: passwordCtrl,
                    decoration: InputDecoration(
                      border:OutlineInputBorder(

                          borderRadius: BorderRadius.circular(5)
                      ),
                      isDense: true,                      // Added this
                      contentPadding: EdgeInsets.all(10),
                        prefixIcon: Icon(Icons.vpn_key)
                        ,hintText: 'Password',
                        suffixIcon:InkWell(
                            onTap:_PasswordView ,
                            child:Icon(Icons.visibility))
                    ),
                    validator: MultiValidator(
                        [
                          RequiredValidator(errorText: 'Champs Obligatoire*')
                        ]
                    ),
                  ),
                  SizedBox(height: 10,),
                  Center(child:
                  Text(
                    'Mot de Passe oublié ?',
                  ),),
                  SizedBox(height: 10,),
                  MaterialButton(onPressed: () {
                    if(_formKey.currentState!.validate()){
                      login();
                    }
                  },
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
                          'Se connecter',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                  ),
                  SizedBox(height: 10,),
              Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Vous n’avez pas de compte ?',

                ),
                InkWell(
                  child:  Text(
                    "S'inscrire",
                    style: TextStyle(
                      color: Color(0xFFFB4C0D),
                    ),
                  ),
                  onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp() ));},
                )

              ])

                ],

              ),
            ),
        )
    ));






  }
}
