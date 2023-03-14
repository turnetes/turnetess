
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:turnetes/Controladores/AsignacionesControlador.dart';
import 'package:turnetes/Modelos/ModeloAsignacion.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'dart:math';
import 'dart:io' as IO;
import '../Modelos/ModeloMaquinista.dart';




class AsignacionAcuerdoPersonalVista extends StatefulWidget{

  ModeloAsignacion asignacion;
  ModeloMaquinista? maquinista;
  //BuildContext context;

  AsignacionAcuerdoPersonalVista(this.asignacion,this.maquinista);
  _AsignacionAcuerdoPersonalVista createState() => _AsignacionAcuerdoPersonalVista();

}

class _AsignacionAcuerdoPersonalVista extends State<AsignacionAcuerdoPersonalVista>{


  @override
  Widget build(BuildContext context) {
    print("USUARIO ACTUAL CLAVE=" + FirebaseAuth.instance.currentUser.toString());
    print("USUARIO ACTUAL CLAVE=" + widget.asignacion.fechadiaTurno.day.toString() + widget.asignacion.fechadiaTurno.month.toString());


    return Scaffold(
      appBar: AppBar(
          title: (FirebaseAuth.instance.currentUser?.uid == widget.asignacion.idMaquinistaPide) ? Text("Te hacen el turno...") : Text("Le haces el turno..."),
          backgroundColor: Colors.purple,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: (){
              Navigator.of(context).pop();
            },
          )
      ),
      body: Column(
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
                        child: Text(widget.asignacion.clave.toString(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
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
                      child: TableCalendar(locale: 'es_ES',selectedDayPredicate: (day) =>isSameDay(day, widget.asignacion.fechadiaTurno),focusedDay: widget.asignacion.fechadiaTurno, firstDay: DateTime(2021), lastDay: DateTime(2025), startingDayOfWeek: StartingDayOfWeek.monday,
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
                                Text(widget.maquinista!.nombre, style: TextStyle(fontSize: 15)),
                                SizedBox(height: 16,),

                                Text("Apodo:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                SizedBox(height: 4,),
                                Text(widget.maquinista!.apodo, style: TextStyle(fontSize: 15)),
                                SizedBox(height: 16,),

                                Text("Teléfono interior:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                SizedBox(height: 4,),
                                Text(widget.maquinista!.telefonoInt, style: TextStyle(fontSize: 15)),
                                SizedBox(height: 16,),
                                Text("Teléfono exterior:", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                SizedBox(height: 4,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(widget.maquinista!.telefonoExt + "       ", style: TextStyle(fontSize: 20)),
                                    SizedBox(height: 16),
                                    IconButton(
                                      onPressed: () async{
                                        String url;
                                        var prefijo = "34";
                                        var phone = prefijo+widget.maquinista!.telefonoExt;
                                        var message = "Hola compañero soy " + widget.maquinista!.apodo+".......";
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
                                    image: elegirImagen(widget.maquinista!.imagePath),
                                  ),
                                )
                              ],
                            )
                          ]
                      ),
                    ),
                  ),

                  (widget.asignacion.fechadiaTurno.isAfter(DateTime.now())) ? ElevatedButton(
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
                                        'Al final no se realiza el turno. Estas completamente seguro?'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, 'Cancel'),
                                        child: const Text('Cancel'),
                                      ),

                                      TextButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.purple,
                                          ),
                                          child: const Text('Confirmar Eliminación', style: TextStyle(color: Colors.white),),
                                          onPressed: () async {
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                            AsignacionesControlador asignacionesControlador = AsignacionesControlador();
                                            asignacionesControlador.eliminarAsignacionCalendario(context,widget.asignacion);

                                          }

                                      ),


                                    ]
                                )
                        );


                      }

                  ) : Center(),

                ],
              )
    );
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
