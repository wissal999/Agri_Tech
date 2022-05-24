

import 'package:agri_tech/ListCultures.dart';
import 'package:agri_tech/ListTypeProblemes.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'HeaderDrawer.dart';
import 'ListReclamationsAdministrator.dart';
import 'Login.dart';

class HomePageAdministrator extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePageAdministrator> {
  var currentPage = DrawerSections.Culture;

  void logout() async{
    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    sharedPreferences.remove('idUser');
    sharedPreferences.remove('email');
    sharedPreferences.remove('username');
    sharedPreferences.remove('password');
    sharedPreferences.remove('phoneNumber');
    Navigator.push(context,MaterialPageRoute(builder: (context)=> Login()));

  }
  @override
  Widget build(BuildContext context) {
    var container;
    var title;
    if (currentPage == DrawerSections.Culture) {
      container = ListCultures();
      title="Liste Cultures";
    }else  if (currentPage == DrawerSections.Reclamation) {
      container = ListReclamationsAdministrator();
      title="Liste Reclamations";
    }else  if (currentPage == DrawerSections.TypeProbleme) {
      container = ListTypesProblemes();
      title="Liste Type problemes";
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF22780F),
        title: Text(title),
      ),
      body: container,
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                HeaderDrawer(),
                MyDrawerList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget MyDrawerList() {
    return Container(
      padding: EdgeInsets.only(
        top: 20,
      ),
      child: Column(
        // shows the list of menu drawer
        children: [
          menuItem(1, "Gestion Cultures", Icons.dashboard_outlined,
              currentPage == DrawerSections.Culture? true : false),
          menuItem(2, "Gestion Reclamations", Icons.comment,
              currentPage == DrawerSections.Reclamation ? true : false),
          menuItem(3, "Gestion Types Problemes", Icons.list,
              currentPage == DrawerSections.Reclamation ? true : false),
          Divider(),
          menuItem(4, "Deconexion", Icons.logout,
              currentPage == DrawerSections.deconnexion? true : false),

        ],
      ),
    );
  }

  Widget menuItem(int id, String title, IconData icon, bool selected) {
    return Material(
      color: selected ? Colors.grey[100] : Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          setState(() {
            if (id == 1) {
              currentPage = DrawerSections.Culture;
            } else if (id == 2) {
              currentPage = DrawerSections.Reclamation;
            } else if (id == 3) {
              currentPage = DrawerSections.TypeProbleme;
            } else if (id == 4) {
              logout();
            }
          });
        },
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Row(
            children: [
              Expanded(
                child: Icon(
                  icon,
                  size: 20,
                  color: Colors.black,
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum DrawerSections {
  Culture,
  Reclamation,
  TypeProbleme,
  deconnexion
}