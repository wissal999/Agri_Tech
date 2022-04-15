import 'dart:convert';

import 'package:agri_tech/ListParcels.dart';
import 'package:agri_tech/Models/Farm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:http/http.dart' as http;

import 'AddFarm.dart';


class ListFarms extends StatefulWidget{

  @override
  State<StatefulWidget> createState()=>_ListFarmsState() ;

}

class _ListFarmsState extends State<ListFarms> with SingleTickerProviderStateMixin {
  Future<List<Farm>> GetAllUsers() async {
    final uri = Uri.parse("http://192.168.43.130:8080/getAllFerme");
    var data = await http.get(uri);
    var jsonData = json.decode(data.body);
    List<Farm> farms = [];
    for (var f in jsonData) {
      Farm farm = Farm(f["id"], f["nom"], f["lieu"]);
      farms.add(farm);
    }
    setState(() {

    });
    return farms;
  }

  void deleteFarm(String id) async {
    final uri = Uri.parse("http://192.168.43.130:8080/deleteFerme/$id");
    final http.Response response = await http.delete(
    uri,
    );

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey[200],
        appBar: AppBar(
        title: Text("Liste Fermes"),
      ),

      body: Container(
      margin: const EdgeInsets.only(top: 10.0),
           child:FutureBuilder(
              future:GetAllUsers() ,
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
                return Slidable(

                /*return Dismissible(

                key: ValueKey(snapshot.data[index].id.toString()),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.amberAccent,
                  child: Icon(Icons.delete,color: Colors.white,size: 40,),
                  margin: EdgeInsets.all(8.0),
                ),
                confirmDismiss: (direction){
                  return showDialog(context: context, builder: (ctx)=>AlertDialog(
                    title: Text("Please confirm"),
                    content: Text("Are you sure you want to delete ?"),
                    actions: [
                      ElevatedButton(onPressed:(){Navigator.of(ctx).pop(false);}, child:Text("Cancel")),
                      ElevatedButton(onPressed:(){Navigator.of(ctx).pop(true);}, child:Text("Delete"))
                    ],
                  )
                  );
                },
                  onDismissed:(direction) {
                  if(direction==DismissDirection.endToStart){
                    setState(() {
                      deleteFarm(snapshot.data[index].id.toString());
                    });




                  }

                  },*/
                actionPane: SlidableDrawerActionPane(),
                child:Card(
              child: ListTile(
                title: Text(snapshot.data[index].nomFerme),
                subtitle: Text(snapshot.data[index].lieuFerme),
                onTap: (){
                  Navigator.push(context,MaterialPageRoute(builder: (context)=> ListParcels(snapshot.data[index].id)));
                },
              )
                ),
                actions: [
                  Container(
                    margin: EdgeInsets.all(5.0),
                  child: IconSlideAction(
                    caption: "Delete",
                    color: Colors.red,
                    icon: Icons.delete,

                    onTap: (){
                      showDialog(context: context, builder: (ctx)=>AlertDialog(
                        title: Text("Please confirm"),
                        content: Text("Are you sure you want to delete ?"),
                        actions: [
                          ElevatedButton(onPressed:(){Navigator.of(ctx).pop(false);}, child:Text("Cancel")),
                          ElevatedButton(onPressed:(){
                            Navigator.of(ctx).pop(true);
                            deleteFarm(snapshot.data[index].id.toString());
                          }, child:Text("Delete"))
                        ],
                      )
                      );
                    },
                  ),),
                Container(
                margin: EdgeInsets.all(5.0),
                child:IconSlideAction(
                      caption: "Edit",
                      color: Colors.blue,
                      icon: Icons.edit,
                      onTap: (){}),)
                ],
                );
            }
        );
      }
    }
    ),
      ),
        floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
          backgroundColor:Color(0xFF22780F),
    onPressed: () {
    print("pressed it");
    Navigator.push(context,MaterialPageRoute(builder: (context)=> AddFarm()));
    },

    ));






  }
}
