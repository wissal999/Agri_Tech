import 'package:agri_tech/Models/ParcelJournal.dart';
import 'package:agri_tech/Services/ParcelService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Models/Farm.dart';
import 'Models/Parcel.dart';
import 'Services/FarmService.dart';


class Dashbord extends StatefulWidget{

  @override
  State<StatefulWidget> createState()=>_DashbordState() ;

}

class _DashbordState extends State<Dashbord> with SingleTickerProviderStateMixin {
  Parcel? SelectedParcel;
  late int SelectedIdParcel;
  late ParcelJournal parcel;
  List<Parcel> listParcels =[];
  Farm? SelectedFarm;
  late int SelectedIdFarm;
  List<Farm>? listFarms=[];
  bool typeArossage = false;
  bool etatArossage = false;
  Future<List<Farm>?>GetFarmsByUserId() async{
    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    var idUser=sharedPreferences.getString("idUser");

    listFarms=await FarmService().GetFarmsByUserId(idUser!);

    setState(() {

    });
    return listFarms;
  }

  Future GetNamesParcels()  async {
    final uri = Uri.parse("http://192.168.43.130:8080/getParcellesByIdFerme/$SelectedIdFarm");
    var data = await http.get(uri);

    var jsonData = json.decode(data.body);

    setState(() {

      listParcels = List<Parcel>.from(jsonData .map((model)=> Parcel.fromJson(model)));
    });

  }
  Future getLastJournalByNameParcelle() async {
   // await GetNamesParcels(SelectedIdFarm);
    final uri = Uri.parse("http://192.168.43.130:8080/getLastData/$SelectedIdParcel");
    var data = await http.get(uri);

    var jsonData = json.decode(data.body);
  setState(() {



  });

    return jsonData;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    asyncMethod();

  }
  void asyncMethod() async {
    await GetFarmsByUserId();
    SelectedIdFarm=listFarms![0].id;
    await GetNamesParcels();
    SelectedIdParcel=listParcels[0].id;
    getLastJournalByNameParcelle();

  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text("Tableau de bord"),
          backgroundColor: Color(0xFF22780F),
        ),
      body:SingleChildScrollView(
      child:Column(
        mainAxisSize: MainAxisSize.min,

        children: <Widget>[
          SizedBox(height: 20,),

      Container(
        margin: EdgeInsets.only(left: 20,right: 20),
        padding: EdgeInsets.only(left: 5,right: 5),
        decoration:BoxDecoration(
          border: Border.all(color: Colors.grey,width: 1),
          borderRadius: BorderRadius.circular(5)
        ) ,
        child: DropdownButtonFormField<Farm>(
          isExpanded: true,
          hint: Text("Selectionner une Ferme"),
          value: listFarms!.length >0 ?  listFarms![0]:SelectedFarm,
          items: listFarms!.map((Farm farm){
          return DropdownMenuItem<Farm>(
          value:farm,
          child:Text(farm.nomFerme));
          }).toList(),

          onChanged:(Farm? value){
          setState(() {
          SelectedFarm=value  ;
          SelectedIdFarm=value!.id;

          });
          print(SelectedIdFarm);
          GetNamesParcels();



          },

          onSaved:( value){
          setState(() {
          this.SelectedFarm=value  ;
          this.SelectedIdFarm=value!.id;

          });



    }/*DropdownButtonFormField(
            isExpanded: true,
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(0.0),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                isDense: true),
            hint: Text("Selectionner une parcelle"),
            dropdownColor: Colors.grey,

            value:listNamesParcels.length>0 ?  listNamesParcels[0]:SelectedName,
            items: listNamesParcels.map((Name){
              return DropdownMenuItem(
                  value:Name,
                  child:Text(Name,style: TextStyle(fontSize: 20)));
            }).toList(),

            onChanged:(value){
              setState(() {
                SelectedName=value.toString()  ;


              });

            },

            onSaved:( value){
              setState(() {
                this.SelectedName=value.toString()  ;

              });



            }*/
        ),

      ),
          SizedBox(height: 10,),
          Container(
            margin: EdgeInsets.only(left: 20,right: 20),
            padding: EdgeInsets.only(left: 5,right: 5),
            decoration:BoxDecoration(
                border: Border.all(color: Colors.grey,width: 1),
                borderRadius: BorderRadius.circular(5)
            ) ,
            child: DropdownButtonFormField<Parcel>(
                isExpanded: true,
                hint: Text("Selectionner une culture"),
                value: listParcels.length>0 ?  listParcels[0]:SelectedParcel,
                items: listParcels.map((Parcel parcelle){
                  return DropdownMenuItem<Parcel>(
                      value:parcelle,
                      child:Text(parcelle.nom));
                }).toList(),

                onChanged:(Parcel? value){
                  setState(() {
                    SelectedParcel=value  ;
                    SelectedIdParcel=value!.id;

                  });
                  print(SelectedIdParcel);
                },

                onSaved:( value){
                  setState(() {
                    this.SelectedParcel=value  ;

                  });



                }
            ),
          ),
          SizedBox(height: 20,),
           Container(
            child: FutureBuilder(
            future:getLastJournalByNameParcelle() ,
            builder: (BuildContext context,AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Container(
                  child: Center(
                    child: Text("Loading"),
                  ),
                );
              }
              else {
                return Column(

                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            CircularPercentIndicator(

                              radius: 105,
                              lineWidth: 13,
                              percent: snapshot.data["temperature"] == null
                                  ? 0
                                  : snapshot.data["temperature"] / 100,
                              progressColor: Color(0xFF22780F),
                              backgroundColor: Color(0x8022780F),
                              circularStrokeCap: CircularStrokeCap.round,
                              center: Text(
                                snapshot.data["temperature"] != null ? snapshot
                                    .data["temperature"].toString() : "N.D",
                                style: TextStyle(fontSize: 25),),
                              footer: Text(
                                "Temperature", style: TextStyle(fontSize: 20),),
                            ),
                            SizedBox(width: 40,),
                            CircularPercentIndicator(

                              radius: 105,
                              lineWidth: 13,
                              percent: snapshot.data["humidite"] == null
                                  ? 0
                                  : snapshot.data["humidite"] / 100,
                              progressColor: Color(0xFF22780F),
                              backgroundColor: Color(0x8022780F),
                              circularStrokeCap: CircularStrokeCap.round,
                              center: Text(snapshot.data["humidite"] != null ? snapshot
                                  .data["humidite"].toString() : "N.D",
                                style: TextStyle(fontSize: 25),),
                              footer: Text(
                                "Humidite ", style: TextStyle(fontSize: 20),),
                            ),

                          ]),
                      SizedBox(height: 5,),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            CircularPercentIndicator(

                              radius: 105,
                              lineWidth: 13,
                              percent:  snapshot.data["humidite_sol"] == null ? 0: snapshot
                                  .data["humidite_sol"] / 100 ,
                              progressColor: Color(0xFF22780F),
                              backgroundColor: Color(0x8022780F),
                              circularStrokeCap: CircularStrokeCap.round,
                              center: Text(snapshot.data["humidite_sol"] != null ? snapshot
                                  .data["humidite_sol"].toString() : "N.D",
                                style: TextStyle(fontSize: 25),),

                              footer: Text("Humidite Sol",
                                style: TextStyle(fontSize: 20),),
                            ),

                          ]),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Manuelle", style: TextStyle(fontSize: 20),),
                            TypeArossageSwitch(snapshot.data["id"]),
                            SizedBox(width: 20,),
                            Text("Eau ", style: TextStyle(fontSize: 20),),
                            EtatArossageSwitch(snapshot.data["id"]),

                          ])


                    ]
                );
              }
            })
    )

    ]
    )
      )
    );






  }
  Widget TypeArossageSwitch(int idParcel) => Transform.scale(
    scale: .8,
    child: CupertinoSwitch(

      activeColor:  Color(0xFF22780F),
      value: typeArossage,
      onChanged: (bool value) => setState(() {
      this.typeArossage=value;
      print(typeArossage);

        ParcelService().updateTypeArossage(idParcel,typeArossage);

      }),

    ),
  );
  Widget EtatArossageSwitch(int idParcel) => Transform.scale(
    scale: .8,
    child: CupertinoSwitch(

      activeColor:  Color(0xFF22780F),
      value: etatArossage,
      onChanged: (bool value) => setState(() {
        this.etatArossage=value;
        print(etatArossage);
        ParcelService().updateEtatArossage(idParcel,etatArossage);
      }),

    ),
  );
}
