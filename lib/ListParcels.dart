import 'dart:convert';
import 'package:agri_tech/Models/ParcelJournal.dart';
import 'package:agri_tech/UpdateParcel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:http/http.dart' as http;

import 'Models/Culture.dart';
import 'Models/Parcel.dart';


class ListParcels extends StatefulWidget{

  final int idFerme;
  const ListParcels(this.idFerme);
  @override
  State<StatefulWidget> createState()=>_ListParcelsState() ;

}

class _ListParcelsState extends State<ListParcels> with SingleTickerProviderStateMixin {
  Culture? SelectedCulture;
  late int SelectedIdCulture;
  List<Culture> listCultures =[];
  late TextEditingController txtLibelleParcel,txtSurfaceParcel,txtTotalImplantation;
  Future GetAllCultures() async {
    final uri = Uri.parse("http://192.168.43.130:8080/getAllCulture");
    var data = await http.get(uri);

    var jsonData = json.decode(data.body);


    setState(() {
      for (var c in jsonData) {
        Culture culture = Culture(c["idCulture"], c["nomCulture"], c["temperatureIdeale"], c["humiditeIdeale"], c["humidite_solIdeale"]);
        listCultures.add(culture);
      }
    });
    print( listCultures);
  }

  void addParcel(String idFerme,String idCulture) async{
    final uri=Uri.parse("http://192.168.43.130:8080/addParcelle/$idFerme/$idCulture");

    Map data = {
      'nom': txtLibelleParcel.text,
      'surface':txtSurfaceParcel.text,
      'totaleImplantation':txtTotalImplantation.text
    };
    //encode Map to JSON
    var body = json.encode(data);
    var response = await http.post(uri,
        headers: {"Content-Type": "application/json"},
        body: body
    );
    print("${response.statusCode}");
    print("${response.body}");


  }

  Future<List<ParcelJournal>> GetParcelsByFarmId(String idFerme) async {
    final uri = Uri.parse("http://192.168.43.130:8080/getLastJournalParcelleByIdFerme/$idFerme");
    var data = await http.get(uri);
    var jsonData = json.decode(data.body);
    List<ParcelJournal> Parcels= [];
    for(var p in jsonData){
      ParcelJournal  parcel =ParcelJournal(p["id"],p["nom"],p["surface"],p["totaleImplantation"],p["etatArrosage"],p["typeArrosage"],p["temperatureIdeale"],p["humiditeIdeale"],p["humidite_solIdeale"],p["idCulture"],p["nomCulture"],p["temperature"]!=null?p["temperature"]:0,p["humidite"]!=null?p["humidite"]:0,p["humidite_sol"]!=null?p["humidite_sol"]:0);
      Parcels.add(parcel);

    }
    setState(() {

    });

    return  Parcels;
  }
  void deleteParcel(String idParcel) async {
    final uri = Uri.parse("http://192.168.43.130:8080/deleteParcelle/$idParcel");
    final http.Response response = await http.delete(
      uri,
    );

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    txtLibelleParcel=new TextEditingController();
    txtSurfaceParcel=new TextEditingController();
    txtTotalImplantation=new TextEditingController();
    GetAllCultures();
    print( GetParcelsByFarmId(widget.idFerme.toString()));
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("Liste Parelles"),
        backgroundColor: Color(0xFF22780F),
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
                    return Slidable(

                          actionPane: SlidableDrawerActionPane(),
                      child:Card(
                            child: ListTile(
                              title: Text(snapshot.data[index].nom),
                              subtitle: Row(
                                children: [
                                  Text("Temp :"+snapshot.data[index].temperature.toString()+"°C"),
                                  SizedBox(width: 30,),
                                  Text("Hum:"+snapshot.data[index].humidite.toString()+"%"),
                                  SizedBox(width: 30,),
                                  Text("Hum Sol :"+snapshot.data[index].humidite_sol.toString()+"%"),
                                ],
                              ),

                            )
                        ),

                      actions: [
                      Container(
                        margin: EdgeInsets.all(5.0),
                        child: IconSlideAction(
                          caption: "Delete",
                          color:  Color(0xFFFB4C0D),
                          icon: Icons.delete,

                          onTap: (){
                            showDialog(context: context, builder: (ctx)=>AlertDialog(
                              title: Text("Please confirm"),
                              content: Text("Are you sure you want to delete ?"),
                              actions: [
                                ElevatedButton(onPressed:(){Navigator.of(ctx).pop(false);}, child:Text("Cancel")),
                                ElevatedButton(onPressed:(){
                                  Navigator.of(ctx).pop(true);
                                  deleteParcel(snapshot.data[index].id.toString());
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
                            color:Color(0xFF22780F),
                            icon: Icons.edit,
                            onTap: (){
                              Navigator.push(context,MaterialPageRoute(builder: (context)=> UpdateParcel( snapshot.data,index,listCultures)));
                            }),)
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
            OpenDialog();

          },

        )

    );






  }
  Future OpenDialog()=> showDialog(context: context, builder: (ctx)=>AlertDialog(
    title: Text("Please confirm"),
    content: SingleChildScrollView(
  child: Form(
  child:Column(
        mainAxisSize: MainAxisSize.min,

          children: <Widget>[
            TextField(

                controller: txtLibelleParcel,
                decoration: InputDecoration(
                    border:OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5)
                    ),
                    hintText: 'libelle parcelle'

                )
            ),
            SizedBox(height: 10,),
          /*  DropdownButtonFormField(
                isExpanded: true,
                hint: Text("Selectionner une culture"),
                value: SelectedCulture,
                items: Cultures.map((culture){
                  return DropdownMenuItem<String>(
                      value:culture['nom'].toString(),
                      child:Text(culture['nom']));

                }).toList(),
             onChanged:(String? value){
               setState(() {
                 this.SelectedCulture=value  ;
                 });
                 },
                onSaved:(String? value){
                  setState(() {
                    this.SelectedCulture=value  ;

                  });

                }),*/
            DropdownButtonFormField<Culture>(
                isExpanded: true,
                hint: Text("Selectionner une culture"),
                value: SelectedCulture,
                items: listCultures.map((Culture culture){
                  return DropdownMenuItem<Culture>(
                      value:culture,
                      child:Text(culture.nomCulture));
                }).toList(),

                onChanged:(Culture? value){
                    setState(() {
                      SelectedCulture=value  ;
                      SelectedIdCulture=value!.id!;

                    });
                    print(SelectedIdCulture);
                },

                onSaved:( value){
                    setState(() {
                        this.SelectedCulture=value  ;

                      });



}
  ),
            SizedBox(height: 10,),
            TextField(
                controller: txtSurfaceParcel,
                decoration: InputDecoration(
                  border:OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5)
                  ),
                    hintText: 'Surface'
                )),
            SizedBox(height: 10,),
            TextField(
                controller: txtTotalImplantation,
                decoration: InputDecoration(
                    border:OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5)
                    ),
                    hintText: 'Total implantation'
                ))
          ]
      ),)),


    actions: [
      ElevatedButton(onPressed:(){Navigator.of(ctx).pop(false);}, child:Text("Annuler")),
      ElevatedButton(onPressed:(){
        Navigator.of(ctx).pop(true);
        addParcel(widget.idFerme.toString(),SelectedIdCulture.toString());
      }, child:Text("Ajouter"))
    ],
  )
  );
}
