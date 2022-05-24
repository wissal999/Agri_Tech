import 'dart:convert';
import 'package:agri_tech/ListFarms.dart';
import 'package:agri_tech/Models/Culture.dart';
import 'package:agri_tech/Services/CultureService.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'ListCultures.dart';




class AddCulture extends StatefulWidget{
  final Culture? culture;
  const AddCulture(this.culture);
  @override
  State<StatefulWidget> createState()=>_AddCultureState() ;

}

class _AddCultureState extends State<AddCulture> with SingleTickerProviderStateMixin {
  late TextEditingController txtLibelleCultureCtrl,txtTemperatureIdealeCtrl,txtHumiditeIdealeCtrl,txtHumiditeSolIdealeCtrl;
  Future<Culture> addCulture() async {
    Culture culture=Culture( null, txtLibelleCultureCtrl.text, double.parse(txtTemperatureIdealeCtrl.text), double.parse(txtHumiditeIdealeCtrl.text), double.parse(txtHumiditeSolIdealeCtrl.text));
    Culture addCulture=await CultureService().addCulture(culture);
    Navigator.push(context, MaterialPageRoute(builder: (context) => ListCultures() ));
    setState(() {

    });
    return addCulture;
  }

  Future<Culture> updateCulture() async {
    Culture culture=Culture( null, txtLibelleCultureCtrl.text, double.parse(txtTemperatureIdealeCtrl.text), double.parse(txtHumiditeIdealeCtrl.text), double.parse(txtHumiditeSolIdealeCtrl.text));
    Culture updateCulture=await CultureService().updateCulture(culture,widget.culture!.id!);
    Navigator.push(context, MaterialPageRoute(builder: (context) => ListCultures() ));
    setState(() {

    });
    return updateCulture;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    txtLibelleCultureCtrl=new TextEditingController();
    txtTemperatureIdealeCtrl=new TextEditingController();
    txtHumiditeIdealeCtrl=new TextEditingController();
    txtHumiditeSolIdealeCtrl=new TextEditingController();
    if(widget.culture !=null) {
      txtLibelleCultureCtrl.text=widget.culture!.nomCulture;
      txtTemperatureIdealeCtrl.text=widget.culture!.temperatureIdeale.toString();
      txtHumiditeIdealeCtrl.text=widget.culture!.humiditeIdeale.toString();
      txtHumiditeSolIdealeCtrl.text=widget.culture!.humiditeSolIdeale.toString();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF22780F),
        ),

        body:SingleChildScrollView(
            child: Padding( padding: EdgeInsets.only(left: 30,right: 30),
              child:Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(height: 70,),
                  Center(child:  Text(widget.culture ==null?"Ajout Culture":"Modification Culture",style:TextStyle(fontSize: 30),),),
                  SizedBox(height: 20,),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: txtLibelleCultureCtrl,
                    decoration: InputDecoration(
                      border:OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5)
                      ),
                      hintText: 'Nom du ferme',
                      isDense: true,                      // Added this
                      contentPadding: EdgeInsets.all(10),
                    ),
                    validator: MultiValidator(
                        [
                          RequiredValidator(errorText: 'Champs Obligatoire*')
                        ]
                    ),
                  ),
                  SizedBox(height: 20,),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: txtTemperatureIdealeCtrl,
                    decoration: InputDecoration(
                      border:OutlineInputBorder(

                          borderRadius: BorderRadius.circular(5)
                      ),
                      hintText: 'Lieu',
                      isDense: true,                      // Added this
                      contentPadding: EdgeInsets.all(10),
                    ),
                    validator: MultiValidator(
                        [

                          PatternValidator(r'^[0-9]*$', errorText: "Champ numérique "),
                          RequiredValidator(errorText: 'Champ Obligatoire*')
                        ]
                    ),
                  ),
                  SizedBox(height: 20,),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller:  txtHumiditeIdealeCtrl,
                    decoration: InputDecoration(
                      border:OutlineInputBorder(

                          borderRadius: BorderRadius.circular(5)
                      ),
                      hintText: 'Lieu',
                      isDense: true,                      // Added this
                      contentPadding: EdgeInsets.all(10),
                    ),
                    validator: MultiValidator(
                        [

                          PatternValidator(r'^[0-9]*$', errorText: "Champ numérique "),
                          RequiredValidator(errorText: 'Champ Obligatoire*')
                        ]
                    ),
                  ),
                  SizedBox(height: 20,),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller:  txtHumiditeSolIdealeCtrl,
                    decoration: InputDecoration(
                      border:OutlineInputBorder(

                          borderRadius: BorderRadius.circular(5)
                      ),
                      hintText: 'Lieu',
                      isDense: true,                      // Added this
                      contentPadding: EdgeInsets.all(10),
                    ),
                    validator: MultiValidator(
                        [

                          PatternValidator(r'^[0-9]*$', errorText: "Champ numérique "),
                          RequiredValidator(errorText: 'Champ Obligatoire*')
                        ]
                    ),
                  ),

                  SizedBox(height: 20,),
                  MaterialButton(onPressed: () {
                  if(widget.culture !=null) {
                  addCulture();
                  }
                  else{
                    updateCulture();
                  }
                  },
                      child:
                      Container(
                        width: 150,
                        height: 45,
                        decoration: BoxDecoration(
                          color: Color(0xFF22780F),
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          widget.culture ==null?"Ajouter":"Modifier",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                  )
                ],
              ),)));






  }
}
