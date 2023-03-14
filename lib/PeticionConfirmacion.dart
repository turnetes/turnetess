/*
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:math';
import 'dart:io' as IO;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_launch/flutter_launch.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:localstorage/localstorage.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:turnetes/Modelos/ModeloMaquinista.dart';
import 'package:turnetes/Controladores/PeticionesControlador.dart';
import 'package:turnetes/peticiones4.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'Modelos/ModeloTurno.dart';
import 'loadMapMisAcuerdos.dart';
import 'notificationApi.dart';

class PeticionConfirmacionVista extends StatefulWidget {

  ModeloTurno turno;
  //LocalStorage storage;
  PeticionConfirmacionVista(this.turno);

  _PeticionConfirmacionVista createState() => _PeticionConfirmacionVista(turno);
}

class _PeticionConfirmacionVista extends State<PeticionConfirmacionVista> {

  final ModeloTurno turno;

  _PeticionConfirmacionVista(this.turno);
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
          title: Text("Confirmación de turno"),
          backgroundColor: Colors.purple,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: (){
              Navigator.of(context).pop();
            },
          )
      ),
      body: FutureBuilder<Maquinista?>(
          future: getMaquinista(turno),
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
                        child: Text(turno.clave.toString(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
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
                      child: TableCalendar(locale: 'es_ES',selectedDayPredicate: (day) =>isSameDay(day, turno.fecha),focusedDay: turno.fecha, firstDay: DateTime.now(), lastDay: DateTime(2025), startingDayOfWeek: StartingDayOfWeek.monday,
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
                    child: const Text('Pedir turno'),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder()),
                      padding: MaterialStateProperty.all(EdgeInsets.all(20)),
                      backgroundColor: MaterialStateProperty.all(Colors.red), // <-- Button color
                      overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
                        if (states.contains(MaterialState.pressed)) return Colors.blue; // <-- Splash color
                      }),
                    ),
                    onPressed: () async{
                      String? idPropio = await FirebaseAuth.instance.currentUser?.uid;
                      PeticionesControlador peticionesControlador = PeticionesControlador();
                      peticionesControlador.checkRestriccionesPeticionConfirmacion(context,turno);
                    },
                  ),
                ],
              );
            };

            return const Center(child: CircularProgressIndicator());
          }),
    );
  }

  String infoTurno(ModeloTurno turno){
    return "TE CUBREN LA CLAVE: "+ turno.clave.toString() + "DEL DIA: "+  turno.fecha.day.toString() +"/"+ turno.fecha.month.toString() +
        "REVISA LA INFORMACION EN TU AREA DE ACUERDOS";
  }

  confirmarCambio(ModeloTurno turnoPedido,String idPropio) async{
    showAlert7(context,"Confirmado que realizas el turno a tu compañero, revisa la info en tu area de Mis Acuerdos");
    //Creo obejto Asignación.
    addAsignacion(turnoPedido);
    //Suma turno al maquinista que hace el turno
    sumarTurnoMaquinista(turnoPedido,idPropio);
    //Resta turno al maquinista que le hacen el turno
    restarTurnoMaquinista(turnoPedido.fecha);
    //Borrar objeto de la coleccion de peticiones puesto que lo saco de esa lista y lo paso a la listaAsignaciones.
    deleteTurnoPedido(turnoPedido.idTurno);
    //Enviar notificacion al Maquinista que realiza el turno para que sepa que has confirmado
    List<String> listaToken = [];
    String? token =  await getTokenCandidato(turnoPedido.idMaquinistaPide!);
    listaToken.add(token!);
    await sendNotification(listaToken,infoTurno(turnoPedido),"BUENAS NOTICIAS",3);
    //Creo una notificacion local para recordarte que te hacen el turno el día anterior
    String clave = turnoPedido.clave.toString();
    await NotificationApi.showScheduledNotification(
        title: "RECORDATORIO",
        body: "Mañana te cubren el turno: $clave. No esta de más que os lo recordeis." ,
        scheduleDate: turnoPedido.fecha.add(const Duration(days: -1))
    );

    Navigator.pushReplacement(
        context, MaterialPageRoute(
        builder: (context) => LoadMapMisAcuerdos()));
  }

  void deleteTurnoPedido(String idTurno){
    FirebaseFirestore.instance.collection("listaPeticiones").doc(idTurno).delete().then((_){
      print("TURNO BORRADO!!!");
      //showAlert(context, "Peticion elimininada");
    });
  }

  showAlert7(BuildContext context, String text) {
    showDialog(
      context: context,
      builder: (context) {
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

  Future<void> addAsignacion(ModeloTurno turno) async {
    FirebaseFirestore.instance.collection('listaAsignacionesTurnos').add(
        {
          'clave': turno.clave,
          'idMaquinistaPide': turno.idMaquinistaPide,
          'idMaquinistaRealizaTurno': FirebaseAuth.instance.currentUser?.uid,
          'fechaAceptacion': DateTime.now(),
          'fechadiaTurno': turno.fecha
        }
    ).then((value){
      FirebaseFirestore.instance.collection('listaAsignacionesTurnos').doc(value.id).set(
          {
            "idAsignacionTurno" : value.id,
          },SetOptions(merge: true)).then((_){
        print("successNUEVO!");
      });
    });
    //actualizarContadorTurnos();
  }



  void sumarTurnoMaquinista(ModeloTurno turnoPedido,String idPropio){
    int cont;
    //suma turno al maquinista que realiza el turno
    if(sacarFestivos(turnoPedido.fecha)!){
      FirebaseFirestore.instance.collection("maquinistas").doc(idPropio).update({
        "contadorFestivos" : FieldValue.increment(1),
        "contadorTurnos" : FieldValue.increment(1)});
    }
    else{
      FirebaseFirestore.instance.collection("maquinistas").doc(idPropio).update({
        "contadorTurnos" : FieldValue.increment(1)});
    }
  }

  bool? sacarFestivos(DateTime? date2) {
    late String resp;
    if (date2 != null) {
      String dia = DateFormat('EEEE').format(date2);
      print("HOLAAAAAAAAAAAAAA HOY ES :$dia");
      switch (dia) {
        case "Monday":
          return false;
        case "Tuesday":
          return false;
        case "Wednesday":
          return false;
        case "Thursday":
          return false;
        case "Friday":
          return false;
        case "Saturday":
          return true;
        case "Sunday":
          return true;
      }
    }
  }

  void restarTurnoMaquinista(DateTime fecha){
    //el maquinista que confirma la peticion que es el que esta usando la app se le resta uno
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if(sacarFestivos(fecha)!){
      FirebaseFirestore.instance.collection("maquinistas").doc(uid).update({
        "contadorFestivos" : FieldValue.increment(-1),
        "contadorTurnos" : FieldValue.increment(-1)});
    }
    else{
      FirebaseFirestore.instance.collection("maquinistas").doc(uid).update({
        "contadorTurnos" : FieldValue.increment(-1)});
    }
  }

  Future<String?> getTokenCandidato(String id) async{
    String? token;
    await FirebaseFirestore.instance.collection("maquinistas").doc(id)
        .get()
        .then((value) {
      token = value.data()!["oneSignalID"].toString();
    });
    return token;
  }


  Future<Maquinista?> getMaquinista(ModeloTurno turno) async {
    Maquinista? maquinista;
    await FirebaseFirestore.instance.collection("maquinistas").doc(turno.idMaquinistaPide)
        .get()
        .then((value) {
      maquinista = new Maquinista( value.data()!["apodo"].toString(),
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

  showAlert1(BuildContext context) {
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
            content: new Text('No puedes realizar tu propio turno'),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Peticiones4(widget.storage)));
                    Navigator.pop(context);
                  },
                  child: Text('OK')),
            ]
        );
      },
    );
  }


  showAlert3(BuildContext context,String text) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: Text('AVISO'),
            content: new Text(text),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    print("DENTRO DEL SHOWALERT3!!!!!!!!!");
                    Navigator.of(context).pop(true);
                    print("DENTRO DEL SHOWALERT3!!!!!!!!!2");

                    LocalStorage storage = new LocalStorage('peticiones.json');

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => LoadMapMisAcuerdos(),
                      ),
                          (route) => false,
                    );


                  },

                  child: Text('OK')),
            ]
        );
      },
    );
  }

  showAlert5(BuildContext context,String text) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: Text('AVISO'),
            content: new Text(text),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text('OK')),
            ]
        );
      },
    );
  }


  showAlert(mensaje,BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        Future.delayed(
          Duration(seconds: 1),
        );

        return AlertDialog(
          title: Text(mensaje),
        );
      },
    );
  }







  void candidatoRealizarTurno(String idTurno,String idPropioMaq){
    FirebaseFirestore.instance.collection("listaPeticiones").doc(idTurno).update({
      "idMaquinistaCandidato" : idPropioMaq});
  }



  void deleteTurnoPeticiones(String idTurno){
    FirebaseFirestore.instance.collection("listaPeticiones").doc(idTurno).delete().then((_){
      print("TURNO BORRADO!!!");
    });
  }

  Future<bool?> getCandidatoHaciaTienePeticionTurnoEseDia(String? idSolicita) async {
    LocalStorage storage = new LocalStorage('peticiones.json');
    await storage.ready;
    var str = await storage.getItem('mapPeticiones5');
    Map<String, List<dynamic>?> mapDecodificado = Map.castFrom(await json.decode(str));
    if(str != null){
      if(mapDecodificado.isNotEmpty ) {
        for(var v in mapDecodificado.values){
          if(v!.isNotEmpty){
            if(v[0] ==  turno.fecha.toString()){
              if(v[2] == idSolicita){
                return true;
              }
            }
          }

        }
      }
    }
    return false;
  }

  //Probando
  Future<bool?> getCandidatoHaciaYaTurnoEseDia(String? idSolicita) async {
    bool haceTurno = false;
    var datos = await FirebaseFirestore.instance.collection(
        "listaAsignacionesTurnos").get();
    //Antes de ver si cubro un turno ese dia, tengo k comprobar que no haya solicitado una peticion de turno ese mismo dia
    datos.docs.forEach((element) {
      if ((turno.fecha.isAtSameMomentAs(element.data()['fechadiaTurno'].toDate())) &&
          element.data()['idMaquinistaRealizaTurno'] == idSolicita){
        print("SE CUMPLEEEEEEEE MAQUINISTA CUBRE YA TURNO ESE DIA");
        haceTurno = true;
      }

    });
    return haceTurno;
  }


  Future<bool?> getCandidato() async {
    bool candidato = false;
    String? maqCandidato;
    await FirebaseFirestore.instance.collection("listaPeticiones").doc(
        turno.idTurno)
        .get()
        .then((value) {
      if(value.data()!["idMaquinistaCandidato"] != null){
        candidato = true;
      }
    });
    return candidato;
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

        //"small_icon":"ic_stat_onesignal_default",
        "small_icon":'@mipmap/launcher_icon',

        //"large_icon":"https://www.filepicker.io/api/file/zPloHSmnQsix82nlj9Aj?filename=name.jpg",
        //"large_icon": "assets/anonimo.jpg",

        "headings": {"en": heading},

        "contents": {"en": contents},

        "data":  {"en": clave},


      }),
    );
  }




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



}



 */