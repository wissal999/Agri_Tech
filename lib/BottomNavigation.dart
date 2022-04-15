import 'package:agri_tech/Dashbord.dart';
import 'package:agri_tech/ListFarms.dart';
import 'package:flutter/material.dart';


class BottomNavigation extends StatefulWidget{

  @override
  State<StatefulWidget> createState()=>_BottomNavigationState() ;

}

class _BottomNavigationState extends State<BottomNavigation> with SingleTickerProviderStateMixin {
  int _selectedIndex=0;
  List<Widget> widgetsOptions=<Widget>[
    Dashbord(),
    ListFarms(),
    Text("profile")

];
  void onItemTap(int index){
    setState(() {
      _selectedIndex=index;
    });

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
       body:Center(
         child: widgetsOptions.elementAt(_selectedIndex),),
        bottomNavigationBar: BottomNavigationBar(
          items: const<BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon:Icon(Icons.home),
              label:"Tableau de bord",
            ),
            BottomNavigationBarItem(
              icon:Icon(Icons.list),
              label:"list",
            ),
            BottomNavigationBarItem(
              icon:Icon(Icons.person),
              label:"list",
            ),

          ],
          currentIndex: _selectedIndex,
          onTap: onItemTap,

        ),

    );





  }
}
