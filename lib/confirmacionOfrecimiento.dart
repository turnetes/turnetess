/*

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:localstorage/localstorage.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:turnetes/ofrecimientos.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'dart:io' as IO;
import 'ModeloTurno.dart';
import 'loadMapMisAcuerdos.dart';
import 'Modelos/ModeloMaquinista.dart';
import 'notificationApi.dart';
import 'package:intl/intl.dart';

class ConfirmacionOfrecimiento extends StatefulWidget {

  Turno turno;
  LocalStorage storage;
  ConfirmacionOfrecimiento(this.storage, this.turno);

  _ConfirmacionOfrecimiento createState() => _ConfirmacionOfrecimiento(turno);
}

class _ConfirmacionOfrecimiento extends State<ConfirmacionOfrecimiento> {

  final Turno turno;
  int? turnoElegido;
  TextEditingController turnoController = TextEditingController();
  String? idMaquinistaHaceTurno = FirebaseAuth.instance.currentUser?.uid;
  bool activar = false;

  _ConfirmacionOfrecimiento(this.turno);

  void initState() {
    super.initState();
    turnoController.addListener(() {
      setState(() {
        activar = turnoController.text.isNotEmpty;
      });
    });
  }


  @override
  Widget build(BuildContext context) {

    final turnoField =TextFormField(
      autofocus: false,
      controller: turnoController,
      autovalidateMode: AutovalidateMode.always,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly
      ],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'campo vacio';
        }
        //un mail correcto

        if (value.length < 3 || value.length > 4) {
          return ("la clave tiene 3 o 4 cifras exclusivamente");
        }
        int valor = int.parse(value);
        if(comprobarGrafico(valor, turno.grafico)){
          return ("No es un turno de ese horario");
        }

        return null;
      },
      onSaved: (value){
        turnoController.text = value!;


      },

      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.train, color: Colors.purple),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "escriba aquí numero de turno",

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          borderSide: BorderSide(width: 3,color: Colors.green),
        ),

        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
            borderSide: BorderSide(color: Colors.purple, width: 5)
        ),


        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(width: 3,color: Colors.red)
        ),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(width: 3,color: Colors.purple)
        ),


      ),
    );

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
              return SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[

                      SizedBox(height: 20,),
                      Container(
                        child: InputDecorator(
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(12.0)),
                                borderSide: BorderSide(color: Colors.purple, width: 5),
                              ),
                              labelText: 'Horario posible:',
                            ),
                            child: Text(turno.grafico!, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
                        ),
                      ),
                      SizedBox(height: 20,),
                      turnoField,
                      SizedBox(height: 20,),
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
                      SizedBox(height: 20,),

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
                      SizedBox(height: 20,),
                      ElevatedButton(
                        child: const Text('Coger turno'),
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(RoundedRectangleBorder()),
                          padding: MaterialStateProperty.all(EdgeInsets.all(20)),
                          backgroundColor: MaterialStateProperty.all(Colors.red), // <-- Button color
                          overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
                            if (states.contains(MaterialState.pressed)) return Colors.blue; // <-- Splash color
                          }),
                        ),
                        onPressed: activar  ? () async{
                          String? idPropio = await FirebaseAuth.instance.currentUser?.uid;
                          if (idPropio == turno.idMaquinistaPide) {
                            showAlert1(context);
                          }
                          else {//es otro maquinista no el mismo que pidio, seguimos....

                            //Comprobamos que ese maquinista no realiza otro turno ya ese dia..
                            bool? haceTurno = await getCandidatoHaciaYaTurnoEseDia(idPropio);
                            if(haceTurno!){

                              print("ESTE ES EL PUTO NUMERO: "+ turnoElegido.toString());
                              //cubre otro turno el mismo maquinisita que esta pididendo salta showAlert
                              showAlert3(context,"Ese dia ya cubres otro turno. Revisalo en tu are de mis Acuerdos");
                            }
                            else{
                              // todo correcto
                              int turnoSeleccionado = int.parse(turnoController.text);
                              await confirmarCambio(turno, turnoSeleccionado);
                              List<String> listaToken = [];
                              listaToken.add(snapshot.data!.oneSignalID);
                              //notificacion instantanea
                              //await sendNotification(listaToken,infoTurno(turnoElegido!),"BUENAS NOTICIAS",4);
                              //notificacion diferida el dia anterior al turno para recordar que hace el turno




                              /*
                            //ESTO LO TENGO K MOVER AL AREA DE PETICIONES

                            //Creo obejto Asignación.
                            addAsignacion(turno);
                            //Suma turno al maquinista que hace el turno
                            sumarTurnoMaquinista(turno);
                            //Resta turno al maquinista que le hacen el turno
                            restarTurnoMaquinista();
                            //elimino turno ofrecido de la listaOfrecimientos:
                            deleteTurnoOfrecimientos(turno.idTurno);

                             */


                              await candidatoRealizarTurno(turno.idTurno,idPropio!);
                              await NotificationApi.showScheduledNotification(
                                  title: "RECORDATORIO IMPORTANTE",
                                  body: "Mañana le haces el turno: " + turnoElegido.toString() + "No esta de más que os lo recordeis." ,
                                  scheduleDate: turno.fecha.add(const Duration(days: -1))
                              );
                              showAlert3(context,"Realizacion de peticion turno registrada, solo falta que te confirme el compañero");
                              //Navigator.push(context, MaterialPageRoute(builder: (context) => Peticiones4(storage)));
                            }
                          }
                        } : null,
                      ),
                    ],
                  )
              );
            };

            return const Center(child: CircularProgressIndicator());
          }),
    );

  }
  /*

  String? sacarGrafico(int clave) {
    dynamic i = (clave / 100);
    int x = i.toInt();
    switch (x) {
      case 1:
        return "Mañanas Mañanas";
        break;
      case 2:
        return "General";
        break;
      case 3:
        return "Tardes Tardes";
        break;
      case 4:
        return "Villalba";
        break;
      case 5:
        return "Alcala";
        break;
      case 4:
        return "P.Pio";
        break;
      case 7 :
        return "Noche";
        break;
    }

  }

  bool noSonIguales(int value){
    if(turno.grafico == sacarGrafico(value)){
      return false;
    }
    else{
      return true;
    }
  }

   */

  bool comprobarGrafico(int clave,String? franja){
    dynamic i = (clave / 100);
    String? grafico;
    int x = i.toInt();
    switch (x) {
      case 1:
        grafico = "Mañanas Mañanas";
        break;
      case 2:
        grafico = "General";
        break;
      case 3:
        grafico = "Tardes Tardes";
        break;
      case 4:
        grafico = "Villalba";
        break;
      case 5:
        grafico = "Alcala";
        break;
      case 4:
        grafico = "P.Pio";
        break;
      case 7 :
        grafico = "Noche";
        break;
    }
    return franja == grafico;
  }


  Future<Maquinista?> getMaquinista(Turno turno) async {
    Maquinista? maquinista;
    await FirebaseFirestore.instance.collection("maquinistas").doc(turno.idMaquinistaCandidato)
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

  void maquinistaPide(String idTurno,String idPropioMaq){
    FirebaseFirestore.instance.collection("listaPeticiones").doc(idTurno).update({
      "idMaquinistaPide" : idPropioMaq});
  }

  //################# ESTO HAY K LLEVARSELO DE AQUI
  Future<void> addAsignacion(Turno turno, int turnoSeleccionado) async {
    FirebaseFirestore.instance.collection('listaAsignacionesTurnos').add(
        {
          'clave': turnoSeleccionado,
          'idMaquinistaPide': FirebaseAuth.instance.currentUser?.uid,
          'idMaquinistaRealizaTurno': turno.idMaquinistaCandidato,
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



  void sumarTurnoMaquinista(Turno turnoPedido){
    int cont;
    //suma turno al maquinista que se ha ofrecido a trabajar que es el que NO esta "usando" la app
    if(sacarFestivos(turnoPedido.fecha)!){
      FirebaseFirestore.instance.collection("maquinistas").doc(turnoPedido.idMaquinistaCandidato).update({
        "contadorFestivos" : FieldValue.increment(1),
        "contadorTurnos" : FieldValue.increment(1)});
    }
    else{
      FirebaseFirestore.instance.collection("maquinistas").doc(turnoPedido.idMaquinistaCandidato).update({
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
        case "Tueday":
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

  confirmarCambio(Turno turnoPedido, int turnoSeleccionado) async{
    //Creo obejto Asignación.
    addAsignacion(turnoPedido,turnoSeleccionado);

    //Suma turno al maquinista que hace el turno
    sumarTurnoMaquinista(turnoPedido);

    //Resta turno al maquinista que le hacen el turno
    restarTurnoMaquinista(turnoPedido.fecha);

    //Borrar objeto de la coleccion de Ofrecimientos puesto que lo saco de esa lista y lo paso a la listaAsignaciones.
    deleteTurnoOfrecimientos(turnoPedido.idTurno);

    //Enviar notificacion al Maquinista que va a realizar el turno que es el que se OFRECIO a trabajar
    List<String> listaToken = [];
    String? token =  await getTokenCandidato(turnoPedido.idMaquinistaCandidato!);
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

  void restarTurnoMaquinista(DateTime fecha){
    //el maquinista que confirma el Ofrecimiento le han hecho que es el que ahora esta usando la app se le resta uno
    if(sacarFestivos(fecha)!){
      FirebaseFirestore.instance.collection("maquinistas").doc(idMaquinistaHaceTurno).update({
        "contadorFestivos" : FieldValue.increment(-1),
        "contadorTurnos" : FieldValue.increment(-1)});
    }
    else{
      FirebaseFirestore.instance.collection("maquinistas").doc(idMaquinistaHaceTurno).update({
        "contadorTurnos" : FieldValue.increment(-1)});
    }
  }

  void deleteTurnoOfrecimientos(String idTurno){
    FirebaseFirestore.instance.collection("listaOfrecimientos").doc(idTurno).delete().then((_){
      print("TURNO BORRADO!!!");
    });
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

  candidatoRealizarTurno(String idTurno,String idPropioMaq) async{
    FirebaseFirestore.instance.collection("listaOfrecimientos").doc(idTurno).update({
      "clave" : turnoElegido,
      "idMaquinistaPide" : idPropioMaq,
    });
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
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Ofrecimientos(widget.storage)));
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
                    LocalStorage storage = new LocalStorage('ofrecimientos.json');

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => Ofrecimientos(storage),
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


  String infoTurno(Turno turno){
    return "VAS A TRABJAR: "+ turno.clave.toString() + "DEL DIA: "+  turno.fecha.day.toString() +"/"+ turno.fecha.month.toString() +
        "REVISA LA INFORMACION EN TU AREA DE ACUERDOS";
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