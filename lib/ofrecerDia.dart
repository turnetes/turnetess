/*
import 'dart:async';
import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:localstorage/localstorage.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:turnetes/ModeloTurno.dart';
import 'package:http/http.dart';
import 'package:turnetes/localNotification.dart';
import 'package:turnetes/notificationApi.dart';
import 'package:turnetes/peticiones4.dart';
import 'package:turnetes/secondScreen.dart';
import 'Modelos/ModeloMaquinista.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:flutter/src/services/text_formatter.dart';

import 'ofrecimientos.dart';

class ofrecerDia extends StatefulWidget {

  _ofrecerDia createState() => _ofrecerDia();
}


class _ofrecerDia extends State<ofrecerDia> {




  String? idMaquinista = FirebaseAuth.instance.currentUser?.uid;
  CollectionReference listaTurnos = FirebaseFirestore.instance.collection(
      'turnos');
  String? apodoMaquinista;
  String? nombreMaquinista;
  late Timestamp fechaTurno;
  late String franjaTurno;
  int _myID = 0;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  late DateTime dia1,dia2;
  late CalendarBuilders controller;
  late String diaSemana;
  TextEditingController fechaController = TextEditingController();
  TextEditingController franjaController = TextEditingController();
  bool activar = false;
  String selectval = "Mañanas Mañanas";



  void callDatePicker() async {
    DateTime? actualselectedFecha = await getDatePickerwidget();
    setState(() {
      fechaTurno = Timestamp.fromDate(actualselectedFecha!);
    });
  }

  Future <DateTime?> getDatePickerwidget() {
    return showDatePicker(context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2021),
        lastDate: DateTime(2030),
        builder: (context, child) {
          return Theme(data: ThemeData.dark(), child: child!);
        }
    );
  }



  @override
  void initState() {
    _myID++;
    super.initState();
    franjaController.addListener(() {
      setState(() {
        activar = franjaController.text.isNotEmpty;
      });
    });
    build(context);
    NotificationApi.init();
    listenNotifications();
  }

  void listenNotifications() => NotificationApi.onNotifications.stream.listen(onClickedNotification);

  void onClickedNotification(String? payload) => Navigator.of(context).push(MaterialPageRoute(builder: (context) => SecondScreen(payload: payload),
  ));

  @override
  Widget build(BuildContext context) {


    final fechaField =TextFormField(
      autofocus: false,
      controller: fechaController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value){
        if(value!.isEmpty || value == null){
          return 'fecha no introducida';
        }
        return null;
      },
      onSaved: (value){
        value = sacarDiaSemana(_selectedDay);
        fechaController.text = sacarDiaSemana(_selectedDay);
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.schedule, color: Colors.purple),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "fecha",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )
      ),
    );

    final turnoField =TextFormField(
      autofocus: false,
      controller: franjaController,
      autovalidateMode: AutovalidateMode.always,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly
      ],
      onSaved: (value){
        franjaController.text = value!;

      },
    );

    List<String> listitems = ["Mañanas Mañanas", "General", "Tardes Tardes", "Villalba", "Alcala", "P.Pio", "Noche", ];


    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("Ofrecer dia"),
          backgroundColor: Colors.purple,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 40,),
              Container(
                child: InputDecorator(
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        borderSide: BorderSide(color: Colors.purple, width: 5),
                      ),
                      labelText: 'Selecciona día del turno:', labelStyle: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)
                  ),
                  child:
                  TableCalendar(locale: 'es_ES',selectedDayPredicate: (day) =>isSameDay(day, _selectedDay),focusedDay: _focusedDay, firstDay: DateTime.now(), lastDay: DateTime(2025), startingDayOfWeek: StartingDayOfWeek.monday,
                    onDaySelected: _onDaySelected,
                    headerStyle: HeaderStyle(titleCentered: true, formatButtonVisible: false, decoration: BoxDecoration(color: Colors.white10)),
                    calendarBuilders: CalendarBuilders(
                      selectedBuilder: (context, date, events) => Container(
                          margin: const EdgeInsets.all(4.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
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
                          )),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40,),
              Container(
                child: InputDecorator(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.schedule, color: Colors.purple),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          borderSide: BorderSide(color: Colors.purple, width: 5)
                      ),
                      labelText: 'Selecciona franja Horaria:', labelStyle: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)
                  ),
                  child: DropdownButton(
                    value: selectval,
                    onChanged: (value){
                      setState(() {
                        selectval = value.toString();
                        franjaController.text = selectval;
                      });
                    },
                    items: listitems.map((itemone){
                      return DropdownMenuItem(
                          value: itemone,
                          child: Text(itemone)
                      );
                    }).toList(),
                  ),
                ),
              ),

              SizedBox(height: 20,),




              ElevatedButton(
                child: Text('Pedir el día'),
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder()),
                  padding: MaterialStateProperty.all(EdgeInsets.all(20)),
                  backgroundColor: MaterialStateProperty.all(Colors.red), // <-- Button color
                  overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
                    if (states.contains(MaterialState.pressed)) return Colors.blue; // <-- Splash color
                  }),
                ),
                onPressed:  _selectedDay != null && franjaController.text.isNotEmpty ? () async {
                  print("TIENE QUE ENTRAR POR AQUI!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! PEDIR DIA" );
                  DateTime fecha = DateTime(_selectedDay!.year,_selectedDay!.month,_selectedDay!.day);
                  bool? comprobacionCorrecta = await comprobarOkOfrecimiento(fecha);//Comprueba si has realizado ya una peticion
                  if(comprobacionCorrecta!){// No has pedido ya tu algun turno ese dia.
                    bool? comprobacionCorrecta2 = await comprobarOkPeticion(fecha);
                    if(comprobacionCorrecta2!){
                      showAlert3();
                      //sube ofrecimiento en Firebase
                      FirebaseFirestore.instance.collection('listaOfrecimientos').add(
                          {

                            'clave': null,
                            'fecha': fecha,
                            'idMaquinistaCandidato': idMaquinista,
                            'idMaquinistaPide': null,
                            'grafico': franjaController.text,

                          }
                      ).then((value){
                        FirebaseFirestore.instance.collection('listaOfrecimientos').doc(value.id).set(
                            {
                              "idTurno" : value.id,
                            },SetOptions(merge: true)).then((_){


                          //showAlert();
                        });
                      });
                      //actualizarContadorTurnos();
                      //NOTIFICAR AL RESTO DE DISPOSITIVOS QUE SE HA SOLICITADO UN TURNO
                      List<String>  listaIDoneSignalDevices = [];
                      var collection = FirebaseFirestore.instance.collection('maquinistas');
                      var querySnapshot = await collection.get();
                      for (var doc in querySnapshot.docs) {
                        Map<String, dynamic> data = doc.data();
                        var fooValue = data['oneSignalID'];
                        //listaIDoneSignalDevices.add('"$fooValue"'.toString());
                        listaIDoneSignalDevices.add(fooValue.toString());

                      }
                      print("La lista para jose es:");
                      for(int i=0; i < listaIDoneSignalDevices.length; i++){
                        print(listaIDoneSignalDevices[i]);
                      }

                      List<String> listaIDoneSignalDevices2 = ["c464a3e7-38ea-433c-b0ae-1fe7bf658383","1ffa15b7-0c6e-4f90-a841-5bc98ebf54d6"];




                      String turno = prepararNotificacion("cmoreno",_selectedDay!);
                      //Este es el sendNotification bueno
                      //sendNotification(listaIDoneSignalDevices,turno,"PETICION DE TURNO");
                      sendNotification2(listaIDoneSignalDevices,turno,"OFRECIMIENTO DE TURNO",6);

                    }
                    else {
                      showAlert2();
                    }
                    //FALTA!!!! QUE SI YA HAGO UN TURNO ESE DIA NO ME DEJE PEDIR OTRO DIA NO???? => ESTA AFIRMACION NO ES CORRECTA CREO... YO HAGO UN TURNO ESE DIA PERO ME HA SURGIDO UN PROBLEMA Y DEBERIA PODER PEDIRLO!
                    // SI TE CUBREN EL TURNO ESE DIA QUE ESTAS PIDIENDO YA CREO K SE HA EQUIVOCADO DE DIA DE PETICION NO TE DEBERIA DEJAR PEDIR UN TURNO QUE YA TE CUBREN no? => ESTO SI K TENGO K COMPROBARLO

                  }
                  else{
                    showAlert2();
                  }
                }
                    : null,    // Esto provoca que el boton este anulado hasta que introoduzca fecha y turno
              ),

            ],
          ),
        )
    );
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        if(selectedDay != null){
          _selectedDay = selectedDay;
          print(_selectedDay);
          sacarDiaSemana(_selectedDay!);
        }
        else{
          print("ES NULO CABEZON!!!!");
        }

        _focusedDay = focusedDay;
      });
    }
  }

  Future<bool?> comprobarOkOfrecimiento(DateTime fechaSeleccionada) async{
    LocalStorage storage = new LocalStorage('ofrecimientos.json');
    await storage.ready;
    var str = await storage.getItem('mapOfrecimientos');
    if(str != null){
      Map<String, List<dynamic>?> mapDecodificado = Map.castFrom(await json.decode(str));
      if(mapDecodificado.isNotEmpty ) {
        for(List<dynamic>? v in mapDecodificado.values){
          if(v!= null){
            if(v.isNotEmpty){
              print("NO ES NULL V");
              print(v.toString());
              if(v[0] ==  fechaSeleccionada.toString()){
                if(v[1] == idMaquinista){
                  return false;
                }
              }
            }
          }
        }
      }
    }
    return true;
  }

  Future<bool?> comprobarOkPeticion(DateTime fechaSeleccionada) async{
    bool teniaPeticion = true;
    var datos = await FirebaseFirestore.instance.collection(
        "listaPeticiones").get();
    //Antes de ver si cubro un turno ese dia, tengo k comprobar que no haya solicitado una peticion de turno ese mismo dia
    datos.docs.forEach((element) {
      if ((fechaSeleccionada.isAtSameMomentAs(element.data()['fecha'].toDate())) &&
          element.data()['idMaquinistaPide'] == idMaquinista){
        teniaPeticion = false;
      }

    });
    return teniaPeticion;
  }


  /*
  METER ESTO EN EL CODIGO!!!!!!!!!
  Future<bool?> getYaMeCubriaTurnoEseDia(String? id,Turno turno) async {//QUE NO ES LO MISMO QUE HABER SOLICITADO TURNO ESE DIA sINO K YA ME LO CUBREN
    bool haceTurno = false;
    var datos = await FirebaseFirestore.instance.collection(
        "listaAsignacionesTurnos").get();
    //Antes de ver si cubro un turno ese dia, tengo k comprobar que no haya solicitado una peticion de turno ese mismo dia
    datos.docs.forEach((element) {
      if ((turno.fecha.isAtSameMomentAs(element.data()['fechadiaTurno'].toDate())) &&
          element.data()['idMaquinistaRealizaTurno'] == id){
        print("SE CUMPLEEEEEEEE MAQUINISTA YA ME CUBREN ESE DIA");
        haceTurno = true;
      }

    });
    return haceTurno;
  }

   */




  showAlert() {
    showDialog(
      context: context,
      builder: (context) {
        Future.delayed(
          Duration(seconds: 1),
              () {

            LocalStorage storage = new LocalStorage('peticiones.json');
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Peticiones4(storage)));
          },
        );

        return AlertDialog(
          title: Text('Petición registrada. Suerte'),
        );
      },
    );
  }

  showAlert2() {
    showDialog(
      context: context,
      builder: (context) {
        Future.delayed(
          Duration(seconds: 10),
              () {
            LocalStorage storage = new LocalStorage('ofrecimientos.json');
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Ofrecimientos(storage)));
          },
        );

        return AlertDialog(
          title: Text('Ya te habias ofrecido a trabajar este día.'),
        );
      },
    );
  }

  showAlert3() {
    showDialog(
      context: context,
      builder: (context) {
        Future.delayed(
          Duration(seconds: 5),
              () {
          },
        );

        return AlertDialog(
          title: Text('Ofrecimiento registrado'),
        );
      },
    );
  }



  showAlertResumenOfrecimientoDia(int clave, DateTime fecha) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('RESUMEN OFRECIMIENTO:'),
          content: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text( "Día de petición:  "+ fecha.day.toString() +" / "+ fecha.month.toString()+ " / "+ fecha.year.toString()
                  )
                ]
            ),
          ),
          actions:<Widget>[
            TextButton(
              onPressed: () =>
                  Navigator.pop(context, 'Cancel'),
              child: const Text('Volver'),
            ),
            ElevatedButton(
                child: Text("Confirmar ofrecimiento"),
                style: ElevatedButton.styleFrom(
                  primary: Colors.purple,
                ),
                onPressed: () {

                  LocalStorage storage = new LocalStorage('ofrecimientos.json');
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Ofrecimientos(storage)));
                }
            ),
          ],

        );
      },
    );
  }

  /*

  Future<bool?> comprobarMaq(String? idSolicitaPeticionTurno) async {
    bool haceTurno = false;
    var datos = await FirebaseFirestore.instance.collection(
        "listaAsignacionesTurnos").get();
    //Antes de ver si cubro un turno ese dia, tengo k comprobar que no haya solicitado una peticion de turno ese mismo dia
    datos.docs.forEach((element) {
      if ((turno.fecha.isAtSameMomentAs(element.data()['fechadiaTurno'].toDate())) &&
          element.data()['@@@@@@@@@@'] == idSolicitaPeticionTurno){
        print("SE CUMPLEEEEEEEE MAQUINISTA YA LE HACIAN ESE DIA");
        haceTurno = true;
      }

    });
    return haceTurno;
  }

   */


  String sacarDiaSemana(DateTime? date2) {
    late String resp;
    if(date2 == null){
      return "dia no seleccionado";
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
      return dia +" "+ date2.day.toString() +"/"+ date2.month.toString() +"/"+ date2.year.toString() ;
    }
  }

  void actualizarContadorTurnos(){
    int i = 0;
    //obtiene el valor
    FirebaseFirestore.instance.collection('sistema').doc('variablesGlobales').get().then((value){
      i = (value.data()!["totalTurnos"]);
      i++;
      print("HOLAAAAAA3!!!: " + i.toString());
      FirebaseFirestore.instance.collection('sistema').doc('variablesGlobales').update({"totalTurnos": i}).then((_) {print("HOLA15");print (i);});
    });
    //FirebaseFirestore.instance.collection('sistema').doc('variablesGlobales').update({"totalTurnos": i}).then((_) {print("HOLA15");print (i);});
  }

  Future<Response> sendNotification(List<String> tokenIdList, String contents, String heading) async{

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

        "small_icon":"ic_stat_onesignal_default",

        "large_icon":"https://www.filepicker.io/api/file/zPloHSmnQsix82nlj9Aj?filename=name.jpg",

        "headings": {"en": heading},

        "contents": {"en": contents},


      }),
    );
  }

  Future<Response> sendNotification2(List<String> tokenIdList, String contents, String heading,int clave) async{

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

        //"buttons": [{"id": "id1", "text": "Ir a mis peticiones", "icon": "ic_menu_share"}],

      }),
    );
  }

  String prepararNotificacion(String apodo,DateTime fechaTurno){
    return ( "Fecha del turno: " + fechaTurno.day.toString() +"/"+ fechaTurno.month.toString() +"/"+ fechaTurno.year.toString());
  }
/*
  Future<int> getIdTurnos() async{
    int i = 0;
    await FirebaseFirestore.instance.collection('turnos').get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        i++;;
      });
    });
    return i+1;
  }

   */
}


 */