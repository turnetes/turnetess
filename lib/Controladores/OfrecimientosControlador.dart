import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:turnetes/Datos/OfrecimientosDatos.dart';
import '../Datos/AsignacionesDatos.dart';
import '../Datos/MaquinistasDatos.dart';
import '../Modelos/ModeloTurno.dart';
import 'NotificacionesControlador.dart';
import '../Vistas/OfrecimientoDiaVista.dart';
import '../Vistas/OfrecimientosVista.dart';



class OfrecimientosControlador{

  OfrecimientosDatos ofrecimientosDatos = OfrecimientosDatos();
  TextEditingController turnoController = TextEditingController();

  launchOfrecimientosVista(BuildContext context) async{
    List<ModeloTurno>? listaTurnos = await ofrecimientosDatos.pasarLista7();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => OfrecimientosVista(listaTurnos,context),
      ),
          (route) => false,
    );
  }

  launchOfrecerDiaVista(BuildContext context) async{
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => OfrecimientoDiaVista(this),
      ),
          (route) => false,
    );
  }



  //OfrecimientoDiaVista:
  Future<bool?> checkRestriccionesOfrecimientoDia(BuildContext context,DateTime fechaSeleccionada,String grafico) async {
    //Comprobamos que no tiene un ofrecimiento en la lista de ofrecimientos ya ese mismo dia
    bool restriccion1 = await ofrecimientosDatos.checkRestriccion1Json(fechaSeleccionada);
    if (restriccion1) {
      // SI TE CUBREN EL TURNO ESE DIA QUE ESTAS PIDIENDO TE ESTAS LIANDO DE DIA DE PETICION PORQUE YA TE LO CUBREN ESE DIA!
      AsignacionesDatos asignacionesDatos = AsignacionesDatos();
      print("VOY A VER SI GUARDO EL OFRECIMIENTO1!!!!" );
      bool restriccion2 = await asignacionesDatos.checkRestriccion2OfrecimientoDia(fechaSeleccionada);
      if (restriccion2) {
        //Guardo el ofrecimiento
        print("VOY A VER SI GUARDO EL OFRECIMIENTO2!!!!" );
        await ofrecimientosDatos.saveOfrecimientoFireBase(fechaSeleccionada, grafico);
        NotificacionesControlador notificacionesControlador = NotificacionesControlador();

        await notificacionesControlador.sendNotificationEveryDevices(fechaSeleccionada,"OFRECIMIENTO DE DIA");
        showAviso(context,"AVISO", "Ofrecimiento para trabajar registrado");
      }
      else {
        showAviso(context,"AVISO", "Ese dia ya cubres otro turno. Revisalo en area de Mis Acuerdos");
      }
    }
    else{
      showAviso(context,"AVISO", "Ya tienes registrada una ofrecimiento ese mismo dia");
    }
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
                launchOfrecimientosVista(context);
              },
              child: Text('OK'))
        ],
      ),
    );
  }

  //OfrecimientoConfirmacionVista : cuando elijo 1 ofrecimiento de OfrecimientosVista:
  checkRestriccionesOfrecimientoConfirmacion(BuildContext context,ModeloTurno turno,int clave) async {
    //primero comprobamos que el turno que voy a realizar de la lista de peticiones no es mio
    String? idPropio = await FirebaseAuth.instance.currentUser?.uid;
    if (idPropio == turno.idMaquinistaCandidato) {
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
        bool? noHayCandidato = await ofrecimientosDatos.getContinuaTurno(turno.idTurno);
        if (noHayCandidato!) {
          // todo correcto realiza turno
          print("NUMERO DE CLAVE INTRODUCIDA =" + clave.toString());
          print("idPropio =" + idPropio);
          await confirmarCambio(context,turno,idPropio,clave);
        }
        else {
          //showAlert5(context, "Ya hay otro maquinista que le cubre el turno");
          Navigator.of(context).pop(true);
        }
      }
    }
  }

  confirmarCambio(BuildContext context,ModeloTurno turnoPedido,String idPropio, int clave) async{

    AsignacionesDatos asignacionesDatos = AsignacionesDatos();
    MaquinistasDatos maquinistasDatos = MaquinistasDatos();
    //showAlert2("Confirmado que realizas el turno a tu compañero, revisa la info en tu area de Mis Acuerdos");
    //peticionConfirmacion.createState().showAlert3(context, "Confirmado que realizas el turno a tu compañero, revisa la info en tu area de Mis Acuerdos");
    //Creo obejto Asignación.
    asignacionesDatos.addAsignacionOfrecimiento(turnoPedido,clave);
    //Suma turno al maquinista que hace el turno
    maquinistasDatos.sumarTurnoMaquinista(turnoPedido.fecha,turnoPedido.idMaquinistaCandidato!);
    //Resta turno al maquinista que le hacen el turno
    maquinistasDatos.restarTurnoMaquinista(turnoPedido.fecha,idPropio);
    //Borrar objeto de la coleccion de peticiones puesto que lo saco de esa lista y lo paso a la listaAsignaciones.
    ofrecimientosDatos.deleteTurnoPedidoOfrecimientos(turnoPedido.idTurno);
    //Enviar notificacion al Maquinista que realiza el turno para que sepa que has confirmado
    NotificacionesControlador notificacionesControlador = NotificacionesControlador();
    String title = "AVISO IMPORTANTE SOBRE TU OFRECIMIENTO";
    String mensaje = "Realizas el turno:" + turnoPedido.clave.toString()+" para el día: "+turnoPedido.fecha.toString();
    await notificacionesControlador.sendNotificationOneDevice(turnoPedido.idMaquinistaCandidato!,mensaje,title);
    showAviso(context, 'CAMBIO CONFIRMADO', 'Revisa la informacion del cambio en tu area de acuerdos');
  }



}