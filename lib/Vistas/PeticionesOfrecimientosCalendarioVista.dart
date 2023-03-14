
import 'dart:collection';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../DrawerWidget.dart';
import '../Modelos/ModeloMaquinista.dart';
import '../Modelos/ModeloTurno.dart';
import '../notificationApi.dart';

class PeticionesOfrecimientosCalendarioVista extends StatefulWidget{

  Map<DateTime, dynamic> map = {};

  PeticionesOfrecimientosCalendarioVista(this.map);


  _PeticionesOfrecimientosCalendarioVista createState() => _PeticionesOfrecimientosCalendarioVista();
}

class _PeticionesOfrecimientosCalendarioVista extends State<PeticionesOfrecimientosCalendarioVista> {

  DateTime? _selectedDay;
  DateTime _focusedDay = DateTime.now();
  TextEditingController turnoController = TextEditingController();



  void _onDaySelected(DateTime? selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        if (selectedDay != null) {
          _selectedDay = DateTime.now();
          _selectedDay = selectedDay;

          print(_selectedDay);
          DateTime timeSeleccionado = DateTime(
              _selectedDay!.year, _selectedDay!.month, _selectedDay!.day);
          if (selectedDay != null) {
            ModeloTurno? turnoPedido = widget.map[timeSeleccionado];
          }

          _focusedDay = focusedDay;
        }
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
                          for (var d in widget.map.keys) {
                            ModeloTurno turno = widget.map[d];
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
        ModeloTurno turno = widget.map[timeSeleccionado];
        String clave = turno.clave.toString();
        print("COMPROBAR EL GRAFICO DE ESE DIA!!!" + turno.grafico.toString());
        print("COMPROBAR CLAVE DE ESE DIA!!!" + turno.clave.toString());
        String? grafico = turno.grafico.toString();
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [(turno.idMaquinistaCandidato == null) ? //ES UNA PETICION
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
                child: Text("OFRECIMIENTO a hacer clave de: "+ grafico ,style: TextStyle(fontSize: 20,)
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
                                    ModeloTurno turnoPedido = widget.map[timeSeleccionado];
                                    //borro el turno de Firebase
                                    deleteTurnoPedido(turnoPedido);
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


  Future<ModeloMaquinista?> getMaquinista(String id) async {
    ModeloMaquinista? maquinista;
    await FirebaseFirestore.instance.collection("maquinistas").doc(id)
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

  Future<String?> getTokenCandidato(String id) async{
    String? token;
    await FirebaseFirestore.instance.collection("maquinistas").doc(id)
        .get()
        .then((value) {
      token = value.data()!["oneSignalID"].toString();
    });
    return token;
  }





  void deleteTurnoPedido(ModeloTurno turno){
    if(turno.idMaquinistaCandidato == null){
      FirebaseFirestore.instance.collection("listaPeticiones").doc(turno.idTurno).delete().then((_){
        print("TURNO BORRADO!!!");
        showAlert(context, "Peticion elimininada");
      });
    }
    else{
      FirebaseFirestore.instance.collection("listaOfrecimientos").doc(turno.idTurno).delete().then((_){
        print("TURNO BORRADO!!!");
        showAlert(context, "Ofrecimiento elimininado");
      });
    }

  }

  Future<void> addAsignacion(ModeloTurno turno) async {
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



  void sumarTurnoMaquinista(ModeloTurno turnoPedido){
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



  String infoTurno(ModeloTurno turno){
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
