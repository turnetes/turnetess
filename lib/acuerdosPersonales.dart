
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:turnetes/Modelos/ModeloAsignacion.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'dart:math';
import 'dart:io' as IO;


import 'Modelos/ModeloMaquinista.dart';

class AcuerdosPersonales extends StatefulWidget{

  ModeloAsignacion asignacion;

  AcuerdosPersonales(this.asignacion);
  _AcuerdosPersonales createState() => _AcuerdosPersonales(asignacion);

}

class _AcuerdosPersonales extends State<AcuerdosPersonales>{

  final ModeloAsignacion asignacion;
  _AcuerdosPersonales(this.asignacion);

  @override
  Widget build(BuildContext context) {
    print("USUARIO ACTUAL CLAVE=" + FirebaseAuth.instance.currentUser.toString());
    print("ASIGNACION MAQUINISTA PIDE =" + asignacion.idMaquinistaPide);

    return Scaffold(
      appBar: AppBar(
          title: (FirebaseAuth.instance.currentUser?.uid == asignacion.idMaquinistaPide) ? Text("Te hacen el turno...") : Text("Le haces el turno..."),
          backgroundColor: Colors.purple,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: (){
              Navigator.of(context).pop();
            },
          )
      ),
      body: FutureBuilder<ModeloMaquinista?>(
          future: getOtroMaquinistaDelCambio(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    child: InputDecorator(
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12.0)),
                            borderSide: BorderSide(color: Colors.purple, width: 5),
                          ),
                          labelText: 'Número de turno:',
                        ),
                        child: Text(asignacion.clave.toString(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
                    ),
                  ),
                  Container(
                    child: InputDecorator(
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          borderSide: BorderSide(color: Colors.purple, width: 5),
                        ),
                        labelText: 'Dia del turno:',
                      ),
                      child: TableCalendar(locale: 'es_ES',selectedDayPredicate: (day) =>isSameDay(day, asignacion.fechadiaTurno),focusedDay: asignacion.fechadiaTurno, firstDay: DateTime.now(), lastDay: DateTime(2025), startingDayOfWeek: StartingDayOfWeek.monday,
                        calendarFormat: CalendarFormat.week,
                        headerStyle: HeaderStyle(titleCentered: true, formatButtonVisible: false, decoration: BoxDecoration(color: Colors.white10)),
                        calendarStyle: const CalendarStyle( weekendTextStyle: TextStyle(color: Colors.red),// Weekend dates color (Sat & Sun Column)
                        ),
                        calendarBuilders: CalendarBuilders(
                          selectedBuilder: (context, date, events) => Container(
                              margin: const EdgeInsets.all(4.0),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.purple,
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: Text(
                                date.day.toString(),
                                style: TextStyle(color: Colors.white),
                              )),
                          holidayBuilder:  (context, date, events) => Container(
                            margin: const EdgeInsets.all(4.0),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(10.0)),
                            child: Text(
                              date.day.toString(),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  Container(
                    child: InputDecorator(
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          borderSide: BorderSide(color: Colors.purple, width: 5),
                        ),
                        labelText: 'Info del maquinista:',
                      ),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Nombre:" , style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                SizedBox(height: 4,),
                                Text(snapshot.data!.nombre, style: TextStyle(fontSize: 15)),
                                SizedBox(height: 16,),

                                Text("Apodo:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                SizedBox(height: 4,),
                                Text(snapshot.data!.apodo, style: TextStyle(fontSize: 15)),
                                SizedBox(height: 16,),

                                Text("Teléfono interior:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                SizedBox(height: 4,),
                                Text(snapshot.data!.telefonoInt, style: TextStyle(fontSize: 15)),
                                SizedBox(height: 16,),
                                Text("Teléfono exterior:", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                SizedBox(height: 4,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(snapshot.data!.telefonoExt + "       ", style: TextStyle(fontSize: 20)),
                                    SizedBox(height: 16),
                                    IconButton(
                                      onPressed: () async{
                                        String url;
                                        var prefijo = "34";
                                        var phone = prefijo+snapshot.data!.telefonoExt;
                                        var message = "Hola compañero soy " + snapshot.data!.apodo+".......";
                                        if (IO.Platform.isIOS) {
                                          //url = "whatsapp://wa.me/$phone/?text=${Uri.encodeFull(message)}";
                                          //url = "whatsapp://wa.me/$phone/?text=${Uri.parse(message)}";
                                          //url = "whatsapp://send?phone=" + phone.replaceAll(' ', '');
                                          //url = "https://wa.me/15551234567";
                                          url = "https://wa.me/$phone/?text=${Uri.parse(message)}";
                                        } else {
                                          url = "whatsapp://send?phone=$phone&text=${Uri.encodeFull(message)}";
                                        }
                                        abrirNavegador(url);},
                                      icon: Icon(Icons.whatsapp_rounded, color: Colors.green, size: 40),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text("Foto de perfil:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                SizedBox(height: 4,),
                                Container(
                                  width: 150,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: elegirImagen(snapshot.data!.imagePath),
                                  ),
                                )
                              ],
                            )
                          ]
                      ),
                    ),
                  ),

                  ElevatedButton(
                      child: Text('Eliminar acuerdo'),
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder()),
                        padding: MaterialStateProperty.all(EdgeInsets.all(20)),
                        backgroundColor: MaterialStateProperty.all(Colors.red), // <-- Button color
                        overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
                          if (states.contains(MaterialState.pressed)) return Colors.purple; // <-- Splash color
                        }),
                      ),
                      onPressed: (){
                        showDialog<String>(
                            context: context,
                            builder: (BuildContext context) =>
                                AlertDialog(
                                    title: const Text(
                                        'Confirmar Eliminación de cambio'),
                                    content: const Text(
                                        'Al final no se realiza el turno. Estas compeltamente seguro?'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, 'Cancel'),
                                        child: const Text('Cancel'),
                                      ),

                                      TextButton(
                                          child: const Text('OK1'),
                                          onPressed: () async {
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                            // Como no se hace el turno, le tengo que incrementar el contador del que pide
                                            modificarContadorMaquinista(asignacion.idMaquinistaPide, 1);
                                            // tengo que decrementar el contador del que iba a hacer el turno pedido
                                            modificarContadorMaquinista(asignacion.idMaquinistaRealizaTurno, -1);
                                            // Borro de la lista de Asignaciones
                                            deleteAsignacionTurno(asignacion.idAsignacionTurno);
                                            //Informar al otro compañero con el que tenía pactado
                                            Future<String?> idBuscamos = getOneSignalIDMaquinista(asignacion);
                                            String? oneSignalID = await idBuscamos;
                                            List<String> listaToken = [];
                                            listaToken.add(oneSignalID!);
                                            String texto = " el cambio del dia: " + asignacion.fechaAceptacion.day.toString() +"/" + asignacion.fechaAceptacion.month.toString() + "queda anulado.";
                                            sendNotification(listaToken, texto, "AVISO IMPORTANTE",4);

                                          }

                                      ),


                                    ]
                                )
                        );


                      }

                  ),
                ],
              );
            };

            return const Center(child: CircularProgressIndicator());
          }),
    );
  }

  Future<ModeloMaquinista?> getOtroMaquinistaDelCambio() async {
    ModeloMaquinista? maquinista;
    String idOtroMaquinista;
    if(FirebaseAuth.instance.currentUser?.uid == asignacion.idMaquinistaRealizaTurno){
      print("ENTRA POR AQUI!!!!!!!!!!!!!!!!!!!!!!!!!!!");
      idOtroMaquinista = asignacion.idMaquinistaPide;
      print("ESTE ID:" + idOtroMaquinista);
    }
    else{
      idOtroMaquinista =  asignacion.idMaquinistaRealizaTurno;
    }
    await FirebaseFirestore.instance.collection("maquinistas").doc(idOtroMaquinista)
        .get()
        .then((value) {
      maquinista = new ModeloMaquinista( value.data()!["apodo"].toString(),
        value.data()!["contadorFestivos"] as int,
        value.data()!["contadorTurnos"] as int,
        value.data()!["correo"].toString(),
        value.data()!["idMaquinista"].toString(),
        value.data()!["imagePath"],
        value.data()!["nombre"].toString(),
        value.data()!["oneSignalID"].toString(),
        value.data()!["passAdmin"] as bool,
        value.data()!["telfExt"].toString(),
        value.data()!["telfInt"].toString(),

      );
    });
    return maquinista ;
  }

  DecorationImage elegirImagen(String url){
    if(url == ""){
      return DecorationImage(  image: AssetImage('assets/anonimo.jpg'));
    }
    else{
      return DecorationImage(image: NetworkImage(url));
    }
  }



  showAlert2(BuildContext context, String text) {
    showDialog(
      context: context,
      builder: (context) {
        Future.delayed(
          Duration(seconds: 10),
              () {

          },
        );

        return AlertDialog(
            title: Text('AVISO'),
            content: new Text(text),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK')),
            ]
        );
      },
    );
  }

/*
  void deleteAsignacion(String idTurno){
    FirebaseFirestore.instance.collection("turnos").doc(idTurno).delete().then((_){
      print("TURNO BORRADO!!!");


    });
  }

 */

  void sumarTurnoMaquinista(String idMaquinistaPedia){

    //FirebaseFirestore.instance.collection("maquinistas").where("idMaquinista", isEqualTo: uid).snapshots().listen((result) {
    FirebaseFirestore.instance.collection("maquinistas").doc(idMaquinistaPedia).update({
      "contadorTurnos" : FieldValue.increment(1)});
  }

  void restarTurnoMaquinista(String idMaquinistaRealizaba){
    FirebaseFirestore.instance.collection("maquinistas").doc(idMaquinistaRealizaba).update({
      "contadorTurnos" : FieldValue.increment(-1)});
  }



//TOKEN cmoreno: d742IY1xT56ohyASiTYdPA:APA91bEnXqxI2GZLZ7QwczcJERm4sbx22i_S65fEB6vZeWovCLuzWodut4LnWMzgchMyuaWv-3aDeIGH6wWVIlg1bVIuWYms9jYkwDp3zA8zSpl38wYKE_-6UqpnvyYYmAHv-KpMoLw4



  Future<void> abrirNavegador(String url) async{

    if( await canLaunchUrlString(url)){
      await launchUrlString(url);
    }

  }

  String url() {
    var phone = "34622700281";
    var message = " hola Silvia";
    if (IO.Platform.isIOS) {
      return "whatsapp://wa.me/$phone/?text=${Uri.encodeFull(message)}";
    } else {
      return "whatsapp://send?phone=$phone&text=${Uri.encodeFull(message)}";
    }
  }


  void _launchUrl() async {
    String _url = ('api.whatsapp.com/send?phone=34622985647');
    var url = ('https://api.whatsapp.com/send?phone=34622985647');
    await launchUrlString('https://'+ _url);
  }

  void launchURL({required String webSite})async{
    //var url = ('https://api.whatsapp.com/send?phone=34622985647');
    if (await canLaunch(webSite)) {
      await launchUrlString(
        webSite,
      );
    } else if (await canLaunchUrlString('https://'+webSite)) {
      await launchUrlString(
        'https://'+webSite
        ,
      );
    } else{
      throw 'Could not launch';
    }
  }

  Future<String?> getOneSignalIDMaquinista(ModeloAsignacion asignacion) async {
    String? id = await FirebaseAuth.instance.currentUser?.uid;
    late String? idMaquinistaBuscado;
    late String? oneSignalID;
    if (asignacion.idMaquinistaPide == id) {
      //buscamos el id del maquinista con el que cambiaba para avisarle de la anulacion del cambio
      idMaquinistaBuscado = asignacion.idMaquinistaRealizaTurno;
    }
    else {
      idMaquinistaBuscado = asignacion.idMaquinistaPide;
    }
    await FirebaseFirestore.instance.collection("maquinistas").doc(
        idMaquinistaBuscado)
        .get()
        .then((value) {
      oneSignalID = value.data()!["oneSignalID"].toString();
      print("DE INTERNET+++++++++++++++++++ " +
          value.data()!["oneSignalID"].toString());
    });
    print(oneSignalID);
    return oneSignalID;
  }

  void deleteAsignacionTurno(String idAsignacion) {
    FirebaseFirestore.instance.collection("listaAsignacionesTurnos").doc(
        idAsignacion).delete().then((_) {
      print("ASIGNACION BORRADO!!!");
      showAlert2(context, "Turno borrado");

    });
  }

  void modificarContadorMaquinista(String uid, int valor) {
    FirebaseFirestore.instance.collection("maquinistas").doc(uid).update({
      "contadorTurnos": FieldValue.increment(valor)});
  }

  Future<Response> sendNotification(List<String> tokenIdList, String contents, String heading,int clave) async{

    return await post(
      Uri.parse('https://onesignal.com/api/v1/notifications'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>
      {
        "app_id": "abaf1fcf-5ec8-4294-a71c-f99746ce3a7b",//kAppId is the App Id that one get from the OneSignal When the application is registered.

        "include_player_ids":  tokenIdList ,//tokenIdList Is the List of All the Token Id to to Whom notification must be sent.

        // android_accent_color reprsent the color of the heading text in the notifiction
        "android_accent_color":"FF9976D2",

        "small_icon":'@mipmap/launcher_icon',

        "headings": {"en": heading},

        "contents": {"en": contents},

        "data":  {"en": clave},

      }),
    );
  }





}

