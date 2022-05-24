import 'dart:convert';
import 'package:agri_tech/Models/Reclamation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Services/ReclamationService.dart';



class ListReclamations extends StatefulWidget{

  @override
  State<StatefulWidget> createState()=>_ListReclamationsState() ;

}

class _ListReclamationsState extends State<ListReclamations> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(  appBar: AppBar(
      title: Text("List Reclamations"),
      automaticallyImplyLeading: false,
      backgroundColor: Color(0xFF22780F),
    ),

      body: Container(
        margin: const EdgeInsets.only(top: 10.0),
        child:FutureBuilder(
            future:ReclamationService().getReclamationByUserId(1) ,
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
                    itemBuilder: (BuildContext, int index) {
                      return Card(
                            child: ListTile(
                              title: Text(snapshot.data[index].nomFermier !=null?snapshot.data[index].nomFermier:"vide"),
                              subtitle: Text(snapshot.data[index].email!=null?snapshot.data[index].email:"vide"),
                            
                            )
                        );
                        
                    }
                );
              }
            }
        ),
      ),);

  }}