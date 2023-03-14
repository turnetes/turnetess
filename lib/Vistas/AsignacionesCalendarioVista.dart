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
import 'package:turnetes/Modelos/ModeloMaquinista.dart';


import '../Controladores/AsignacionesControlador.dart';
import '../DrawerWidget.dart';
import '../Modelos/ModeloAsignacion.dart';
import '../acuerdosPersonales.dart';

class AsignacionesCalendarioVista extends StatefulWidget{

  Map<DateTime, dynamic> map = {};

  AsignacionesCalendarioVista(this.map);


  _AsignacionesCalendarioVista createState() => _AsignacionesCalendarioVista();
}

class _AsignacionesCalendarioVista extends State<AsignacionesCalendarioVista> {

  DateTime? _selectedDay;
  DateTime _focusedDay = DateTime.now();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Mis Acuerdos'),
          backgroundColor: Colors.purple,
        ),
        drawer: DrawerWidget(),
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
                            print("TAMAÑOOOOO:    " + widget.map.keys.length
                                .toString());
                            print("TAMAÑOOOOO:    " + widget.map.keys.toString());
                            for (var d in widget.map.keys) {
                              if(widget.map[d].length > 1){
                                print("TAMAÑOOOOOWENO:    " + widget.map[d].length.toString());
                                ModeloAsignacion asignacion = widget.map[d].first;
                                print("A VER QUE TE VEA:    " + asignacion.toString());
                                if (day.day == d.day && day.month == d.month && day.year == d.year && (asignacion.idMaquinistaRealizaTurno == uid || asignacion.idMaquinistaPide == uid)) {
                                  print("SI QUE ENTRA POR AQUI!!!!");
                                  return Container(
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        top: BorderSide(color: Colors.red, width: 10, style: BorderStyle.solid),
                                        right: BorderSide(color: Colors.red, width: 10, style: BorderStyle.solid),
                                        bottom: BorderSide(color: Colors.green, width: 10, style: BorderStyle.solid),
                                        left: BorderSide(color: Colors.green, width: 10, style: BorderStyle.solid),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${day.day}',
                                        style: const TextStyle(
                                            color: Colors.black),
                                      ),
                                    ),
                                  );
                                }
                              }
                              else{ //Solo tiene un elemento
                                ModeloAsignacion asignacion = widget.map[d].first;
                                if (day.day == d.day &&
                                    day.month == d.month &&
                                    day.year == d.year && asignacion.idMaquinistaPide == uid) {
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
                            }
                            // */
                            return null;
                          },
                        ),
                        onDaySelected: _onDaySelected,
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
                ]
            )
        )
    );
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
              if(widget.map[timeSeleccionado].length > 1){
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Tienes varios cambios este día:'),
                        content: Container(
                          width: double.minPositive,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: widget.map[timeSeleccionado].length,
                            itemBuilder: (BuildContext context, int index) {
                              ModeloAsignacion asignacion =  widget.map[timeSeleccionado][index];
                              return ListTile(
                                  title: Text( (index+1).toString()+"/ "+
                                      asignacion.clave.toString()),
                                  onTap: () {
                                    //Navigator.pop(context, colorList[index]);
                                    //Navigator.push(context, MaterialPageRoute(builder: (context) => AcuerdosPersonales(asignacion)));
                                  },
                                  onLongPress: () async{
                                    AsignacionesControlador asignacionesControlador = AsignacionesControlador();
                                    late String idOtroMaquinista;
                                    String? idPropio = FirebaseAuth.instance.currentUser?.uid;
                                    if(asignacion.idMaquinistaPide == idPropio){
                                      idOtroMaquinista = asignacion.idMaquinistaRealizaTurno;
                                    }
                                    else{
                                      idOtroMaquinista = asignacion.idMaquinistaPide;
                                    }
                                    asignacionesControlador.launchAcuerdosPersonalesVista(context, asignacion, idOtroMaquinista);
                                  }
                              );
                            },
                          ),
                        ),
                      );
                    }
                );
              }
              else{
                ModeloAsignacion asignacion = widget.map[timeSeleccionado].first;
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
                              onPressed: () async{
                                AsignacionesControlador asignacionesControlador = AsignacionesControlador();
                                late String idOtroMaquinista;
                                String? idPropio = FirebaseAuth.instance.currentUser?.uid;
                                if(asignacion.idMaquinistaPide == idPropio){
                                  idOtroMaquinista = asignacion.idMaquinistaRealizaTurno;
                                }
                                else{
                                  idOtroMaquinista = asignacion.idMaquinistaPide;
                                }
                                asignacionesControlador.launchAcuerdosPersonalesVista(context, asignacion, idOtroMaquinista);

                              }),
                          ]
                      ),
                );
              }
            }
          }


        }
        _focusedDay = focusedDay;
      });
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
