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

class MisAcuerdosPrueba extends StatefulWidget{

  Map<DateTime, dynamic> map = {};

  MisAcuerdosPrueba(this.map);


  _MisAcuerdosPrueba createState() => _MisAcuerdosPrueba();
}

class _MisAcuerdosPrueba extends State<MisAcuerdosPrueba> {

  DateTime? _selectedDay;
  DateTime _focusedDay = DateTime.now();
  


  List _getEventsForDay(DateTime day)  {
    final events = LinkedHashMap(equals: isSameDay, hashCode: getHashCode)
      ..addAll(widget.map);
    return events[day] ?? [];
  }

  void _onDaySelected(DateTime? selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        if(selectedDay != null) {
          _selectedDay = DateTime.now();
          _selectedDay = selectedDay;

          print(_selectedDay);
          DateTime timeSeleccionado = DateTime(
              _selectedDay!.year, _selectedDay!.month, _selectedDay!.day);
          if (selectedDay == null) {
            print("ES VACIOOOOOOOOOO!!!!!!!");
          }
          else {
            print(widget.map[timeSeleccionado]);
            if (widget.map[timeSeleccionado] != null) {
              AsignacionTurno asignacion = widget.map[timeSeleccionado].first;
              String clave = asignacion.clave.toString();
              showDialog<String>(
                context: context,
                builder: (BuildContext context) =>
                    AlertDialog(
                        title: Text(
                            'Número de clave: ' + clave),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () =>
                                Navigator.pop(context, 'Cancel'),
                            child: const Text('Volver'),
                          ),
                          ElevatedButton(
                            child: Text("Detalles del cambio"),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.purple,
                            ),
                            onPressed: () =>  Navigator.push(context, MaterialPageRoute(builder: (context) => AcuerdosPersonales(asignacion))),),
                        ]
                    ),
              );
            }
        }
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
      body:  SingleChildScrollView(
        child:  Column(
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
                      calendarBuilders: CalendarBuilders(
                        defaultBuilder: (context, day, focusedDay) {
                          String? uid = FirebaseAuth.instance.currentUser?.uid;
                          for (DateTime d in widget.map.keys) {
                            AsignacionTurno asignacion = widget.map[d].first;
                            if (day.day == d.day &&
                                day.month == d.month &&
                                day.year == d.year && asignacion.idMaquinistaPide == uid)  {
                              return Container(
                                decoration: const BoxDecoration(
                                  color: Colors.green,
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
                              if(day.day == d.day &&
                                  day.month == d.month &&
                                  day.year == d.year && asignacion.idMaquinistaRealizaTurno == uid){
                                return Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
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
                        },
                      ),
                    onDaySelected: _onDaySelected,
                    //eventLoader: (day) {
                    //  return _getEventsForDay(day);
                    //},
                    calendarStyle: CalendarStyle(
                      isTodayHighlighted: true,
                      markerDecoration: BoxDecoration(
                        color:  Colors.green ,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(15))
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
                      Icon(Icons.calendar_today, color: Colors.red,),
                      Text("TRABAJAS", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Column(
                    children: [
                      Icon(Icons.calendar_today, color: Colors.green,),
                      Text("LIBRAS", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10,),
              /*
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
                    child: (widget.map.isNotEmpty) ? miCard() :
                    Center(
                        child: Text("No hay acuerdos")
                    )
                ),
              ),
              */
            ]
        )
      )
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

      if(widget.map[timeSeleccionado] != null){

        List<AsignacionTurno> asignacion = widget.map[timeSeleccionado];
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
                title: Text('Clave: ' + asignacion.first.clave.toString(),style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                leading: Image.asset('assets/descanso.png'),
                ),


              // Usamos una fila para ordenar los botones del card
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  ElevatedButton(
                    child: Text("Detalles del cambio"),
                        style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                        ),
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