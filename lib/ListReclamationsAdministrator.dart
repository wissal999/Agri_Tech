

import 'package:agri_tech/AddCulture.dart';
import 'package:agri_tech/AddReclamation.dart';
import 'package:agri_tech/Models/Culture.dart';
import 'package:agri_tech/Models/Reclamation.dart';
import 'package:agri_tech/Services/CultureService.dart';
import 'package:agri_tech/Services/ReclamationService.dart';
import 'package:agri_tech/Services/TypeProblemesService.dart';
import 'package:flutter/material.dart';

import 'Models/TypeProbleme.dart';

class ListReclamationsAdministrator extends StatefulWidget {


  @override
  State<ListReclamationsAdministrator> createState() => _ListReclamationsAdministratorState();
}

class _ListReclamationsAdministratorState extends State<ListReclamationsAdministrator> {
   String? SelectedTypeProbleme;
  List<String> listNamesTypeProblemes=[];
   List<Reclamation > reclamations=[];
   late TextEditingController txtReponseCtrl;
    Future getlistNamesTypeProblemes() async {
    List<TypeProbleme> listTypeProblemes= await TypeProblemesService().GetAllTypesProblemes();
       setState(() {
         for(var T in listTypeProblemes){
           listNamesTypeProblemes.add(T.nom);

         }

       });
  }

   Future getAllReclamationsByTypeProbleme() async {
    reclamations=await ReclamationService().getAllReclamationsByTypeProbleme(SelectedTypeProbleme!);
     setState(() {
       print(reclamations);
     });
     return reclamations;
   }
   void asyncMethod() async {
     await getlistNamesTypeProblemes();
     SelectedTypeProbleme=listNamesTypeProblemes[0];
     getAllReclamationsByTypeProbleme();
   }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    txtReponseCtrl=new TextEditingController();
    asyncMethod();

  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(

        body:Container(

          child: Column(

        children:[
       Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(10),
              decoration:BoxDecoration(
                  border: Border.all(color: Colors.grey,width: 1),
                  borderRadius: BorderRadius.circular(5)
              ) ,
              child:DropdownButtonFormField(
            isExpanded: true,
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(0.0),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                isDense: true),
            hint: Text("Selectionner un type probleme"),
            dropdownColor: Colors.grey,

            value:listNamesTypeProblemes.length>0 ? listNamesTypeProblemes[0]: SelectedTypeProbleme,
            items: listNamesTypeProblemes.map((Name){
              return DropdownMenuItem(
                  value:Name,
                  child:Text(Name,style: TextStyle(fontSize: 20)));
            }).toList(),

            onChanged:(value){
              setState(() {
                SelectedTypeProbleme=value.toString()  ;


              });

            },

            onSaved:( value) {
              setState(() {
                this. SelectedTypeProbleme = value.toString();
              });
            }
          ),),
          FutureBuilder(
              future:getAllReclamationsByTypeProbleme(),
              builder: (BuildContext context,AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return Container(
                    child: Center(
                      child: Text("Loading"),
                    ),
                  );
                }
                else {
                  List<Reclamation> data = snapshot.data;
                  return Container(
                      child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child:DataTable(
                            columns: const<DataColumn>[
                              DataColumn(label: Text("Username ")),
                              DataColumn(label: Text("Email")),
                              DataColumn(label: Text("Description")),
                              DataColumn(label: Text("Etat reclamation")),
                              DataColumn(label: Text("Resolution")),
                              DataColumn(label: Text("Repondre")),
                            ],
                            rows: [
                              for (var item in data)
                                DataRow(cells:<DataCell>[
                                  DataCell(Text(item.nomFermier,textAlign:TextAlign.center,)),
                                  DataCell(Text(item.email.toString(),textAlign:TextAlign.center,)),
                                  DataCell(Text(item.description.toString(),textAlign:TextAlign.center,)),
                                  DataCell(Text(item.etatReclamation.toString(),textAlign:TextAlign.center,)),
                                  DataCell(Text(item.resolution.toString(),textAlign:TextAlign.center,)),
                                  DataCell( IconButton(icon: new Icon(Icons.reply),
                                    onPressed: () {
                                    OpenDialog(item.id,txtReponseCtrl.text);
                                    },)),


                                ],onLongPress:(){

                                }
                                )
                            ],
                          )));
                  debugPrint('delete button clicked');
                }
              }),])
        ),


    );
  }

   Future OpenDialog(int? idReclamtion,String reponse)=> showDialog(context: context, builder: (ctx)=>AlertDialog(
     title: Text("Response"),
     content: SingleChildScrollView(
         child: Form(
           child:Column(
               mainAxisSize: MainAxisSize.min,

               children: <Widget>[

                 SizedBox(height: 10,),
                 TextField(
                     controller: txtReponseCtrl,
                     decoration: InputDecoration(
                         border:OutlineInputBorder(
                             borderRadius: BorderRadius.circular(5)
                         ),
                         hintText: 'Entrez une reponse'
                     ))
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

         ReclamationService().updateReclamation(idReclamtion,reponse);
         getAllReclamationsByTypeProbleme();
         Navigator.of(ctx).pop(true);
       }, child:Text("Repondre"))
     ],
   )
   );
}
