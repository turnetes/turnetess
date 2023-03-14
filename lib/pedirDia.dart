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

class pedirDia extends StatefulWidget {

  _pedirDia createState() => _pedirDia();
}


class _pedirDia extends State<pedirDia> {




  String? idMaquinista = FirebaseAuth.instance.currentUser?.uid;
  CollectionReference listaTurnos = FirebaseFirestore.instance.collection(
      'turnos');
  String? apodoMaquinista;
  String? nombreMaquinista;
  late Timestamp fechaTurno;
  late int turnoElegido;
  int _myID = 0;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  late DateTime dia1,dia2;
  late CalendarBuilders controller;
  late String diaSemana;
  TextEditingController fechaController = TextEditingController();
  TextEditingController turnoController = TextEditingController();
  bool activar = false;
  bool cambioOk = false;



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

  Future<void> addTurno() async {

    int idTurno = await FirebaseFirestore.instance.collection('turnos').snapshots().length + 1;
    return listaTurnos.add({
      'idTurno': idTurno,
      'idMaquinista': idMaquinista,
      'num_turno': turnoElegido,
      'fecha': fechaTurno
    }).then((value) => print("Tuno añadido"))
        .catchError((error) => print("Failed to add user: $error"));
  }



  @override
  void initState() {
    _myID++;
    super.initState();
    turnoController.addListener(() {
      setState(() {
        activar = turnoController.text.isNotEmpty;
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

        return null;
      },
      onSaved: (value){
        turnoElegido = int.parse(value!);
        turnoController.text = value;

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

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("Peticion de dia"),
          backgroundColor: Colors.purple,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20,),
              turnoField,
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
              /*
            Container(
              child: InputDecorator(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.schedule, color: Colors.purple),
                  hintText: "dia seleccionado",
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      borderSide: BorderSide(color: Colors.purple, width: 5)
                  ),
                ),
                child: Text( sacarDiaSemana(_selectedDay)
                ),
              ),
            ),

             */
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
                onPressed: activar && _selectedDay != null ? () async {
                  print("TIENE QUE ENTRAR POR AQUI!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! PEDIR DIA" );
                  DateTime fecha = DateTime(_selectedDay!.year,_selectedDay!.month,_selectedDay!.day);
                  bool? comprobacionCorrecta = await comprobarOkPeticion(fecha);//Comprueba si has realizado ya una peticion
                  if(comprobacionCorrecta!){// No has pedido ya tu algun turno ese dia.
                    //FALTA!!!! QUE SI YA HAGO UN TURNO ESE DIA NO ME DEJE PEDIR OTRO DIA NO???? => ESTA AFIRMACION NO ES CORRECTA CREO... YO HAGO UN TURNO ESE DIA PERO ME HA SURGIDO UN PROBLEMA Y DEBERIA PODER PEDIRLO!
                    // SI TE CUBREN EL TURNO ESE DIA QUE ESTAS PIDIENDO YA CREO K SE HA EQUIVOCADO DE DIA DE PETICION NO TE DEBERIA DEJAR PEDIR UN TURNO QUE YA TE CUBREN no? => ESTO SI K TENGO K COMPROBARLO
                    bool? comprobacionCorrecta2 = await comprobarOkOfrecimiento(fecha);
                    if(comprobacionCorrecta2!){
                      turnoElegido = int.parse(turnoController.text);
                      showAlertResumenPeticionDia(turnoElegido,_selectedDay!);

                    }
                    else{
                      print("SHOWALERT1");
                      showAlert2();
                    }
                    //sube turno en Firebase

                    //actualizarContadorTurnos();
                    //NOTIFICAR AL RESTO DE DISPOSITIVOS QUE SE HA SOLICITADO UN TURNO

                    /*
                      print("La lista para jose es:");
                      for(int i=0; i < listaIDoneSignalDevices.length; i++){
                        print(listaIDoneSignalDevices[i]);
                      }

                     */

                  }
                  else{
                    print("SHOWALERT2");
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

  Future<bool?> comprobarOkOfrecimiento(DateTime fechaSeleccionada) async{
    bool teniaPeticion = true;
    var datos = await FirebaseFirestore.instance.collection(
        "listaOfrecimientos").get();
    //Antes de ver si cubro un turno ese dia, tengo k comprobar que no haya solicitado una peticion de turno ese mismo dia
    datos.docs.forEach((element) {
      if ((fechaSeleccionada.isAtSameMomentAs(element.data()['fecha'].toDate())) &&
          element.data()['idMaquinistaCandidato'] == idMaquinista){
        teniaPeticion = false;
      }

    });
    return teniaPeticion;
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

  Future<bool?> comprobarOkPeticion(DateTime fechaSeleccionada) async{
    LocalStorage storage = new LocalStorage('peticiones.json');
    await storage.ready;
    var str = await storage.getItem(idMaquinista!);
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
    return true;
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




  /*
  showAlert() {
    showDialog(
      context: context,
      builder: (context) {
        Future.delayed(
          Duration(seconds: 5),
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

   */

  showAlert2() {
    showDialog(
      context: context,
      builder: (context) {
        Future.delayed(
          Duration(seconds: 10),
              () {
            LocalStorage storage = new LocalStorage('peticiones.json');
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Peticiones4(storage)));
          },
        );

        return AlertDialog(
          title: Text('No puedes registrar dos peticiones el mismo dia. Borra la anterior si quieres registrar esta nueva.'),
        );
      },
    );
  }



  showAlertResumenPeticionDia (int clave, DateTime fecha) async{
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('RESUMEN PETICION:'),
          content: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Clave pedida:  " + clave.toString()
                  ),
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
                child: Text("Confirmar peticion"),
                style: ElevatedButton.styleFrom(
                  primary: Colors.purple,
                ),
                onPressed: () async{
                  await guardarPeticion(fecha);
                  await enviarNotificacion();
                  LocalStorage storage = new LocalStorage('peticiones.json');
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Peticiones4(storage)));
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

  String prepararNotificacion(String apodo,DateTime fechaTurno,int turno){
    return ("clave: " + turno.toString() +"\n"+
        "Fecha del turno: " + fechaTurno.day.toString() +"/"+ fechaTurno.month.toString() +"/"+ fechaTurno.year.toString());
  }

  String sacarGrafico(int clave) {
    dynamic i = (clave / 100);
    int x = i.toInt();
    switch (x) {
      case 1:
        return "Mañanas";
        break;
      case 2:
        return "General";
        break;
      case 3:
        return "Tardes";
        break;
      case 4:
        return "Villalba";
        break;
      case 5:
        return "Alcala";
        break;
      case 6:
        return "Principe pío";
        break;
      case 7 :
        return "Noche";
        break;
      default :
        return "Maniobras";
    }

  }

  guardarPeticion(DateTime fecha) async{
    String grafico = sacarGrafico(turnoElegido);
    FirebaseFirestore.instance.collection('listaPeticiones').add(
        {
          'idMaquinistaPide': idMaquinista,
          'fecha': fecha,
          'clave': turnoElegido,
          'gráfico': grafico,
          'idMaquinistaCandidato': null,
        }
    ).then((value){
      FirebaseFirestore.instance.collection('listaPeticiones').doc(value.id).set(
          {
            "idTurno" : value.id,
          },SetOptions(merge: true)).then((_){


        //showAlert();
      });
    });
  }

  enviarNotificacion() async{

    List<String>  listaIDoneSignalDevices = [];
    var collection = FirebaseFirestore.instance.collection('maquinistas');
    var querySnapshot = await collection.get();
    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data();
      var fooValue = data['oneSignalID'];
      //listaIDoneSignalDevices.add('"$fooValue"'.toString());
      listaIDoneSignalDevices.add(fooValue.toString());
    }
    String turno = prepararNotificacion("cmoreno",_selectedDay!,turnoElegido);
    //Este es el sendNotification bueno
    //sendNotification(listaIDoneSignalDevices,turno,"PETICION DE TURNO");
    sendNotification2(listaIDoneSignalDevices,turno,"PETICION DE TURNO",1);

  }

}

 */

