/*
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:localstorage/localstorage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:turnetes/drawerWidget.dart';
import 'package:turnetes/pedirDia.dart';
import 'package:intl/intl.dart';
import 'ModeloTurno.dart';
import 'confirmacionTurno4.dart';


class Peticiones4 extends StatelessWidget {

  LocalStorage storage;



  Peticiones4(this.storage);

  @override
  Widget build(BuildContext context){
    return  Scaffold(
        appBar: AppBar(
          title: const Text("Peticiones"),
          backgroundColor: Colors.purple,
        ),
        drawer: DrawerWidget(),
        body: Container(
          child: FutureBuilder<List<Turno>?>(
              future: pasarLista(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.length == 0) {
                    return Center(
                        child: Text("No hay peticiones")
                    );
                  }
                  else {
                    return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 8.0,
                            margin: new EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 6.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(64, 75, 96, .9)),
                              child: ListTile(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 10.0),
                                leading: Container(
                                  padding: EdgeInsets.only(right: 12.0),
                                  decoration: new BoxDecoration(
                                      border: new Border(
                                          right: new BorderSide(width: 1.0,
                                              color: Colors.white24))),
                                  child: SingleChildScrollView(
                                    child:Column(
                                      children: [
                                        Text( snapshot.data![index].fecha.day
                                            .toString() + "/" +
                                            snapshot.data![index].fecha.month
                                                .toString()
                                          , style: TextStyle(color: snapshot.data![index].visto! ? Colors.white : Colors.yellowAccent,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 30,),
                                        ),
                                        Text(sacarDiaSemana(snapshot.data![index].fecha),
                                            style: TextStyle(color: snapshot.data![index].visto! ? Colors.white : Colors.yellowAccent,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,)
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                title: Text("Turno:   " +
                                    snapshot.data![index].clave.toString(),
                                  style: TextStyle(color: snapshot.data![index].visto! ? Colors.white : Colors.yellowAccent,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,),
                                ),
                                // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),
                                subtitle: Row(
                                  children: <Widget>[
                                    Icon(Icons.linear_scale,
                                        color: Colors.yellowAccent),
                                    Text(sacarGrafico(
                                        snapshot.data![index].clave!)
                                        .toString(),
                                        style: TextStyle(color: snapshot.data![index].visto! ? Colors.white : Colors.yellowAccent))
                                  ],
                                ),
                                trailing: IconButton(icon: Icon(Icons.keyboard_arrow_right,
                                  color: snapshot.data![index].visto! ? Colors.white : Colors.yellowAccent, size: 30.0,
                                ),
                                    onPressed: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => ConfirmacionTurno4(snapshot.data![index])));
                                    }
                                ),
                              ),
                            ),
                          );
                        });
                  }
                }
                return const Center(child: CircularProgressIndicator());
              }
          ),
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () =>
                Navigator.push(context, MaterialPageRoute(builder: (context) => pedirDia())),
            child: const Icon(Icons.add, size: 30),
            backgroundColor: Colors.purple
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat

    );
  }





  Future<List<Turno>?> pasarLista() async {

    var datos = await FirebaseFirestore.instance.collection("listaPeticiones").get();
    LocalStorage storage = new LocalStorage('peticiones.json');
    List<Turno> listaTurnosMostrar = []; //Los que tienen candidato y la fecha es posterior al dia de hoy no los muestro
    // Lista guarda en almacenamiento local todas las peticiones incluidos los que tengo candidatos para uso en comprobacion en pedirDia
    List<Turno> listaTurnosTotales = [];
    String? idMaquinistaPropio = FirebaseAuth.instance.currentUser?.uid;
    if (datos.size == 0) {
      print("peticiones vacía");
    }
    else {
      for (int i = 0; i < datos.docs.length; i++) {
        //solo meteremos en la lista turnos que sean despues de la fecha actual
        if (DateTime.now().isBefore(datos.docs[i].data()['fecha'].toDate())) {
          Turno turno = Turno(
            datos.docs[i].data()['clave'],
            datos.docs[i].data()['fecha'].toDate(),
            datos.docs[i].data()['grafico'],
            datos.docs[i].data()['idMaquinistaCandidato'],
            datos.docs[i].data()['idMaquinistaPide'],
            datos.docs[i].data()['idTurno'],
          );
          if (datos.docs[i].data()['idMaquinistaCandidato'] == null) {
            listaTurnosMostrar.add(turno);
          }
          else{
            print("TURNOS QUE NO SON NULL = " + turno.idMaquinistaCandidato.toString());
          }
          listaTurnosTotales.add(turno);
        }
      }
      print("TAMAÑOOO   LISTA TURNOS TOTALES = " + listaTurnosTotales.length.toString());
      print("TAMAÑOOO   LISTA TURNOS MOSTRAR = " + listaTurnosMostrar.length.toString());
    }



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
      if(listaTurnosTotales[i].idMaquinistaPide == idMaquinistaPropio){
        DateTime fechaString = DateTime(listaTurnosTotales[i].fecha.year,listaTurnosTotales[i].fecha.month,listaTurnosTotales[i].fecha.day);
        String fechaString2 = fechaString.toString(); // Json no admite DateTime por eso lo paso a String
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

    /*
    listaTurnosMostrar.sort((a, b) {
      int aDate = a.fecha.microsecondsSinceEpoch;
      int bDate = b.fecha.microsecondsSinceEpoch;
      return aDate.compareTo(bDate);
    });

     */

    //return listaTurnosMostrar;
    print("LA LISTA"+ listaTurnosMostrar.toString());
    return ordenarTurnos(listaTurnosMostrar);
  }

  List<Turno>? ordenarTurnos(List<Turno> lista){
    lista.sort((a,b) {
      int aDate = a.fecha.microsecondsSinceEpoch;
      int bDate = b.fecha.microsecondsSinceEpoch;
      return aDate.compareTo(bDate);
    });
    print("LA LISTA"+ lista.toString());
    return lista;
  }

  String sacarGrafico(int clave) {
    dynamic i = (clave / 100);
    int x = i.toInt();
    switch (x) {
      case 1:
        return "    Mañanas";
        break;
      case 2:
        return "    General";
        break;
      case 3:
        return "    Tardes";
        break;
      case 4:
        return "    Villalba";
        break;
      case 5:
        return "    Alcala";
        break;
      case 6:
        return "    Principe pío";
        break;
      case 7 :
        return "  noche";
        break;
      default :
        return "  maniobras";
    }

  }


  bool? sacarFestivos(DateTime? date2) {
    late String resp;
    if (date2 != null) {
      String dia = DateFormat('EEEE').format(date2);
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
        case "Tuesday":
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
          dia = "Sábado";
          break;
        case "Sunday":
          dia = "Domingo";
          break;
      }
      return dia ;
    }
  }
}




 */


