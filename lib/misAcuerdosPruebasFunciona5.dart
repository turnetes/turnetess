/*
import 'dart:collection';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import 'AsignacionTurno.dart';
import 'ModeloTurno.dart';
import 'acuerdosPersonales.dart';

class MisAcuerdosPrueba5 extends StatefulWidget{

  _MisAcuerdosPrueba5 createState() => _MisAcuerdosPrueba5();
}

class _MisAcuerdosPrueba5 extends State<MisAcuerdosPrueba5> {

  DateTime? _selectedDay;
  DateTime _focusedDay = DateTime.now();
  Map<DateTime, dynamic> map = {};

/*
  @override
  initState()  {
    getEvents();

  }

 */

  Future<int>? getEvents() async {
    var datos = await FirebaseFirestore.instance.collection(
        "listaAsignacionesTurnos").get();
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    List<AsignacionTurno> listaAsignaciones = [];
    if (datos.size != 0) {
      for (int i = 0; i < datos.docs.length; i++) {
        AsignacionTurno asignacion = AsignacionTurno(
            datos.docs[i].data()['clave'],
            datos.docs[i].data()['fechaAceptacion'].toDate(),
            datos.docs[i].data()['fechadiaTurno'].toDate(),
            datos.docs[i].data()['idAsignacionTurno'],
            datos.docs[i].data()['idMaquinistaPide'],
            datos.docs[i].data()['idMaquinistaRealizaTurno']);
        if (asignacion.idMaquinistaRealizaTurno != uid) {
          print("ALGUNO CUMPLE@@@@@@@");
          if (asignacion.fechadiaTurno.isAfter(DateTime.now())) {
            DateTime time = datos.docs[i].data()['fechadiaTurno'].toDate();
            DateTime time2 = DateTime(time.year,time.month,time.day);
            var title = datos.docs[i].data()['clave'].toString();
            map[time2] = [asignacion] ;

          }
        }
      }
    }
    return map.length;
  }



  List _getEventsForDay(DateTime day)  {
    final events = LinkedHashMap(equals: isSameDay, hashCode: getHashCode)
      ..addAll(map);
    return events[day] ?? [];
  }

  void _onDaySelected(DateTime? selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        if(selectedDay != null){
          _selectedDay = DateTime.now();
          _selectedDay = selectedDay;

          print(_selectedDay);
          DateTime timeSeleccionado = DateTime(_selectedDay!.year,_selectedDay!.month,_selectedDay!.day);
          if(selectedDay == null ){print("ES VACIOOOOOOOOOO!!!!!!!");}
          else{print(map[timeSeleccionado]);};

          //print(_getEventsForDay(_selectedDay!)); //esto idea mia

        }

        _focusedDay = focusedDay;
      });
    }
  }

  void getValuesFromMap(Map map) {
    // Get all values
    print('----------');
    print('Get values:');
    map.values.forEach((value) {
      print(value);
    });
  }

  void getKeysFromMap(Map map) {
    print('----------');
    print('Get keys:');
    // Get all keys
    map.keys.forEach((key) {
      print(key.hashCode);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mis Acuerdos'),
        backgroundColor: Colors.purple,
      ),
      body: FutureBuilder<int?>
        (future: getEvents(), // a previously-obtained Future<String> or null
          builder: (BuildContext context,snapshot) {
            if (snapshot.hasData) {
              return Column(
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
                          selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
                          focusedDay: _focusedDay,
                          firstDay: DateTime(2022),
                          lastDay: DateTime(2025),
                          startingDayOfWeek: StartingDayOfWeek.monday,
                          onDaySelected: _onDaySelected,
                          eventLoader: (day) {
                            return _getEventsForDay(day);
                          },
                          calendarStyle: CalendarStyle(
                            isTodayHighlighted: true,
                            markerDecoration: BoxDecoration(
                              color: Colors.purple,
                              shape: BoxShape.rectangle,

                            ),
                            weekendTextStyle: TextStyle(color: Colors.red),
                          ),
                          headerStyle: HeaderStyle(titleCentered: true, formatButtonVisible: false, decoration: BoxDecoration(color: Colors.white10)),
                        ),
                      ),
                    ),

                    SizedBox(height: 30,),
                    Container(
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                                Radius.circular(12.0)),
                            borderSide: BorderSide(
                                color: Colors.purple, width: 5),
                          ),
                          labelText: 'dia seleccionado:',
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        child:  miCard(),
                      ),
                    ),
                  ]
              );
            }
            else{
              return Column(
                  children: [
                    TableCalendar(locale: 'es_ES',
                      selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
                      focusedDay: _focusedDay,
                      firstDay: DateTime(2022),
                      lastDay: DateTime(2025),
                      startingDayOfWeek: StartingDayOfWeek.monday,
                      onDaySelected: _onDaySelected,
                      eventLoader: (day) {
                        return _getEventsForDay(day);
                      },
                    ),
                    Container(
                      child: InputDecorator(
                          decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(12.0)),
                              borderSide: BorderSide(
                                  color: Colors.purple, width: 5),
                            ),
                            labelText: 'dia seleccionado:',
                            labelStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                          child: Center(
                              child: Text("No hay acuerdos")
                          )
                      ),
                    ),
                  ]
              );
            }
          }
      ),
    );
  }

  Widget miCard() {

    if(_selectedDay == null){
      return Center(
          child: Text("No tiene turno asignado")
      );
    }
    else{
      DateTime? timeSeleccionado = DateTime(_selectedDay!.year,_selectedDay!.month,_selectedDay!.day);

      if(map[timeSeleccionado] != null){

        List<AsignacionTurno> asignacion = map[timeSeleccionado];
        return Card(

          // Con esta propiedad modificamos la forma de nuestro card
          // Aqui utilizo RoundedRectangleBorder para proporcionarle esquinas circulares al Card
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),

          // Con esta propiedad agregamos margen a nuestro Card
          // El margen es la separación entre widgets o entre los bordes del widget padre e hijo
          margin: EdgeInsets.all(15),

          // Con esta propiedad agregamos elevación a nuestro card
          // La sombra que tiene el Card aumentará
          elevation: 10,

          // La propiedad child anida un widget en su interior
          // Usamos columna para ordenar un ListTile y una fila con botones
          child: Column(
            children: <Widget>[

              // Usamos ListTile para ordenar la información del card como titulo, subtitulo e icono
              ListTile(
                  contentPadding: EdgeInsets.fromLTRB(15, 10, 25, 0),
                  title: Text('Clave: ' + asignacion.first.clave.toString()),
                  subtitle: Text(
                      'Este es el subtitulo del card. Aqui podemos colocar descripción de este card.'),
                  leading: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: 100,
                      minHeight: 100,
                      maxWidth: 150,
                      maxHeight: 150,
                    ),
                    child: Image.asset('assets/work.png'),
                  )
              ),

              // Usamos una fila para ordenar los botones del card
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  IconButton(icon: Icon(Icons.search),
                    onPressed: () =>  Navigator.push(context, MaterialPageRoute(builder: (context) => AcuerdosPersonales(asignacion.first))),),
                ],
              )
            ],
          ),
        );
      }
      else{
        return Center(
            child: Text("No tiene turno asignado")
        );
      }
    }

  }










/*
Future pasarLista() async {
  var datos = await FirebaseFirestore.instance.collection("listaPeticiones").get();
  List<DateTime>? listaTurnos = [];
  if (datos.size == 0) {
    print("peticiones vacía");
  }
  else {
    for (int i = 0; i < datos.docs.length; i++) {
      //solo meteremos en la lista turnos que sean despues de la fecha actual
      if (DateTime.now().isBefore(datos.docs[i].data()['fecha'].toDate())) {
        Turno turno = Turno(datos.docs[i].data()['apodo'],
            datos.docs[i].data()['clave'],
            datos.docs[i].data()['fecha'].toDate(),
            datos.docs[i].data()['idMaquinista'],
            datos.docs[i].data()['idTurno'],
            datos.docs[i].data()['nombre']);
        listaTurnos.add(turno.fecha);
      }
      //Turno turno=Turno(datos.docs[i].data()['idTurno'],datos.docs[i].data()['idMaquinista'],datos.docs[i].data()['clave'],datos.docs[i].data()['fecha'].toDate(),datos.docs[i].data()['apodo']);

    }

  }
  return listaTurnos;
}

 */





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
int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 1, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 1, kToday.day);


class Event {
  final AsignacionTurno asignacion;

  const Event(this.asignacion);

}

 */