import 'dart:convert';
import 'package:http/http.dart';
import 'package:turnetes/Datos/MaquinistasDatos.dart';
import '../Modelos/ModeloTurno.dart';
import '../notificationApi.dart';

class NotificacionesControlador{

  static final NotificacionesControlador _NotificacionesControlador = NotificacionesControlador
      ._internal();


  factory NotificacionesControlador() {
    return _NotificacionesControlador;
  }

  NotificacionesControlador._internal();

  sendNotificationEveryDevices(DateTime fechaSeleccionada,String title) async{
    //NOTIFICAR AL RESTO DE DISPOSITIVOS QUE SE HA SOLICITADO UN TURNO
    //Tengo que llamar a MaquinistasDatos y pedirle la lista de tokens de todos los maquinistas
    MaquinistasDatos maquinistasDatos = MaquinistasDatos();
    List<String> listaTokensMaquinistas = await maquinistasDatos.getListaTokensMaquinistas();

    String turno = prepararNotificacion("cmoreno",fechaSeleccionada);

    sendNotification(listaTokensMaquinistas,turno,title,6);
  }

  sendNotificationOneDevice(String idMaquinistaRecibeMensaje,String mensaje,String title) async{
    //NOTIFICAR AL RESTO DE DISPOSITIVOS QUE SE HA SOLICITADO UN TURNO
    //Tengo que llamar a MaquinistasDatos y pedirle el token de 1 maquinista solo
    MaquinistasDatos maquinistasDatos = MaquinistasDatos();
    List<String> listaToken = [];
    String? token = await maquinistasDatos.getTokenCandidato(idMaquinistaRecibeMensaje);
    listaToken.add(token.toString());
    print("TOKEN: " +listaToken.first.toString());
    sendNotification(listaToken,mensaje,title,3);

    /*
    //Recordatorio el dia de antes:
    await NotificationApi.showScheduledNotification(
        title: "RECORDATORIO",
        body: "Mañana te cubren el turno: "+ turnoPedido.clave.toString() +". No esta de más que os lo recordeis." ,
        scheduleDate: turnoPedido.fecha.add(const Duration(days: -1))
    );

     */

  }

  String infoTurno(ModeloTurno turno){
    return "TE CUBREN LA CLAVE: "+ turno.clave.toString() + "DEL DIA: "+  turno.fecha.day.toString() +"/"+ turno.fecha.month.toString() +
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

        "headings": {"en": heading},

        "contents": {"en": contents},

        "data":  {"en": clave},


      }),
    );
  }

  String prepararNotificacion(String apodo,DateTime fechaTurno){
    return ( "Fecha del turno: " + fechaTurno.day.toString() +"/"+ fechaTurno.month.toString() +"/"+ fechaTurno.year.toString());
  }



}