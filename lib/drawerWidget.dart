import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:turnetes/Controladores/LoginControl.dart';
import 'package:turnetes/Controladores/OfrecimientosControlador.dart';
import 'package:turnetes/Controladores/PeticionesControlador.dart';
import 'Controladores/AsignacionesControlador.dart';
import 'Controladores/MaquinistasControlador.dart';
import 'listadoMaquinistas3.dart';
import 'loadMapMisAcuerdos.dart';





class DrawerWidget extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    PeticionesControlador peticionesControlador = PeticionesControlador();
    OfrecimientosControlador ofrecimientosControlador = OfrecimientosControlador();
    MaquinistasControlador maquinistasControlador = MaquinistasControlador();
    AsignacionesControlador asignacionesControlador = AsignacionesControlador();
    LoginControl loginControl = LoginControl(context);

    return Drawer(
      backgroundColor: Colors.purple,
      child: ListView(
        children: <Widget>[
          ListTile(
              title: Text("Peticiones", style: TextStyle(fontSize: 30.0, color: Colors.white)),
              leading: Icon(Icons.arrow_forward), iconColor: Colors.white,
              onTap: (){
                peticionesControlador.launchPeticionesVista(context);
              }
          ),
          ListTile(
              title: Text("Pedir día", style: TextStyle(fontSize: 30.0, color: Colors.white)),
              leading: Icon(Icons.arrow_forward), iconColor: Colors.white,
              onTap: (){
                peticionesControlador.launchPedirDiaVista(context);
              }
          ),
          ListTile(
              title: Text("Perfil", style: TextStyle(fontSize: 30.0, color: Colors.white)),
              leading: Icon(Icons.arrow_forward), iconColor: Colors.white,
              onTap: (){
                maquinistasControlador.launchPerfil(context);
              }
          ),
          ListTile(
              title: Text("Mis peticiones", style: TextStyle(fontSize: 30.0, color: Colors.white)),
              leading: Icon(Icons.arrow_forward), iconColor: Colors.white,
              onTap: (){
                peticionesControlador.launchPeticionesOfrecimientosCalendarioVista(context);
              }
          ),

          ListTile(
              title: Text("Mis acuerdos", style: TextStyle(fontSize: 30.0, color: Colors.white)),
              leading: Icon(Icons.arrow_forward), iconColor: Colors.white,
              onTap: (){
                asignacionesControlador.launchAsignacionesCalendarioVista(context);
              }

          ),
          ListTile(
              title: Text("Listado de compañeros", style: TextStyle(fontSize: 30.0, color: Colors.white)),
              leading: Icon(Icons.arrow_forward), iconColor: Colors.white,
              onTap: (){
                maquinistasControlador.launchListadoMaquinista(context);
              }
          ),
          ListTile(
              title: Text("Ofrecer día", style: TextStyle(fontSize: 30.0, color: Colors.white)),
              leading: Icon(Icons.arrow_forward), iconColor: Colors.white,
              onTap: (){
                ofrecimientosControlador.launchOfrecerDiaVista(context);
              }
          ),
          ListTile(
              title: Text("Ofrecimientos", style: TextStyle(fontSize: 30.0, color: Colors.white)),
              leading: Icon(Icons.arrow_forward), iconColor: Colors.white,
              onTap: (){
                ofrecimientosControlador.launchOfrecimientosVista(context);
              }
          ),
        ],
      ),
    );
  }

}

