

import 'package:agri_tech/AddCulture.dart';
import 'package:agri_tech/Models/Culture.dart';
import 'package:agri_tech/Services/CultureService.dart';
import 'package:flutter/material.dart';

class ListCultures extends StatefulWidget {
  const ListCultures({Key? key}) : super(key: key);

  @override
  State<ListCultures> createState() => _ListCulturesState();
}

class _ListCulturesState extends State<ListCultures> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(

        body:Container(

            child: FutureBuilder(
                      future:CultureService().getAllCultures(),
                      builder: (BuildContext context,AsyncSnapshot snapshot) {
                        if (snapshot.data == null) {
                          return Container(
                            child: Center(
                              child: Text("Loading"),
                            ),
                          );
                        }
                        else {
                          List<Culture> data = snapshot.data;
                          return Container(
                              child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child:DataTable(
                                    columns: const<DataColumn>[
                                      DataColumn(label: Text("Libelle Culture ")),
                                      DataColumn(label: Text("Temperature ideale")),
                                      DataColumn(label: Text("Humidite ideale")),
                                      DataColumn(label: Text("Humidite Sol ideale")),

                                    ],
                                    rows: [
                                      for (var item in data)
                                        DataRow(cells:<DataCell>[
                                          DataCell(Text(item.nomCulture,textAlign:TextAlign.center,)),
                                          DataCell(Text(item.temperatureIdeale.toString(),textAlign:TextAlign.center,)),
                                          DataCell(Text(item.humiditeIdeale.toString(),textAlign:TextAlign.center,)),
                                          DataCell(Text(item.humiditeSolIdeale.toString(),textAlign:TextAlign.center,)),

                                        ],onLongPress:(){
                                          Navigator.push(context, MaterialPageRoute(builder: (context) =>AddCulture(item) ));
                                        })
                                    ],
                                  )));
                          debugPrint('delete button clicked');
                        }
                      }),
                ),

        floatingActionButton: FloatingActionButton(
    child: Icon(Icons.add),
    backgroundColor:Color(0xFF22780F),
    onPressed: () {
    print("pressed it");
    Navigator.push(context, MaterialPageRoute(builder: (context) =>AddCulture(null) ));
    },

    )
    );
  }
}
