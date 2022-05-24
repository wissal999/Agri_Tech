import 'dart:convert';

import 'package:agri_tech/Models/Reclamation.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
class ReclamationService{
  String url="http://192.168.43.130:8080";
  Future<List<Reclamation>> getReclamationByUserId(int idUser) async {
    final uri = Uri.parse("$url/getReclamationByIdUser/$idUser");
    var data = await http.get(uri);
    var jsonData = json.decode(data.body);
    List<Reclamation> Reclamations= [];
    for(var R in jsonData){
      Reclamation reclamation =Reclamation(R["id"],R["nomFermier"],R["email"],R["phoneNumber"],R["description"],R["resolution"],R["etatReclamation"],R["typeProbleme"]);
      Reclamations.add(reclamation);

    }


    return  Reclamations;
  }

  Future addReclamation(Reclamation reclamation,int idUser) async{
    final uri=Uri.parse("$url/addReclamation/$idUser");
    var req = await http.post(uri,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "nomFermier":reclamation.nomFermier,
          "email":reclamation.email,
          "phoneNumber":reclamation.phoneNumber,
          "etatReclamation":reclamation.etatReclamation,
          "description":reclamation.description
        }));
    if (req.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      Fluttertoast.showToast(msg: "succesful",toastLength: Toast.LENGTH_SHORT);
      return reclamation;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create album.');
    }

  }
 Future <List<Reclamation>> getAllReclamationsByTypeProbleme(String typeProbleme)async{
    final uri = Uri.parse("$url/getReclamationByTypeProbleme/$typeProbleme");
    var data = await http.get(uri);
    var jsonData = json.decode(data.body);
    List<Reclamation> Reclamations= [];
    for(var R in jsonData){
      Reclamation  reclamation =Reclamation(R["id"],R["nomFermier"],R["email"],R["phoneNumber"],R["description"],R["resolution"],R["etatReclamation"],R["typeProbleme"]);
      Reclamations.add( reclamation);

    }


    return  Reclamations;
  }

  updateReclamation (int? idReclamation,String response) async{
    final uri=Uri.parse("$url/updateResponseReclamation/$idReclamation/$response");
    var req = await http.put(uri,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
        }));
    if (req.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.

      Fluttertoast.showToast(msg: "Updated",toastLength: Toast.LENGTH_SHORT);


    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      Fluttertoast.showToast(msg: "Failed to update parcel.",toastLength: Toast.LENGTH_SHORT);

    }

  }

}

