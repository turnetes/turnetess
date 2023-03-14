import 'dart:io';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:localstorage/localstorage.dart';
import 'package:intl/intl.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'dart:convert';

/*
class Datos {

  static final Datos _datos = Datos._internal();


  factory Datos() {
    return _datos;
  }

  Datos._internal();


  //String? idMaquinistaPropio;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore instance = FirebaseFirestore.instance;
  LocalStorage storage = new LocalStorage('peticiones.json');
  late UserCredential? user;

  //Future<List<Turno>?> listaPeticiones;


  Future<UserCredential> getUserValido(String mail, String pass) async {
    return await auth.signInWithEmailAndPassword(email: mail, password: pass);
  }


  Future<List<Turno>?> pasarListaTurnos(String tipo) async {
    //var datos2 = await instance.collection("listaPeticiones").doc().get();
    var datos2 = await instance.collection(tipo).get();
    List<QueryDocumentSnapshot> datos3 = datos2.docs;
    if(datos3 != null) {print(datos3.toString());}

    List<Turno> listaTurnosMostrar = [];

    // Lista guarda en almacenamiento local todas las peticiones incluidos los que tengo candidatos para uso en comprobacion en pedirDia
    List<Turno> listaTurnosTotales = [];
    print(datos3.first.get('idMaquinistaPide'));
    for(int i = 0; i < datos3.length; i++) {
      if (DateTime.now().isBefore(datos3[i].get('fecha').toDate())) {
        print("ENTRA POR CONTROL!");
        print(datos3[i].get('clave'.toString()));
        print(datos3[i].get('fecha'.toString()));
        print(datos3[i].get('gráfico'.toString()));
        print(datos3[i].get('idMaquinistaCandidato'.toString()));
        print(datos3[i].get('idMaquinistaPide'.toString()));
        print(datos3[i].get('idTurno'.toString()));
        Turno turno = Turno(
          datos3[i].get('clave'),
          datos3[i].get('fecha').toDate(),
          datos3[i].get('gráfico'),
          datos3[i].get('idMaquinistaCandidato'),
          datos3[i].get('idMaquinistaPide'),
          datos3[i].get('idTurno'),
        );
        if (datos3[i].get('idMaquinistaCandidato') == null) {
          listaTurnosMostrar.add(turno);
        }
        else {
          print("TURNOS QUE NO SON NULL = " +
              turno.idMaquinistaCandidato.toString());
        }
        listaTurnosTotales.add(turno);
      }
    }

    print("TAMAÑOOO   LISTA TURNOS TOTALES = " +
        listaTurnosTotales.length.toString());
    print("TAMAÑOOO   LISTA TURNOS MOSTRAR = " +
        listaTurnosMostrar.length.toString());

    //DESERIALIZAMOS EL MAP que tenemos en almacenamiento local
    peticionesDesSerializar(listaTurnosMostrar);

    //SERIALIZAMOS
    peticionesSerializar(listaTurnosTotales);


    print("A VER SI ME MUESTRA ESTA LISTA: " +listaTurnosMostrar.toString()) ;
    return ordenarTurnos(listaTurnosMostrar);
  }

  List<Turno>? ordenarTurnos(List<Turno> lista) {
    lista.sort((a, b) {
      int aDate = a.fecha.microsecondsSinceEpoch;
      int bDate = b.fecha.microsecondsSinceEpoch;
      return aDate.compareTo(bDate);
    });
    print("A VER SI ME MUESTRA ESTA LISTA2: " + lista.toString()) ;
    return lista;

  }


  void peticionesDesSerializar(List<Turno> listaTurnosMostrar) async{
    String id =auth.currentUser!.uid;
    if(id == null){print("EL ID ES NULLL");}
    print("EL ID PARA EL JSON ES: " + id);
    var str2 = await storage.getItem(auth.currentUser!.uid);
    if (str2 != null) {
      Map<String, List<dynamic>?> datosDesCodificados2 = Map.castFrom(await json.decode(str2));
      if (datosDesCodificados2.isNotEmpty) {
        for (int i = 0; i < listaTurnosMostrar.length; i ++) {
          if (datosDesCodificados2.containsKey(listaTurnosMostrar[i].idTurno)) {
            listaTurnosMostrar[i].setVisto();
          }
        }
        print("DATOS DESCODIFICADOS: " + datosDesCodificados2.toString());
      }
    }
  }

  void peticionesSerializar(List<Turno> listaTurnosTotales) async{
    List<dynamic>? listaTurnos = [];
    Map<String, List<dynamic>> mapGuardarJson = {};
    for (int i = 0; i < listaTurnosTotales.length; i ++) {
      listaTurnos = [];
      //Guardo todos los IdTurnosys como keys pero solo guardo la lista no vacia si es el que Pide
      if (listaTurnosTotales[i].idMaquinistaPide == auth.currentUser!.uid) {
        DateTime fechaString = DateTime(
            listaTurnosTotales[i].fecha.year, listaTurnosTotales[i].fecha.month,
            listaTurnosTotales[i].fecha.day);
        String fechaString2 = fechaString
            .toString(); // Json no admite DateTime por eso lo paso a String
        listaTurnos.add(fechaString2);
        listaTurnos.add(listaTurnosTotales[i].idMaquinistaPide);
        listaTurnos.add(listaTurnosTotales[i].idMaquinistaCandidato);
        //FORMATO DE LA LISTA ES: [FECHA, MAQUINISTA PIDE, MAQUINISTA CANDIDATO]

      }
      print("SEGUIMOSS2.....");
      //mapGuardarJson.addAll({listaTurnosTotales[i].idTurno : listaTurnos!});
      mapGuardarJson[listaTurnosTotales[i].idTurno] = listaTurnos;
      print("SEGUIMOSS.....5");
    }
    print("TAMAÑO DE MAP GUARDAR MAP@@@@@@@ = " +
        mapGuardarJson.length.toString());
    String guardarMap = json.encode(mapGuardarJson);
    print("LLEGA HASTA STORAGE");
    await storage.setItem(auth.currentUser!.uid, guardarMap);
    print("SALE DE HASTA STORAGE");
  }


  //CONTROL LOGIN:
  Future<User?> checkUser(mail,pass) async {
    user = await auth.signInWithEmailAndPassword(email: mail, password: pass);
    return user!.user;
  }

  saveJsonRememberMe(List<String> usuario) async {
    String reg = await json.encode(usuario);
    await storage.setItem('user', reg);
    print("JSON GUARDADO");

  }

  deleteJsonRememberMe() async{
    await storage.deleteItem('user');
  }

  eventSaveTokenNotification() async {
    final status = await OneSignal.shared.getDeviceState();
    FirebaseFirestore.instance.collection("maquinistas").doc(user?.user!.uid).set(
        {
          'oneSignalID':  status!.userId,
        },SetOptions(merge: true)).then((_){
      //showAlert();
      //showAlert15(); //DISPARAR USUARIO REGISTRADO PERO AQUI NO
    });

  }

  eventLogOutUser() async {
    auth.signOut();
    LocalStorage storage = new LocalStorage('peticiones.json');
    await storage.ready;
    storage.deleteItem('user');
  }

  Future<User?> eventRegisterUser(String mail, String pass) async {
    print("USUARIO = " + mail);
    print("USUARIO = " + pass);
    print("USUARIO = " + pass);
    late UserCredential? usuario;
    try{
      usuario = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: mail, password: pass);
    } catch (e) {
      return null;
    }
    if(usuario != null){
      print("USUARIO NO NULL");
      return usuario.user;
    }
    else{
      print("USUARIO = NO NULL");

    }
  }

  eventRegisterUserFirebase(String id,String nombre,String apodo,String mail,String pathImagen,String oneSignalID,String telfInt,String telfExt) async{
    await FirebaseFirestore.instance.collection(
        "maquinistas").doc(id).set(
        {
          'apodo': apodo,
          'contadorFestivos': 0,
          'contadorTurnos': 0,
          'correo': mail,
          'idMaquinista': id,
          'imagePath': pathImagen,
          'nombre': nombre,
          'oneSignalID': oneSignalID,
          'passAdmin': false,
          'telfInt': telfInt,
          'telfExt': telfExt
        }
    ).then((id) {
      print("success ESTE WENO2!");
    });
  }


  //PEDIR DIA!!!

  Future<bool> checkRestriccion1Json(DateTime fechaSeleccionada) async{
    LocalStorage storage = new LocalStorage('peticiones.json');
    String idMaquinista = auth.currentUser!.uid;
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



  guardarPeticion(DateTime fecha, int turnoElegido) async{
    String? idMaquinista = FirebaseAuth.instance.currentUser?.uid;
    String grafico = sacarGrafico(turnoElegido);
    FirebaseFirestore.instance.collection('listaPeticiones').add(
        {
          'clave': turnoElegido,
          'fecha': fecha,
          'gráfico': grafico,
          'idMaquinistaPide': idMaquinista,
          'idMaquinistaCandidato': null,
        }
    ).then((value) async {
      await FirebaseFirestore.instance.collection('listaPeticiones').doc(value.id).set(
          {
            "idTurno" : value.id,
          },SetOptions(merge: true)).then((_){


        //showAlert();
      });
    });
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


  //CALENDARIO MIS PETICIONES/OFRECIMIENTOS:
  Future<Map<DateTime, dynamic>> getMapCalendarioPeticiones() async {
    Map<DateTime, dynamic> map = {};
    var datosPeticiones = await FirebaseFirestore.instance.collection(
        "listaPeticiones").get();
    var datosOfrecimientos = await FirebaseFirestore.instance.collection(
        "listaOfrecimientos").get();
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    List<Turno> listaTurnos = [];
    if (datosPeticiones.size != 0) {
      print("ALGUNO CUMPLE@@@@@@@ ENTRA POR AQUIIIII!!!!");
      for (int i = 0; i < datosPeticiones.docs.length; i++) {
        Turno turno = Turno(
          datosPeticiones.docs[i].data()['clave'],
          datosPeticiones.docs[i].data()['fecha'].toDate(),
          datosPeticiones.docs[i].data()['grafico'],
          datosPeticiones.docs[i].data()['idMaquinistaCandidato'],
          datosPeticiones.docs[i].data()['idMaquinistaPide'],
          datosPeticiones.docs[i].data()['idTurno'],
        );
        print(turno.idTurno.toString());
        if (turno.idMaquinistaPide == uid) {
          print("ALGUNO CUMPLE@@@@@@@ ENTRA POR AQUIIIII2!!!!");
          print("ALGUNO CUMPLE@@@@@@@");
          if (turno.fecha.isAfter(DateTime.now())) {
            DateTime time = datosPeticiones.docs[i].data()['fecha'].toDate();
            DateTime time2 = DateTime(time.year, time.month, time.day);
            map[time2] = turno;
          }
          else {
            //tendre que borrar las peticiones en Firebase que se hayan pasado de fecha porque ya no me interesa guardarlas
            deleteTurnoPedidoPeticiones(turno.idTurno);
          }
        }
      }
    }
    if (datosOfrecimientos.size != 0) {
      for (int i = 0; i < datosOfrecimientos.docs.length; i++) {
        Turno turno = Turno(
          datosOfrecimientos.docs[i].data()['clave'],
          datosOfrecimientos.docs[i].data()['fecha'].toDate(),
          datosOfrecimientos.docs[i].data()['grafico'],
          datosOfrecimientos.docs[i].data()['idMaquinistaCandidato'],
          datosOfrecimientos.docs[i].data()['idMaquinistaPide'],
          datosOfrecimientos.docs[i].data()['idTurno'],
        );
        print("AHORA VAMOS CON LOS OFRECIMIENTOS");
        print(turno.idTurno.toString());
        print(uid!);
        if (turno.idMaquinistaCandidato == uid) {
          print("ALGUNO CUMPLE@@@@@@@");
          if (turno.fecha.isAfter(DateTime.now())) {
            DateTime time = datosOfrecimientos.docs[i].data()['fecha'].toDate();
            DateTime time2 = DateTime(time.year, time.month, time.day);
            map[time2] = turno;
          }
          else {
            //tendre que borrar las peticiones en Firebase que se hayan pasado de fecha porque ya no me interesa guardarlas
            deleteTurnoPedidoOfrecimientos(turno.idTurno);
          }
        }
      }
    }
    return map;
  }

  void deleteTurnoPedidoPeticiones(String idTurno){
    FirebaseFirestore.instance.collection("listaPeticiones").doc(idTurno).delete().then((_){
      print("TURNO BORRADO!!!");
    });
  }

  void deleteTurnoPedidoOfrecimientos(String idTurno){
    FirebaseFirestore.instance.collection("listaOfrecimientos").doc(idTurno).delete().then((_){
      print("TURNO BORRADO!!!");
    });
  }

  //PEticionConfirmacion:
  Future<bool?> getContinuaTurno(String idTurno) async {
    bool candidato = false;
    String? maqCandidato;
    await FirebaseFirestore.instance.collection("listaPeticiones").doc(
        idTurno)
        .get()
        .then((value) {
      if(value.exists){
        candidato = true;
      }
    });
    return candidato;
  }


  //OFrecimientoDiaVista para peticionesDAtos:
  Future<bool?> comprobarOkPeticionOfrecimientoDiaVista(DateTime fechaSeleccionada,String idMaquinista) async{
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



}

 */








