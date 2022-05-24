import 'dart:convert';


import 'package:agri_tech/Dashbord.dart';
import 'package:agri_tech/Login.dart';
import 'package:agri_tech/Models/TypeProbleme.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
class TypeProblemesService{
  String url="http://192.168.43.130:8080";
 Future<List<TypeProbleme>> GetAllTypesProblemes() async {
    final uri = Uri.parse("$url/getTypeProblemes");
    var data = await http.get(uri);
    var jsonData = json.decode(data.body);
    List<TypeProbleme> TypeProblemes= [];
    for(var p in jsonData){
      TypeProbleme parcel =TypeProbleme(p["id"],p["nom"],p["descriptionProbleme"]);
      TypeProblemes.add(parcel);

    }


    return  TypeProblemes;
  }


Future addTypeProbleme(TypeProbleme typeProbleme) async{
  final uri=Uri.parse("$url/addTypeProbleme");
  var req = await http.post(uri,
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "nom":typeProbleme.nom,
        "descriptionProbleme":typeProbleme.descriptionProbleme,

      }));
  if (req.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    Fluttertoast.showToast(msg: "Added",toastLength: Toast.LENGTH_SHORT);
    return  typeProbleme;
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Failed to add typeProbleme .');
  }

}


  void deleteTypeProbleme(int? id) async {
    final uri = Uri.parse("$url/deleteTypeProbleme/$id");
    final http.Response response = await http.delete(
      uri,
    );

  }

}
