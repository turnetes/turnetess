import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:turnetes/Datos/MaquinistasDatos.dart';
import 'package:turnetes/Controladores/NotificacionesControlador.dart';
import '../Datos/AsignacionesDatos.dart';
import '../Modelos/ModeloTurno.dart';
import '../Vistas/PeticionDiaVista.dart';
import '../Datos/PeticionesDatos.dart';
import '../Vistas/PeticionesOfrecimientosCalendarioVista.dart';
import '../Vistas/PeticionesVista.dart';





class PeticionesControlador {

  static final PeticionesControlador _PeticionesControlador = PeticionesControlador
      ._internal();


  factory PeticionesControlador() {
    return _PeticionesControlador;
  }

  PeticionesControlador._internal();

  PeticionesDatos peticionesDatos = PeticionesDatos();

  launchPeticionesVista(BuildContext context) async {
    List<ModeloTurno>? listaTurnos = await peticionesDatos.pasarListaTurnos();
    print(listaTurnos![0].fecha.day.toString());
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) =>
            PeticionesVista(listaTurnos, context),
      ),

    );
  }





  //PETICIONCONFIRMACION: cuando elijo 1 peticion de peticionesVista:

  checkRestriccionesPeticionConfirmacion(BuildContext context,ModeloTurno turno) async {
    //primero comprobamos que el turno que voy a realizar de la lista de peticiones no es mio
    String? idPropio = await FirebaseAuth.instance.currentUser?.uid;
    if (idPropio == turno.idMaquinistaPide) {
      showAviso(context,"AVISO", "NO puedes realizar tu propio turno");
    }
    else {
      //Comprobamos que ese maquinista no realiza otro turno ya ese dia..
      AsignacionesDatos asignacionesDatos = AsignacionesDatos();
      bool? haceTurno = await asignacionesDatos.getCandidatoHaciaYaTurnoEseDiaPeticionConfirmacion(turno, idPropio!);
        //cubre otro turno el mismo maquinisita que esta pididendo salta showAlert
      if(haceTurno!){
        showAviso(context,"AVISO", "Ese dia ya realizas otro turno, revisalo en tu area de MisAcuerdos");
      }
      else {
        //hemos comprbado que no cubre ningun turno a nadie ese dia vamos a ver que otro haya sido mas rapido y ya haya hecho la peticion
        bool? noHayCandidato = await peticionesDatos.getContinuaTurno(turno.idTurno);
        if (noHayCandidato!) {
          // todo correcto realiza turno
          await confirmarCambio(context,turno,idPropio);
        }
        else {
          //showAlert5(context, "Ya hay otro maquinista que le cubre el turno");
          Navigator.of(context).pop(true);
        }
      }
    }
  }

  confirmarCambio(BuildContext context,ModeloTurno turnoPedido,String idPropio) async{

    AsignacionesDatos asignacionesDatos = AsignacionesDatos();
    MaquinistasDatos maquinistasDatos = MaquinistasDatos();
    //showAlert2("Confirmado que realizas el turno a tu compañero, revisa la info en tu area de Mis Acuerdos");
    //peticionConfirmacion.createState().showAlert3(context, "Confirmado que realizas el turno a tu compañero, revisa la info en tu area de Mis Acuerdos");
    //Creo obejto Asignación.
    asignacionesDatos.addAsignacionPeticion(turnoPedido);
    //Suma turno al maquinista que hace el turno
    maquinistasDatos.sumarTurnoMaquinista(turnoPedido.fecha,idPropio);
    //Resta turno al maquinista que le hacen el turno
    maquinistasDatos.restarTurnoMaquinista(turnoPedido.fecha,turnoPedido.idMaquinistaPide!);
    //Borrar objeto de la coleccion de peticiones puesto que lo saco de esa lista y lo paso a la listaAsignaciones.
    peticionesDatos.deleteTurnoPedidoPeticiones(turnoPedido.idTurno);
    //Enviar notificacion al Maquinista que realiza el turno para que sepa que has confirmado
    NotificacionesControlador notificacionesControlador = NotificacionesControlador();
    String title = "BUENAS NOTICIAS";
    String mensaje = "Te cubren el turno:" + turnoPedido.clave.toString()+" para el día: "+turnoPedido.fecha.toString();
    await notificacionesControlador.sendNotificationOneDevice(turnoPedido.idMaquinistaPide!,mensaje,title);
    showAviso(context, 'CAMBIO CONFIRMADO', 'Revisa la informacion del cambio en tu area de acuerdos');
    //Una vez completado vuelvo a la lista de Peticiones y no deberia de estar el turno que se ha solicitado trabajar
    //launchPeticionesVista(context);
    /*
    Future.delayed(Duration(seconds: 5), () {
      Navigator.push(context, MaterialPageRoute(builder: (_) => launchPeticionesVista(context)));
    });

     */

  }

  showAviso(BuildContext context, String title, String content){
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
                launchPeticionesVista(context);
              },
              child: Text('OK'))
        ],
      ),
    );
  }









  //CALENDARIO MIS PETICIONES/OFRECIMIENTOS:
  launchPeticionesOfrecimientosCalendarioVista(BuildContext context) async {
    Map<DateTime, dynamic> mapaEventosCalendario = await peticionesDatos.getMapCalendarioPeticiones();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) =>
            PeticionesOfrecimientosCalendarioVista(mapaEventosCalendario),
      ),
    );

  }


  //PETICIONDIAVISTA:

  launchPedirDiaVista(BuildContext context) async {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => PeticionDiaVista(this),
      ),
          (route) => false,
    );
  }

  Future<bool?> checkRestriccionesPedirDia(BuildContext context, PeticionDiaVista diaVista,DateTime fechaSeleccionada,int turnoElegido) async {
    //Comprobamos que no tiene una peticion en la lista de peticiones ya ese mismo dia
    bool restriccion1 = await peticionesDatos.checkRestriccion1Json(fechaSeleccionada);
    if (restriccion1) {
      // SI TE CUBREN EL TURNO ESE DIA QUE ESTAS PIDIENDO TE ESTAS LIANDO DE DIA DE PETICION PORQUE YA TE LO CUBREN ESE DIA!
      AsignacionesDatos asignacionesDatos = AsignacionesDatos();
      bool restriccion2 = await asignacionesDatos.checkRestriccion2PeticionDia(fechaSeleccionada);
      if (restriccion2) {
        //Guardo la peticion
        //await diaVista.createState().showAlertResumenPeticionDia(context,turnoElegido,fechaSeleccionada);
        await peticionesDatos.guardarPeticion(fechaSeleccionada, turnoElegido);
        NotificacionesControlador notificacionesControlador = NotificacionesControlador();
        await notificacionesControlador.sendNotificationEveryDevices(fechaSeleccionada,"PETICION DE TURNO");
        showAviso(context, "AVISO", "Peticion de turno registrada");
      }
      else{
        //ShowAlert
        launchPeticionesVista(context);
        diaVista.createState().showAlert(context, "Imposible realizarla, El usuario ya ha realizado una peticion ese dia");
        Timer(Duration(seconds: 2),Navigator.of(context).pop);
      }
    }
    else{
      await launchPeticionesVista(context);
      diaVista.createState().showAlert(context, "ERROR, ya has realizado una petición ese día");
      Timer(Duration(seconds: 2),Navigator.of(context).pop);
    }
  }

  guardarPeticion(BuildContext context,DateTime fecha, int turnoElegido) async {
    await peticionesDatos.guardarPeticion(fecha, turnoElegido);
    await launchPeticionesVista(context);
  }

  showAlert2(String mensaje){
    return AlertDialog(
      title: Text('AVISO'),
      content: new Text(mensaje),
    );
  }

}


