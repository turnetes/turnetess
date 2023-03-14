import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:turnetes/Datos/MaquinistasDatos.dart';
import 'package:turnetes/Modelos/ModeloMaquinista.dart';

import '../Modelos/ModeloAsignacion.dart';
import '../Vistas/AsignacionAcuerdoPersonalVista.dart';
import '../Vistas/AsignacionesCalendarioVista.dart';
import '../Datos/AsignacionesDatos.dart';
import 'NotificacionesControlador.dart';



class AsignacionesControlador {

  AsignacionesDatos asignacionesDatos = AsignacionesDatos();


  launchAsignacionesCalendarioVista(BuildContext context) async {
    Map<DateTime, dynamic> mapCalendarioAsignaciones = await asignacionesDatos.getMapCalendarioAsignaciones();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) =>
            AsignacionesCalendarioVista(mapCalendarioAsignaciones),
      ),
    );
  }

  launchAcuerdosPersonalesVista(BuildContext context,ModeloAsignacion asignacion,String idOtroMaquinista) async {
    MaquinistasDatos maquinistaDatos = MaquinistasDatos();
    ModeloMaquinista? maquinista = await maquinistaDatos.getMaquinista(idOtroMaquinista);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) =>
            AsignacionAcuerdoPersonalVista(asignacion,maquinista)
      ),
    );
  }


  eliminarAsignacionCalendario(BuildContext context,ModeloAsignacion asignacion) async{
    NotificacionesControlador notificacionesControlador = NotificacionesControlador();
    MaquinistasDatos maquinistasDatos = MaquinistasDatos();
    //await notificacionesControlador.sendNotificationEveryDevices(fechaSeleccionada,"PETICION DE TURNO");
    // Como no se hace el turno, le tengo que incrementar el contador del que pide
    maquinistasDatos.sumarTurnoMaquinista(asignacion.fechadiaTurno, asignacion.idMaquinistaPide);
    // tengo que decrementar el contador del que iba a hacer el turno pedido
    maquinistasDatos.restarTurnoMaquinista(asignacion.fechadiaTurno, asignacion.idMaquinistaRealizaTurno);
    // Borro de la lista de Asignaciones
    asignacionesDatos.deleteAsignacion(asignacion.idAsignacionTurno);
    //Informar al otro compañero con el que tenía pactado
    late String idMaquinistaRecibeMensaje;
    if(FirebaseAuth.instance.currentUser!.uid == asignacion.idMaquinistaRealizaTurno){
      idMaquinistaRecibeMensaje = asignacion.idMaquinistaPide;
    }
    else{
      idMaquinistaRecibeMensaje = asignacion.idMaquinistaPide;
    }
    String mensaje = "el turno del dia: "+ asignacion.fechadiaTurno.day. toString() +"/"+asignacion.fechadiaTurno.month.toString()+asignacion.fechadiaTurno.year.toString()+ " con clave: "+ asignacion.clave.toString()+ " ha sido ANULADO, consulta con tu compañero";
    notificacionesControlador.sendNotificationOneDevice(idMaquinistaRecibeMensaje,mensaje,"AVISO IMPORTANTE");
    showAviso(context,'CAMBIO ELIMINADO', 'El compañero ya ha sido avisado de que no se va a hacer el turno');
  }


  Future<ModeloMaquinista?> getMaquinista(String id) async{
    MaquinistasDatos maquinistasDatos = MaquinistasDatos();
    ModeloMaquinista? maquinista = await  maquinistasDatos.getMaquinista(id);
    return maquinista;
  }



  showAviso(BuildContext context,String title, String content){
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.purple,
              ),
              onPressed: () {
                launchAsignacionesCalendarioVista(context);
              },
              child: Text('OK'))
        ],
      ),
    );
  }
}