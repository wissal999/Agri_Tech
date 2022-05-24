import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'Models/Culture.dart';


class UpdateParcel extends StatefulWidget{
  final List listParcels;
  final int index;
  final List<Culture> listCultres;

  const UpdateParcel( this.listParcels, this.index,this.listCultres);
  @override
  State<StatefulWidget> createState()=>_UpdateParcelState() ;

}

class _UpdateParcelState extends State<UpdateParcel> with SingleTickerProviderStateMixin {
int CurrentStep=0;
Culture?  cultre;
 Culture? SelectedCulture;
late int SelectedIdCulture;
late TextEditingController txtLibelleParcel,txtSurfaceParcel,txtTotalImplantation,txtTmpIdealeParcel,txtHumIdealeParcel, txtHumSolIdealeParcel;
void updateParcel(int idParcel,int idCulture) async{
  final uri=Uri.parse("http://192.168.43.130:8080/updateParcelle/$idParcel/$idCulture");

  Map data = {
    'nom': txtLibelleParcel.text,
    'surface':txtSurfaceParcel.text,
    'totaleImplantation':txtTotalImplantation.text,
    'temperatureIdeale':txtTmpIdealeParcel.text,
    'humiditeIdeale':txtHumIdealeParcel.text,
    'humidite_solIdeale':txtHumSolIdealeParcel.text
  };
  //encode Map to JSON
  var body = json.encode(data);
  var response = await http.put(uri,
      headers: {"Content-Type": "application/json"},
      body: body
  );
  print("${response.statusCode}");
  print("${response.body}");


}

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    txtLibelleParcel=new TextEditingController();
    txtSurfaceParcel=new TextEditingController();
    txtTotalImplantation=new TextEditingController();
    txtTmpIdealeParcel=new TextEditingController();
    txtHumIdealeParcel=new TextEditingController();
    txtHumSolIdealeParcel=new TextEditingController();
    if(widget.index!=null){
      txtLibelleParcel.text=widget.listParcels[widget.index].nom;
      txtSurfaceParcel.text=widget.listParcels[widget.index].surface.toString();
      txtTotalImplantation.text=widget.listParcels[widget.index].totaleImplantation.toString();
      txtTmpIdealeParcel.text=widget.listParcels[widget.index].temperatureIdeale.toString();
      txtHumIdealeParcel.text=widget.listParcels[widget.index].humiditeIdeale.toString();
      txtHumSolIdealeParcel.text=widget.listParcels[widget.index].humidite_solIdeale.toString();
      String nom=widget.listParcels[widget.index].nomCulture.toString();
      SelectedCulture?.nomCulture=nom;
      cultre=new Culture(1, nom,0,0,0);
      SelectedCulture?.id=widget.listParcels[widget.index].id;
      SelectedIdCulture=widget.listParcels[widget.index].id;
      print(SelectedCulture?.nomCulture.toString());

        for (var i = 0; i < widget.listCultres.length; i++){
          if(widget.listCultres[i].nomCulture==widget.listParcels[widget.index].nomCulture)
          SelectedCulture=widget.listCultres[i];
      }


    }
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
        title: Text("Update Parcel"),
          backgroundColor: Color(0xFF22780F),
    ),
    body:Theme(
      data: Theme.of(context).copyWith(colorScheme: ColorScheme.light(primary:Color(0xFF22780F))),
    child:Stepper(
      type: StepperType.horizontal,
      steps: getSteps(),
      currentStep: CurrentStep,
      onStepContinue: (){
        final isLastStep =CurrentStep==getSteps().length-1;
        if(isLastStep){
          updateParcel(widget.listParcels[widget.index].id,SelectedIdCulture);
          Navigator.pop(context);
          print("completed");
        }else{
          setState(() {
            CurrentStep+=1;
          });
        }

      },
      onStepTapped: (step)=> setState(() {
        CurrentStep=step;
      }),
      onStepCancel: CurrentStep==0 ? null:()=> setState(() {
          CurrentStep-=1;
        }),
      controlsBuilder: (BuildContext context, ControlsDetails controls){
        final isLastStep =CurrentStep==getSteps().length-1;
        return Container(


            child:Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[


                if(CurrentStep!=0)
                Expanded(
                    child: ElevatedButton(
                      onPressed: controls.onStepCancel,
                      child: Text("Back"),
                    )),
                if(CurrentStep!=0)
                  SizedBox(width: 15,),

                Expanded(
                    child: ElevatedButton(
                      onPressed:controls.onStepContinue,
                      child: Text(isLastStep?"Confirm":"Next"),
                    )),

              ],
            )
        );

      },

    )
    )
    );






  }
  List<Step> getSteps()=>[
    Step(
      state: CurrentStep>0?StepState.complete:StepState.indexed,
      title: Text("Parcel"),isActive: CurrentStep>=0,
    content:Column(
        mainAxisSize: MainAxisSize.min,

        children: <Widget>[
          TextField(

              controller: txtLibelleParcel,
              decoration: InputDecoration(
                  border:OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5)
                  ),
                  labelText: 'libelle parcelle'


              )
          ),
          SizedBox(height: 10,),

          DropdownButtonFormField<Culture>(
              isExpanded: true,
              hint: Text("Selectionner une culture"),
              value:SelectedCulture,
              items: widget.listCultres.map((Culture culture){
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
                  labelText: 'Surface'
              )),
          SizedBox(height: 10,),
          TextField(
              controller: txtTotalImplantation,
              decoration: InputDecoration(
                  border:OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5)
                  ),
                  labelText: 'Total implantation'
              ))
        ]
    ),),
    Step(
      state: CurrentStep>1?StepState.complete:StepState.indexed,
      title: Text("Culture"),isActive: CurrentStep>=1, content:Column(
        mainAxisSize: MainAxisSize.min,

        children: <Widget>[
          TextField(
              controller:txtTmpIdealeParcel ,
              decoration: InputDecoration(
                  border:OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5)
                  ),
                  labelText: 'Temperature ideale'

              )
          ),

          SizedBox(height: 10,),
          TextField(
              controller: txtHumIdealeParcel,
              decoration: InputDecoration(
                  border:OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5)
                  ),
                  labelText: 'Humidite ideale'
              )),
          SizedBox(height: 10,),
          TextField(
              controller: txtHumSolIdealeParcel,
              decoration: InputDecoration(
                  border:OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5)
                  ),
                  labelText: 'Humidite du sol ideale'
              ))
        ]
    ),),
    Step(
        state: CurrentStep>2?StepState.complete:StepState.indexed,
        title: Text("Validation"),isActive: CurrentStep>=2, content:Container(

        child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[

              RichText(
                softWrap:true,
                textDirection: TextDirection.ltr,
                textAlign: TextAlign.left,
              text: TextSpan(
              // Note: Styles for TextSpans must be explicitly defined.
              // Child text spans will inherit styles from parent
              style: const TextStyle(
              fontSize: 14.0,
              color: Colors.black,

              ),

              children: <TextSpan>[
              TextSpan(text: 'Libelle Parcelle :  ', style: const TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: txtLibelleParcel.text),
              ],
              ),
              ),
          RichText(
            softWrap:true,
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.right,
            text: TextSpan(
              // Note: Styles for TextSpans must be explicitly defined.
              // Child text spans will inherit styles from parent
              style: const TextStyle(
                fontSize: 14.0,
                color: Colors.black,
              ),
              children: <TextSpan>[
                TextSpan(text: 'Surface Parcelle :  ', style: const TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: txtSurfaceParcel.text),
              ],
            ),
          ),
            RichText(
              text: TextSpan(
                // Note: Styles for TextSpans must be explicitly defined.
                // Child text spans will inherit styles from parent
                style: const TextStyle(
                  fontSize: 14.0,
                  color: Colors.black,
                ),
                children: <TextSpan>[
                  TextSpan(text: 'Total implantation :  ', style: const TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: txtTotalImplantation.text),
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                // Note: Styles for TextSpans must be explicitly defined.
                // Child text spans will inherit styles from parent
                style: const TextStyle(
                  fontSize: 14.0,
                  color: Colors.black,
                ),
                children: <TextSpan>[
                  TextSpan(text: 'Temperature ideale :  ', style: const TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: txtTmpIdealeParcel.text),
                ],
              ),
            ),
          RichText(
            text: TextSpan(
              // Note: Styles for TextSpans must be explicitly defined.
              // Child text spans will inherit styles from parent
              style: const TextStyle(
                fontSize: 14.0,
                color: Colors.black,
              ),
              children: <TextSpan>[
                TextSpan(text: 'Humidite ideale :  ', style: const TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: txtHumIdealeParcel.text),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              // Note: Styles for TextSpans must be explicitly defined.
              // Child text spans will inherit styles from parent
              style: const TextStyle(
                fontSize: 14.0,
                color: Colors.black,
              ),
              children: <TextSpan>[
                TextSpan(text: 'Humidite du Sol ideale :  ', style: const TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: txtHumSolIdealeParcel.text),
              ],
            ),
          ),
        ])),
    )];
}
