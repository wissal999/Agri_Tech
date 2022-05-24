import 'dart:convert';
import 'package:agri_tech/Models/Reclamation.dart';
import 'package:agri_tech/Models/TypeProbleme.dart';
import 'package:agri_tech/Services/TypeProblemesService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:agri_tech/Services/ReclamationService.dart';
import 'package:shared_preferences/shared_preferences.dart';





List<TypeProbleme>TypesProblemes=[];
class AddReclamation extends StatefulWidget{

  @override
  _AddReclamationState createState()=>_AddReclamationState() ;

}

class _AddReclamationState extends State<AddReclamation> {
late TextEditingController descriptionCtrl;
late TypeProbleme typeProbleme;

Future<Reclamation> addReclamation() async {
  SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
  var idUser=sharedPreferences.getString("idUser");
  var email=sharedPreferences.getString("email");
  var username=sharedPreferences.getString("username");
  var phoneNumber=sharedPreferences.getString("phoneNumber");

  Reclamation reclamation=Reclamation( null,username!,email!,phoneNumber!,descriptionCtrl.text, null, "en cours",TypesProblemes);
  Reclamation addReclamtion =await ReclamationService().addReclamation(reclamation,int.parse(idUser!));
  setState(() {

  });
return addReclamtion;
}
@override
void initState() {
  super.initState();
  descriptionCtrl=new TextEditingController();
  print(TypesProblemes.length);
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Ajout  Reclamation"),
          backgroundColor: Color(0xFF22780F),
        ),
    body:  Column(
    children: [
        Expanded(
        flex: 2,
        child:
        Padding(
        padding: const EdgeInsets.only(left: 20,right: 20,top: 30),
        child: Text("Vous pouvez deposer une reclamation si vous avez rencontrer des problemes lors de l'utilisation de notre application",textAlign: TextAlign.center,style:TextStyle(fontSize: 17,)  ),),
        ),
      Expanded(
    flex: 4,
    child: Container(

    padding:  EdgeInsets.only(left: 20,right: 20,bottom: 20),
    child: FutureBuilder(

    future:TypeProblemesService().GetAllTypesProblemes(),
    builder: (BuildContext context,AsyncSnapshot snapshot) {
    if (snapshot.data == null) {
    return Container(
    child: Center(
    child: Text("Loading"),
    ),
    );
    }
    else {
    return ListView.builder(
    itemCount: snapshot.data.length,
    itemBuilder: (BuildContext, int i) {
      typeProbleme= snapshot.data[i];

      return checkListTile(typeProbleme:typeProbleme, check: false);
  });}})

    )),
      Expanded(
          flex: 3,
          child:Padding(
          padding: EdgeInsets.only(right: 20,left: 20),
          child:TextFormField(
            controller: descriptionCtrl,
      minLines: 5,
      maxLines: 5,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
      hintText:"Enter description",
      hintStyle: TextStyle(color: Colors.grey),
        border:OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5))
        )
    ),)),),
    Expanded(
    flex: 2,
    child:MaterialButton(onPressed: () {
      if(TypesProblemes.isNotEmpty){
        for(int i=0;i>TypesProblemes.length;i++){
          print(TypesProblemes[i].nom);
          print(TypesProblemes.length);
        }
        addReclamation();
      }
      else{
        Fluttertoast.showToast(msg: "emptyy",toastLength: Toast.LENGTH_SHORT);
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
              "Envoyer",
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          )
      ),)]));
  }}


  
  class checkListTile extends StatefulWidget {
    final TypeProbleme typeProbleme;
    bool check;
    checkListTile({Key? key, required this.typeProbleme,required this.check}) : super(key: key) ;
  
    @override
    State<checkListTile> createState() => _checkListTileState();
  }

  class _checkListTileState extends State<checkListTile> with SingleTickerProviderStateMixin {
    fill_list(bool value){
      if(value){
        TypesProblemes.add(widget.typeProbleme);


      }else{
        TypesProblemes.remove(widget.typeProbleme);
        print(TypesProblemes);
      }
    }

  
    @override
    void initState() {
      super.initState();

    }
  
    @override
    Widget build(BuildContext context) {
      return CheckboxListTile(
          controlAffinity: ListTileControlAffinity.leading,
        title:Text(widget.typeProbleme.nom,style:TextStyle(fontSize: 17)),
          value: widget.check,
          onChanged:(value){
            setState(() {
              widget.check=value!;
              fill_list(value);
            });


          });
    }
  }
  