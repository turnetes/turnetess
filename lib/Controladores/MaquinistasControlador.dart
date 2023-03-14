import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:turnetes/Vistas/MaquinistasListadoVista.dart';


import '../Vistas/MaquinistaPerfilVista.dart';
import '../Datos/MaquinistasDatos.dart';
import '../Modelos/ModeloMaquinista.dart';

class MaquinistasControlador{

  MaquinistasDatos maquinistasDatos = MaquinistasDatos();

  launchPerfil(BuildContext context) async{
    String? idMaquinista = FirebaseAuth.instance.currentUser?.uid;
    ModeloMaquinista? myMaquinista = await maquinistasDatos.getMaquinista(idMaquinista!);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => MaquinistaPerfilVista(myMaquinista!),
      ),
    );
  }

  launchListadoMaquinista(BuildContext context) async{
    List<ModeloMaquinista>? listaMaquinistas = await maquinistasDatos.getListaMaquinistas();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => MaquinistasListadoVista(listaMaquinistas!),
      ),
    );
  }




}