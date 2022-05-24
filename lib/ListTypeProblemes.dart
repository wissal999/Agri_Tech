

import 'package:agri_tech/AddCulture.dart';
import 'package:agri_tech/Models/Culture.dart';
import 'package:agri_tech/Models/TypeProbleme.dart';
import 'package:agri_tech/Services/CultureService.dart';
import 'package:agri_tech/Services/TypeProblemesService.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

class ListTypesProblemes extends StatefulWidget {


  @override
  State<ListTypesProblemes> createState() => _ListTypesProblemesState();
}

class _ListTypesProblemesState extends State<ListTypesProblemes> {
  late TextEditingController libelleProblemeCtrl,descriptionProblemeCtrl;
List<TypeProbleme> typeProblems=[];

  Future<List<TypeProbleme>>GetAllTypeProblemes() async {


    typeProblems=await TypeProblemesService().GetAllTypesProblemes();
    setState(() {

    });
    return typeProblems;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    libelleProblemeCtrl=new TextEditingController();
    descriptionProblemeCtrl=new TextEditingController();


  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(

        body:Container(

          child: FutureBuilder(
              future:GetAllTypeProblemes(),
              builder: (BuildContext context,AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return Container(
                    child: Center(
                      child: Text("Loading"),
                    ),
                  );
                }
                else {
                  List<TypeProbleme> data = snapshot.data;
                  return Container(
                      child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child:DataTable(
                            columns: const<DataColumn>[
                              DataColumn(label: Text("Libelle probleme")),
                              DataColumn(label: Text("Description")),


                            ],
                            rows: [
                              for (var item in data)
                                DataRow(cells:<DataCell>[
                                  DataCell(Text(item.nom,textAlign:TextAlign.center,)),
                                  DataCell(Text(item.descriptionProbleme.toString(),textAlign:TextAlign.center,)),


                                ],onLongPress:(){
                                  DeleteTypeProbleme(item.id);
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
            AddTypeProbleme();
          },

        )
    );
  }

  Future DeleteTypeProbleme(int? id)=> showDialog(context: context, builder: (ctx)=>AlertDialog(
    title: Text("Suppression type probleme",style: TextStyle(fontSize: 18),),
    content: Text("Voulez-vous vraiment supprimez ce type?"),

    actions: [
      ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.white,
          ),
          onPressed:(){Navigator.of(ctx).pop(false);}, child:Text("Annuler",style: TextStyle(color: Colors.black87),)),
      ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Color(0xFF22780F),
          ),
          onPressed:(){
            TypeProblemesService().deleteTypeProbleme(id);
            Navigator.of(ctx).pop(true);
          }, child:Text("Confirmer"))
    ],
  )
  );
  Future AddTypeProbleme()=> showDialog(context: context, builder: (ctx)=>AlertDialog(
    title: Text("Ajout type probleme"),
    content: SingleChildScrollView(
        child: Form(
          child:Column(
              mainAxisSize: MainAxisSize.min,

              children: <Widget>[
                TextFormField(
                    controller: libelleProblemeCtrl,
                    decoration: InputDecoration(
                        border:OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5)
                        ),
                        hintText: 'Libelle probleme'
                    ), validator: MultiValidator(
                    [
                      RequiredValidator(errorText: 'Champs Obligatoire*'),
                    ]
                ),),
                SizedBox(height: 10,),
                TextFormField(
                    controller: descriptionProblemeCtrl,
                    decoration: InputDecoration(
                        border:OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5)
                        ),
                        hintText: 'Description probleme'
                    ),
                  validator: MultiValidator(
                    [
                      RequiredValidator(errorText: 'Champs Obligatoire*'),

                    ]
                ),
                )
              ]
          ),)),


    actions: [
      ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.white,
          ),
          onPressed:(){Navigator.of(ctx).pop(false);}, child:Text("Annuler",style: TextStyle(color: Colors.black87),)),
      ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Color(0xFF22780F),
          ),
          onPressed:(){
        TypeProblemesService().addTypeProbleme(TypeProbleme(null,libelleProblemeCtrl.text,descriptionProblemeCtrl.text));
            Navigator.of(ctx).pop(true);
          }, child:Text("Ajouter"))
    ],
  )
  );
}