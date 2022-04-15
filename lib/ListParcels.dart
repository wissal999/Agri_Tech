import 'dart:convert';
import 'package:agri_tech/Models/ParcelJournal.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;


class ListParcels extends StatefulWidget{

  final int idFerme;

  const ListParcels(this.idFerme);
  @override
  State<StatefulWidget> createState()=>_ListParcelsState() ;

}

class _ListParcelsState extends State<ListParcels> with SingleTickerProviderStateMixin {
  Future<List<ParcelJournal>> GetParcelsByFarmId(String idFerme) async {
    final uri = Uri.parse("http://192.168.43.130:8080/getLastJournalParcelleByIdFerme/34");
    var data = await http.get(uri);
    var jsonData = json.decode(data.body);
    List<ParcelJournal> Parcels= [];
    for (var P in jsonData) {
      ParcelJournal parcel = ParcelJournal(P["id"]==null? 0:P["id"],P["nom"]==null? null:P["nom"],P["surface"]==null? 0:P["surface"],P["totaleImplantation"]==0? null:P["totaleImplantation"],P["etatArrosage"]==null? false:P["etatArrosage"],P["typeArrosage"]==null? false:P["typeArrosage"],P["date"]==null? "":P["date"],P["temperature"]==null? 0:P["temperature"],P["humidite"]==null? 0:P["humidite"],P["humidite_sol"]==null? 0:P["humidite_sol"]);
      Parcels.add(parcel);
    }
    setState(() {

    });
    print( widget.idFerme);
    return  Parcels;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(GetParcelsByFarmId("34"));
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("Liste Parelles"),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 10.0),
        child:FutureBuilder(
            future:GetParcelsByFarmId(widget.idFerme.toString()) ,
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
                              title: Text(snapshot.data[index].nom),
                              subtitle: Text(snapshot.data[index].surface.toString()),
                              onTap: (){

                              },
                            )
                        );

                    }
                );
              }
            }
        ),
      ),

    );






  }
}
