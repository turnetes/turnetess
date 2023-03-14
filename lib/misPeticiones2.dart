/*
import 'dart:collection';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import 'DrawerWidget.dart';
import 'ModeloTurno.dart';
import 'acuerdosPersonales.dart';
import 'loadMapMisAcuerdos.dart';
import 'Modelos/ModeloMaquinista.dart';
import 'notificationApi.dart';

class MisPeticiones2 extends StatefulWidget{

  Map<DateTime, dynamic> map = {};

  MisPeticiones2(this.map);


  _MisPeticiones2 createState() => _MisPeticiones2();
}

class _MisPeticiones2 extends State<MisPeticiones2> {

  DateTime? _selectedDay;
  DateTime _focusedDay = DateTime.now();
  TextEditingController turnoController = TextEditingController();


  void _onDaySelected(DateTime? selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        if(selectedDay != null){
          _selectedDay = DateTime.now();
          _selectedDay = selectedDay;

          print(_selectedDay);
          DateTime timeSeleccionado = DateTime(_selectedDay!.year,_selectedDay!.month,_selectedDay!.day);
          if(selectedDay != null ){
            Turno? turnoPedido = widget.map[timeSeleccionado];
            if(turnoPedido?.idMaquinistaCandidato != null && turnoPedido!.clave != null){
              showDialog<String>(
                context: context,
                builder: (BuildContext context) =>
                    AlertDialog(
                        title: Text(
                            'AVISO IMPORTANTE:'),
                        content: const Text(
                            'Un compañero te cubre el turno'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () =>
                                Navigator.pop(context, 'Cancel'),
                            child: const Text('Volver'),
                          ),
                          ElevatedButton(
                              child: Text("Confirmar cambio"),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.purple,
                              ),
                              onPressed: (){
                                confirmarCambio(turnoPedido);
                              }
                          ),
                        ]
                    ),
              );

            }
          }


          //print(_getEventsForDay(_selectedDay!)); //esto idea mia

        }

        _focusedDay = focusedDay;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('Mis Peticiones'),
          backgroundColor: Colors.purple,
        ),
        drawer: DrawerWidget(),
        body:  misPeticiones()
    );
  }

  Widget? misPeticiones() {
    if (widget.map.isNotEmpty) {
      return  SingleChildScrollView(
        child: Column(
            children: <Widget>[
              SizedBox(height: 30,),
              Container(
                child: InputDecorator(
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      borderSide: BorderSide(color: Colors.purple, width: 5),
                    ),
                    labelText: 'Mi calendario:',
                    labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  child:
                  TableCalendar(locale: 'es_ES',
                    selectedDayPredicate: (day) =>
                        isSameDay(day, _selectedDay),
                    focusedDay: _focusedDay,
                    firstDay: DateTime(2022),
                    lastDay: DateTime(2025),
                    startingDayOfWeek: StartingDayOfWeek.monday,
                    onDaySelected: _onDaySelected,
                    calendarBuilders: CalendarBuilders(
                        defaultBuilder: (context, day, focusedDay) {
                          String? uid = FirebaseAuth.instance.currentUser?.uid;
                          print("TAMAÑOOOOO:    " + widget.map.keys.length.toString());
                          print("TAMAÑOOOOO:    " + widget.map.keys.toString());
                          for (var d in widget.map.keys) {
                            Turno turno = widget.map[d];
                            if(day.day == d.day && day.month == d.month && day.year == d.year && turno.idMaquinistaPide == null){
                              return Container(
                                decoration: const BoxDecoration(
                                  color: Colors.deepPurpleAccent,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.0),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    '${day.day}',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              );
                            }
                            else{
                              if(day.day == d.day && day.month == d.month && day.year == d.year && turno.idMaquinistaCandidato == null){
                                return Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.amber,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8.0),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${day.day}',
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                );
                              }
                            }
                          }
                          return null;

                        }),
                    calendarStyle: CalendarStyle(
                      isTodayHighlighted: true,
                      markerDecoration: BoxDecoration(
                        color: Colors.purple,
                        shape: BoxShape.rectangle,

                      ),
                      weekendTextStyle: TextStyle(color: Colors.red),
                    ),
                    headerStyle: HeaderStyle(titleCentered: true,
                        formatButtonVisible: false,
                        decoration: BoxDecoration(color: Colors.white10)),
                  ),
                ),
              ),

              SizedBox(height: 20,),
              Row( mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Icon(Icons.calendar_today, color: Colors.amber,),
                      Text("Peticion de turno", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Column(
                    children: [
                      Icon(Icons.calendar_today, color: Colors.deepPurpleAccent,),
                      Text("Ofrecimiento de turno", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10,),

              SizedBox(height: 30,),
              getTurno(),
              SizedBox(height: 10,),
            ]
        ),
      );
    }
    else {
      return Center(
          child: Text("NO TIENES PETICIONES")
      );
    }
  }


  Widget getTurno(){
    if(_selectedDay == null){
      return Center(
          child: Text("Seleccione un día", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
      );
    }
    else{
      DateTime timeSeleccionado = DateTime(_selectedDay!.year,_selectedDay!.month,_selectedDay!.day);
      if(widget.map[timeSeleccionado] == null){

        return Container(
            child: InputDecorator(
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      borderSide: BorderSide(color: Colors.purple, width: 5),
                    ),
                    labelText: 'Información del día:', labelStyle: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)
                ),
                child:
                Text("No tienes peticion realizada para ese día" , style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
            )
        );

      }
      else{
        Turno turno = widget.map[timeSeleccionado];
        String clave = turno.clave.toString();
        String? grafico = turno.grafico;
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            (turno.idMaquinistaCandidato == null) ? //ES UNA PETICION
            Container(
              child: InputDecorator(
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.train, color: Colors.purple),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      borderSide: BorderSide(color: Colors.purple, width: 5),
                    ),
                    labelText: 'Información del día:', labelStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                ),
                child: Text("PETICIÓN de la clave: $clave" ,style: TextStyle(fontSize: 20,)
                ),
              ),
            ) : //Es un OFRECIMIENTO
            Container(
              child: InputDecorator(
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.train, color: Colors.purple),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      borderSide: BorderSide(color: Colors.purple, width: 5),
                    ),
                    labelText: 'Información del día:', labelStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                ),
                child: Text("OFRECIMIENTO a hacer clave de: $grafico" ,style: TextStyle(fontSize: 20,)
                ),
              ),
            ),
            ElevatedButton(
                child: Text("Eliminar petición"),
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder()),
                  padding: MaterialStateProperty.all(EdgeInsets.all(10)),
                  backgroundColor: MaterialStateProperty.all(Colors.red), // <-- Button color
                  overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
                    if (states.contains(MaterialState.pressed)) return Colors.blue; // <-- Splash color
                  }),
                ),
                onPressed: () {
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) =>
                        AlertDialog(
                            title: const Text(
                                'Eliminar petición'),
                            content: const Text(
                                'Quieres eliminar tu propia petición?'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, 'Cancel'),
                                child: const Text('Cancel'),
                              ),

                              TextButton(
                                  child: const Text('OK'),
                                  onPressed: () async {
                                    DateTime? timeSeleccionado = DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day);
                                    Turno turnoPedido = widget.map[timeSeleccionado];
                                    //borro el turno de Firebase
                                    deleteTurnoPedido(turnoPedido.idTurno);
                                    widget.map.remove(timeSeleccionado);
                                    Navigator.pop(context);
                                    setState(() {

                                      misPeticiones();
                                    });
                                    /*
                                    Navigator.pushReplacement(
                                        context, MaterialPageRoute(
                                        builder: (context) =>
                                            LoadMapMisPeticiones()));

                                     */

                                  }
                              ),
                            ]
                        ),
                  );
                }
            )


          ],
        );
      }
    }

  }


  Widget getTurno2(){
    if(_selectedDay == null){
      return Center(
          child: Text("Seleccione un día", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
      );
    }
    else{
      DateTime timeSeleccionado = DateTime(_selectedDay!.year,_selectedDay!.month,_selectedDay!.day);
      if(widget.map[timeSeleccionado] == null){
        return Text("No tienes peticion realizada para ese día" , style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold));
      }
      else{

        Turno turnoPedido = widget.map[timeSeleccionado];
        String clave = turnoPedido.clave.toString();
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              child: InputDecorator(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.train, color: Colors.purple),
                  hintText: "Turno seleccionado",
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      borderSide: BorderSide(color: Colors.purple, width: 5)
                  ),
                ),
                child: (turnoPedido.idMaquinistaPide == null) ? Center(
                    child: Text("Has solictado trabajar pero no tienes candidato" , style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))

                )
                //Pide es distinto de null mira a ver si tienes candidato
                    : (turnoPedido.idMaquinistaCandidato != null) ?
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Clave solicitada: $clave" ,style: TextStyle(fontSize: 20,)),
                    SizedBox(height: 5),
                    (turnoPedido.idMaquinistaCandidato == null) ?
                    Text("No tienes ningun candidato a cubrirla" , style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
                        :  Text("Ya tienes candidato, por favor confirmalo" , style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ) : null ,
              ),
            ),
            ElevatedButton(
                child: Text("Eliminar petición"),
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder()),
                  padding: MaterialStateProperty.all(EdgeInsets.all(10)),
                  backgroundColor: MaterialStateProperty.all(Colors.red), // <-- Button color
                  overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
                    if (states.contains(MaterialState.pressed)) return Colors.blue; // <-- Splash color
                  }),
                ),
                onPressed: () {
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) =>
                        AlertDialog(
                            title: const Text(
                                'Eliminar petición'),
                            content: const Text(
                                'Quieres eliminar tu propia petición?'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, 'Cancel'),
                                child: const Text('Cancel'),
                              ),

                              TextButton(
                                  child: const Text('OK'),
                                  onPressed: () async {
                                    DateTime? timeSeleccionado = DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day);
                                    Turno turnoPedido = widget.map[timeSeleccionado];
                                    //borro el turno de Firebase
                                    deleteTurnoPedido(turnoPedido.idTurno);
                                    widget.map.remove(timeSeleccionado);
                                    Navigator.pop(context);
                                    setState(() {

                                      misPeticiones();
                                    });
                                    /*
                                    Navigator.pushReplacement(
                                        context, MaterialPageRoute(
                                        builder: (context) =>
                                            LoadMapMisPeticiones()));

                                     */

                                  }
                              ),
                            ]
                        ),
                  );
                }
            )

          ],
        );
      }
    }

  }

  showAlert(BuildContext context, String text) {
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

  void confirmarCambio(Turno turnoPedido) async{
    //Creo obejto Asignación.
    addAsignacion(turnoPedido);
    //Suma turno al maquinista que hace el turno
    sumarTurnoMaquinista(turnoPedido);
    //Resta turno al maquinista que le hacen el turno
    restarTurnoMaquinista(turnoPedido.fecha);
    //Borrar objeto de la coleccion de peticiones puesto que lo saco de esa lista y lo paso a la listaAsignaciones.
    deleteTurnoPedido(turnoPedido.idTurno);
    //Enviar notificacion al Maquinista que realiza el turno para que sepa que has confirmado
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

  Future<Maquinista?> getMaquinista(String id) async {
    Maquinista? maquinista;
    await FirebaseFirestore.instance.collection("maquinistas").doc(id)
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

  Future<String?> getTokenCandidato(String id) async{
    String? token;
    await FirebaseFirestore.instance.collection("maquinistas").doc(id)
        .get()
        .then((value) {
      token = value.data()!["oneSignalID"].toString();
    });
    return token;
  }





  void deleteTurnoPedido(String idTurno){
    FirebaseFirestore.instance.collection("listaPeticiones").doc(idTurno).delete().then((_){
      print("TURNO BORRADO!!!");
      showAlert(context, "Peticion elimininada");
    });
  }

  Future<void> addAsignacion(Turno turno) async {
    FirebaseFirestore.instance.collection('listaAsignacionesTurnos').add(
        {
          'clave': turno.clave,
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
    //suma turno al maquinista que realiza el turno
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



  String infoTurno(Turno turno){
    return "CUBRES LA CLAVE: "+ turno.clave.toString() + "DEL DIA: "+  turno.fecha.day.toString() +"/"+ turno.fecha.month.toString() +
        "REVISA LA INFORMACION EN TU AREA DE ACUERDOS";
  }






  String sacarDiaSemana(DateTime? date2) {
    late String resp;
    if(date2 == null){
      return "dia no elegido";
    }
    else{
      String dia =DateFormat('EEEE').format(date2);
      switch(dia) {
        case "Monday":
          dia = "Lunes";
          break; // The switch statement must be told to exit, or it will execute every case.
        case "Tueday":
          dia = "Martes";
          break;
        case "Wednesday":
          dia = "Miercoles";
          break;
        case "Thursday":
          dia = "Jueves";
          break;
        case "Friday":
          dia = "Viernes";
          break;
        case "Saturday":
          dia = "Sabado";
          break;
        case "Sunday":
          dia = "Domingo";
          break;
      }
      return dia;
    }
  }
}



 */