import 'dart:convert';



import 'package:agri_tech/ListCultures.dart';
import 'package:agri_tech/Models/Culture.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class CultureService{
  String url="http://192.168.43.130:8080";

  Future <List<Culture>> getAllCultures()async{
    final uri = Uri.parse("$url/getAllCulture");
    var data = await http.get(uri);
    var jsonData = json.decode(data.body);
    List<Culture> Cultures= [];
    for(var C in jsonData){
      Culture  culture =Culture(C["idCulture"],C["nomCulture"],C["temperatureIdeale"],C["humiditeIdeale"],C["humidite_solIdeale"]);
      Cultures.add(culture);

    }


    return  Cultures;
  }

  Future addCulture(Culture culture) async{
    final uri=Uri.parse("$url/addCulture");
    var req = await http.post(uri,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "nomCulture":culture.nomCulture,
          "temperatureIdeale":culture.temperatureIdeale,
          "humiditeIdeale":culture.humiditeIdeale,
          "humidite_solIdeale":culture.humiditeIdeale,
        }));
    if (req.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      Fluttertoast.showToast(msg: "succesful",toastLength: Toast.LENGTH_SHORT);
      return culture;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      Fluttertoast.showToast(msg: "Failed to add culture.",toastLength: Toast.LENGTH_SHORT);
      throw Exception('Failed to add culture.');
    }

  }

  Future updateCulture(Culture culture,int idCulture) async{
    final uri=Uri.parse("$url/updateCulture/$idCulture");
    var req = await http.put(uri,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "nomCulture":culture.nomCulture,
          "temperatureIdeale":culture.temperatureIdeale,
          "humiditeIdeale":culture.humiditeIdeale,
          "humidite_solIdeale":culture.humiditeIdeale,
        }));
    if (req.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.

      Fluttertoast.showToast(msg: "Updated",toastLength: Toast.LENGTH_SHORT);

      return culture;

    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      Fluttertoast.showToast(msg: "Failed to update culture.",toastLength: Toast.LENGTH_SHORT);
      throw Exception('Failed to add culture.');
    }

  }

}