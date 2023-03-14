/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'AsignacionTurno.dart';

import 'misAcuerdosPrueba.dart';

import 'misPeticiones2.dart';


class LoadMapMisPeticiones extends StatelessWidget{

  Map<DateTime, dynamic> map = {};


  @override
  Widget build(BuildContext context) {

    return FutureBuilder<int?>(
      future: getEvents(),
      builder: (BuildContext context, AsyncSnapshot snapshot){
        if(snapshot.connectionState == ConnectionState.waiting)
          return Center(child: CircularProgressIndicator());    ///Splash Screen
        else
          return MisPeticiones2(map);       ///Main Screen
      },
    );
  }



  Future<int>? getEvents() async {
    var datosPeticiones = await FirebaseFirestore.instance.collection(
        "listaPeticiones").get();
    var datosOfrecimientos = await FirebaseFirestore.instance.collection(
        "listaOfrecimientos").get();
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    List<Turno> listaTurnos = [];
    if (datosPeticiones.size != 0) {
      print("ALGUNO CUMPLE@@@@@@@ ENTRA POR AQUIIIII!!!!");
      for (int i = 0; i < datosPeticiones.docs.length; i++) {
        Turno turno = Turno(
          datosPeticiones.docs[i].data()['clave'],
          datosPeticiones.docs[i].data()['fecha'].toDate(),
          datosPeticiones.docs[i].data()['grafico'],
          datosPeticiones.docs[i].data()['idMaquinistaCandidato'],
          datosPeticiones.docs[i].data()['idMaquinistaPide'],
          datosPeticiones.docs[i].data()['idTurno'],
        );
        print(turno.idTurno.toString());
        if (turno.idMaquinistaPide == uid) {
          print("ALGUNO CUMPLE@@@@@@@ ENTRA POR AQUIIIII2!!!!");
          print("ALGUNO CUMPLE@@@@@@@");
          if (turno.fecha.isAfter(DateTime.now())) {
            DateTime time = datosPeticiones.docs[i].data()['fecha'].toDate();
            DateTime time2 = DateTime(time.year, time.month, time.day);
            map[time2] = turno;
          }
          else {
            //tendre que borrar las peticiones en Firebase que se hayan pasado de fecha porque ya no me interesa guardarlas
            deleteTurnoPedidoPeticiones(turno.idTurno);
          }
        }
      }
    }
    if (datosOfrecimientos.size != 0) {
      for (int i = 0; i < datosOfrecimientos.docs.length; i++) {
        Turno turno = Turno(
          datosOfrecimientos.docs[i].data()['clave'],
          datosOfrecimientos.docs[i].data()['fecha'].toDate(),
          datosOfrecimientos.docs[i].data()['grafico'],
          datosOfrecimientos.docs[i].data()['idMaquinistaCandidato'],
          datosOfrecimientos.docs[i].data()['idMaquinistaPide'],
          datosOfrecimientos.docs[i].data()['idTurno'],
        );
        print("AHORA VAMOS CON LOS OFRECIMIENTOS");
        print(turno.idTurno.toString());
        print(uid!);
        if (turno.idMaquinistaCandidato == uid) {
          print("ALGUNO CUMPLE@@@@@@@");
          if (turno.fecha.isAfter(DateTime.now())) {
            DateTime time = datosOfrecimientos.docs[i].data()['fecha'].toDate();
            DateTime time2 = DateTime(time.year, time.month, time.day);
            map[time2] = turno;
          }
          else {
            //tendre que borrar las peticiones en Firebase que se hayan pasado de fecha porque ya no me interesa guardarlas
            deleteTurnoPedidoOfrecimientos(turno.idTurno);
          }
        }
      }
    }
    return map.length;
  }

  void deleteTurnoPedidoPeticiones(String idTurno){
    FirebaseFirestore.instance.collection("listaPeticiones").doc(idTurno).delete().then((_){
      print("TURNO BORRADO!!!");
    });
  }

  void deleteTurnoPedidoOfrecimientos(String idTurno){
    FirebaseFirestore.instance.collection("listaOfrecimientos").doc(idTurno).delete().then((_){
      print("TURNO BORRADO!!!");
    });
  }

}

 */