import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:localstorage/localstorage.dart';

import '../Modelos/ModeloTurno.dart';

class OfrecimientosDatos {

  static final OfrecimientosDatos _OfrecimientosDatos = OfrecimientosDatos
      ._internal();


  factory OfrecimientosDatos() {
    return _OfrecimientosDatos;
  }

  OfrecimientosDatos._internal();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore instance = FirebaseFirestore.instance;
  LocalStorage storage = new LocalStorage('ofrecimientos.json');


  Future<List<ModeloTurno>?> pasarListaTurnos() async {
    //var datos2 = await instance.collection("listaPeticiones").doc().get();
    var datos2 = await instance.collection("listaOfrecimientos").get();
    List<QueryDocumentSnapshot> datos3 = datos2.docs;
    if (datos3 != null) {

      print("DATOS3 es NULLL!!!!!!!!!");
      //Map<String,dynamic> primero = datos3.first as Map<String, dynamic>;
      //datos2.docs
      //final dynamic mapPeticiones = datos2.data();
      //if(mapPeticiones == null) {print("MAP_PETI ES NULL!");}
      //List<Turno> listaTurnosMostrar2 = datos2.fromJson();
      List<ModeloTurno> listaTurnosMostrar = [];

      //print("A VER SI LEES ESTO CONTROL" + mapPeticiones.values.first.toString());
      //Los que tienen candidato y la fecha es posterior al dia de hoy no los muestro
      // Lista guarda en almacenamiento local todas las peticiones incluidos los que tengo candidatos para uso en comprobacion en pedirDia
      List<ModeloTurno> listaTurnosTotales = [];
      for (int i = 0; i < datos3.length; i++) {
        if (DateTime.now().isBefore(datos3[i].get('fecha').toDate())) {
          print("ENTRA POR CONTROL!");
          print(datos3[i].get('clave'.toString()));
          print(datos3[i].get('fecha'.toString()));
          print(datos3[i].get('gráfico'.toString()));
          print(datos3[i].get('idMaquinistaCandidato'.toString()));
          print(datos3[i].get('idMaquinistaPide'.toString()));
          print(datos3[i].get('idTurno'.toString()));
          ModeloTurno turno = ModeloTurno(
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


      /*

      //sacamos la lista "DESeralizamos" el map que tenemos en almacenamiento local
      var str = await storage.getItem('mapPeticiones');
      var str2 = await storage.getItem('user');
      print("STR A VER QUE ME LEES!!!!!!!!!!!!!!!!!!!!!!!!");
      if(str != null){
        if(str2 != null){
          print("STR ");
        }
        //List<String> datosDesCodificados = [];
        var datosDesCodificados = await json.decode(str);
        print("STR A VER QUE ME LEES!!!!!!!!!!!!!!!!!!!!!!!!" + datosDesCodificados.length.toString());
        if(datosDesCodificados.isNotEmpty ){
          print("ENTRA POR AQUI!!!!!!!!!!!!!!!!!!!");
          for(int i= 0; i < listaTurnos.length; i ++) {
            for(int j= 0; j < datosDesCodificados.length; j ++) {
              if(listaTurnos[i].idTurno == datosDesCodificados[j]){
                listaTurnos[i].setVisto();
                print("alguno ya se ha visto!!!!!!!!!!!!!!!!!!!!");
                break;
              }
            }

          }
        }
      }
      else{
        print("STR ES NULL");
      }







      //volvemos a guardar la lista nueva en almacenamiento local para la siguiente vez
      //Map<String,dynamic> nuevaListaAlmacenar = new Map<String,dynamic>();
      List<String> nuevaListaAlmacenar = [];
      for(int i= 0; i < listaTurnos.length; i ++) {
        nuevaListaAlmacenar.add(listaTurnos[i].idTurno);
      }

      print("###########ANTES DEL JSON: ");
      String res = json.encode(nuevaListaAlmacenar);
      print(res);
      await storage.setItem('mapPeticiones', res);



      //sacamos la lista "DESeralizamos" el map que tenemos en almacenamiento local
      print("LLEGA POR AQUI!!!!!!!!!!!!!!!!!!!!!!!!");
      var str = await storage.getItem('mapPeticiones');
      if (str != null) {
        //List<String> datosDesCodificados = [];
        var datosDesCodificados = await json.decode(str);
        print("STR A VER QUE ME LEES!!!!!!!!!!!!!!!!!!!!!!!!" + datosDesCodificados.length.toString());
        if (datosDesCodificados.isNotEmpty) {
          for (int i = 0; i < listaTurnosMostrar.length; i ++) {
            for (int j = 0; j < datosDesCodificados.length; j ++) {
              if (listaTurnosMostrar[i].idTurno == datosDesCodificados[j]["idTurno"]) {
                listaTurnosMostrar[i].setVisto();
                break;
              }
            }
          }
        }
      }
      else {
        print("STR ES NULL");
      }

       */

      //PROBANDO... DESERIALIZAMOS EL MAP que tenemos en almacenamiento local
      print("A VER SI ARRANCA EL JSON:");

      String id = auth.currentUser!.uid;
      if (id == null) {
        print("EL ID ES NULLL");
      }
      print("EL ID PARA EL JSON ES: " + id);
      var str2 = await storage.getItem(auth.currentUser!.uid);
      if (str2 != null) {
        Map<String, List<dynamic>?> datosDesCodificados2 = Map.castFrom(
            await json.decode(str2));
        if (datosDesCodificados2.isNotEmpty) {
          for (int i = 0; i < listaTurnosMostrar.length; i ++) {
            if (datosDesCodificados2.containsKey(listaTurnosMostrar[i].idTurno)) {
              listaTurnosMostrar[i].setVisto();
            }
          }
          print("DATOS DESCODIFICADOS: " + datosDesCodificados2.toString());
        }
      }


      //volvemos a guardar la lista nueva en almacenamiento local para la siguiente vez
      //Map<String,dynamic> nuevaListaAlmacenar = new Map<String,dynamic>();

      /*
      //ANTERIOR K IBA BIEN!
      List<Map<String, dynamic>> nuevaListaAlmacenar = [];
      print("TAMAÑO DE LA LISTATURNOS TOTALES: " + listaTurnosTotales.length.toString());
      for (int i = 0; i < listaTurnosTotales.length; i ++) {
        nuevaListaAlmacenar.add(listaTurnosTotales[i].toJson());
      }


     */

      //PROBANDO.... GUARDA A JSON EL MAP
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
      /*
    listaTurnosMostrar.sort((a, b) {
      int aDate = a.fecha.microsecondsSinceEpoch;
      int bDate = b.fecha.microsecondsSinceEpoch;
      return aDate.compareTo(bDate);
    });

     */

      print("A VER SI ME MUESTRA ESTA LISTA: " + listaTurnosMostrar.toString());
      return ordenarTurnos(listaTurnosMostrar);
    }


  }

  List<ModeloTurno>? ordenarTurnos(List<ModeloTurno> lista) {
    lista.sort((a, b) {
      int aDate = a.fecha.microsecondsSinceEpoch;
      int bDate = b.fecha.microsecondsSinceEpoch;
      return aDate.compareTo(bDate);
    });
    print("A VER SI ME MUESTRA ESTA LISTA2: " + lista.toString());
    return lista;
  }

  Future<bool> checkRestriccion1Json(DateTime fechaSeleccionada) async {
    LocalStorage storage = new LocalStorage('ofrecimientos.json');
    String idMaquinista = auth.currentUser!.uid;
    print("IDMAQUINISTA = " + idMaquinista);
    await storage.ready;
    var str = await storage.getItem(idMaquinista);
    if(str == null){
      return true;
    }
    else{
      Map<String, List<dynamic>?> mapDecodificado = Map.castFrom(await json.decode(str));
      if (mapDecodificado.isNotEmpty) {
        for (List<dynamic>? v in mapDecodificado.values) {
          if (v != null) {
            if (v.isNotEmpty) {
              print("NO ES NULL V");
              print(v.toString());
              if (v[0] == fechaSeleccionada.toString()) {
                if (v[1] == idMaquinista) {
                  return false;
                }
              }
            }
          }
        }
      }
      return true;
    }

  }

  Future<void> saveOfrecimientoFireBase(DateTime fecha, String grafico) async {
    FirebaseFirestore.instance.collection('listaOfrecimientos').add(
        {

          'clave': null,
          'fecha': fecha,
          'idMaquinistaCandidato': auth.currentUser!.uid,
          'idMaquinistaPide': null,
          'gráfico': grafico,

        }
    ).then((value) {
      FirebaseFirestore.instance.collection('listaOfrecimientos')
          .doc(value.id)
          .set(
          {
            "idTurno": value.id,
          }, SetOptions(merge: true))
          .then((_) {
        //showAlert();
      });
    });
  }


  Future<List<ModeloTurno>?> pasarLista7() async{
    var datos = await FirebaseFirestore.instance.collection(
        "listaOfrecimientos").get();
    //LocalStorage storage = new LocalStorage('ofrecimientos.json');
    List<ModeloTurno> listaTurnosMostrar = []; //Los que tienen candidato y la fecha es posterior al dia de hoy no los muestro
    // Lista guarda en almacenamiento local todas las peticiones incluidos los que tengo candidatos para uso en comprobacion en pedirDia
    List<ModeloTurno> listaTurnosTotales = [];

    String? idMaquinistaPropio = FirebaseAuth.instance.currentUser?.uid;
    if (datos.size == 0) {
      print("lista ofrecimientos vacía");
    }
    else {
      for (int i = 0; i < datos.docs.length; i++) {
        print("lista ofrecimientos NO vacía");
        //solo meteremos en la lista turnos que sean despues de la fecha actual
        if (DateTime.now().isBefore(datos.docs[i].data()['fecha'].toDate())) {
          ModeloTurno turno = ModeloTurno(
            datos.docs[i].data()['clave'],
            datos.docs[i].data()['fecha'].toDate(),
            datos.docs[i].data()['gráfico'],
            datos.docs[i].data()['idMaquinistaCandidato'],
            datos.docs[i].data()['idMaquinistaPide'],
            datos.docs[i].data()['idTurno'],
          );
          print("ENTRA POR AQUI!!!!!!!!!!");
          if (datos.docs[i].data()['idMaquinistaPide'] == null) {
            listaTurnosMostrar.add(turno);
            print("ENTRA POR AQUI!!!!!!!!!!");
          }
          else {
            print("TURNOS QUE NO SON NULL = " +
                turno.idMaquinistaPide.toString());
          }
          listaTurnosTotales.add(turno);
        }
      }
      print("VENGA TAMAÑOOO   LISTA TURNOS TOTALES OFRECIMIENTOS = " +
          listaTurnosTotales.length.toString());
      print("TAMAÑOOO   LISTA TURNOS MOSTRAR OFRECIMIENTOS= " +
          listaTurnosMostrar.length.toString());
    }



    //PROBANDO... DESERIALIZAMOS EL MAP que tenemos en almacenamiento local
    print("A VER SI ARRANCA EL JSON:");
    var str2 = await storage.getItem(idMaquinistaPropio!);
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







    //PROBANDO.... GUARDA A JSON EL MAP ===> ESTO TENGO K METERLO LUEGO!!!!!
    List<dynamic>? listaTurnos = [];
    Map<String, List<dynamic>> mapGuardarJson = {};
    for (int i = 0; i < listaTurnosTotales.length; i ++) {
    listaTurnos = [];
    if(listaTurnosTotales[i].idMaquinistaCandidato == idMaquinistaPropio){
    DateTime fechaString = DateTime(listaTurnosTotales[i].fecha.year,listaTurnosTotales[i].fecha.month,listaTurnosTotales[i].fecha.day);
    String fechaString2 = fechaString.toString();
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
    print("TAMAÑO DE MAP GUARDAR MAP@@@@@@@ = " + mapGuardarJson.length.toString());
    String guardarMap = json.encode(mapGuardarJson);

    await storage.setItem(idMaquinistaPropio, guardarMap);


    listaTurnosMostrar.sort((a, b) {
    int aDate = a.fecha.microsecondsSinceEpoch;
    int bDate = b.fecha.microsecondsSinceEpoch;
    return aDate.compareTo(bDate);
    });
    return listaTurnosMostrar;
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
    await FirebaseFirestore.instance.collection("listaOfrecimientos").doc(
        idTurno)
        .get()
        .then((value) {
      if(value.exists){
        candidato = true;
      }
    });
    return candidato;
  }


}