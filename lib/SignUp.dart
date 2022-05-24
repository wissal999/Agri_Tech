import 'dart:convert';

import 'package:agri_tech/Services/UserService.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:http/http.dart' as http;

class SignUp extends StatefulWidget{

  @override
  State<StatefulWidget> createState()=>_SignUpState() ;

}

class _SignUpState extends State<SignUp> with SingleTickerProviderStateMixin {
  late TextEditingController usernameCtrl,emailCtrl,phoneNumberCtrl,passwordCtrl;
  bool isHiddenPassword=true;
  GlobalKey<FormState> _formKey= GlobalKey<FormState>();
  void _PasswordView(){

    setState(() {
      isHiddenPassword= !isHiddenPassword;
    });
  }
  void signUp() async{

    Map data = {
      'username': usernameCtrl.text,
      'email':emailCtrl.text,
      'phoneNumber':phoneNumberCtrl.text,
      'password':passwordCtrl.text
    };
     var res= await UserService().signUpService(data,context);


  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    usernameCtrl=TextEditingController();
    emailCtrl= TextEditingController();
    phoneNumberCtrl=TextEditingController();
    passwordCtrl=TextEditingController();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body:SingleChildScrollView(
          child: Padding( padding: EdgeInsets.only(left: 30,right: 30),
            child:Form(
              key: _formKey,
              child: Column(
              children: <Widget>[
                SizedBox(height: 80,),
                Center(
                    child:Text("Inscription",  style: TextStyle(
                      fontSize: 50,))),
                SizedBox(height: 20,),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  maxLength: 15,
                  maxLengthEnforced: false,
                  controller: usernameCtrl,
                  decoration: InputDecoration(
                    border:OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5)
                    ),
                      labelText: 'Username',
                    prefixIcon: Icon(Icons.person),
                    isDense: true,                      // Added this
                    contentPadding: EdgeInsets.all(10),
                  ),
                  validator: MultiValidator(
                    [
                      RequiredValidator(errorText: 'Champs Obligatoire*')
                    ]
                  ),
                ),
                SizedBox(height: 5,),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  maxLength: 15,
                  maxLengthEnforced: false,
                  controller: emailCtrl,
                  decoration: InputDecoration(
                    border:OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5)
                    ),
                    prefixIcon: Icon(Icons.email),
                    labelText: 'E-mail',
                    isDense: true,                      // Added this
                    contentPadding: EdgeInsets.all(10),
                  ),
                  validator: MultiValidator(
                      [
                        RequiredValidator(errorText: 'Champs Obligatoire*'),
                        EmailValidator(errorText: 'Email non valide')
                      ])
                ),
                SizedBox(height:5,),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  maxLength: 15,
                  maxLengthEnforced: false,
                  controller: phoneNumberCtrl,
                  decoration: InputDecoration(
                    border:OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5)
                    ),
                    prefixIcon: Icon(Icons.phone),
                    labelText: 'Numéro de téléphone',

                    isDense: true,                      // Added this
                    contentPadding: EdgeInsets.all(10),
                  ),
                    validator: MultiValidator(
                        [
                          RequiredValidator(errorText: 'Required*'),

                        ])
                ),
                SizedBox(height: 5,),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  maxLength: 15,
                  maxLengthEnforced: false,
                  obscureText: isHiddenPassword,
                  controller: passwordCtrl,
                  decoration: InputDecoration(
                      border:OutlineInputBorder(

                          borderRadius: BorderRadius.circular(5)
                      ),
                      isDense: true,                      // Added this
                      contentPadding: EdgeInsets.all(10),
                      prefixIcon: Icon(Icons.vpn_key),
                      labelText: 'Mot de passe',

                      suffixIcon:InkWell(
                          onTap:_PasswordView ,
                          child:Icon(Icons.visibility))
                  ),
                    validator: MultiValidator(
                        [
                          RequiredValidator(errorText: 'Required*'),
                          MinLengthValidator(6,
                              errorText: "Le mot de passe doit comporter au moins 6 caractères"),
                          MaxLengthValidator(15,
                              errorText:
                              "Le mot de passe ne doit pas dépasser 15 caractères"),


                        ])
                ),
                SizedBox(height: 5,),
                Center(child:
                Text(
                  'Mot de Passe oublié ?',
                ),),
                SizedBox(height: 5,),
                MaterialButton(onPressed: () {
                  if(_formKey.currentState!.validate()){
                    signUp();
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
                       "S'inscrire",
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
                      Text(
                          "S'inscrire",
                          style: TextStyle(
                            color: Color(0xFFFB4C0D),
                          )

                      ),
                    ])

              ],

            ),
          ),
        )
    ));






  }

}
