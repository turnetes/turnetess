/*
import 'dart:ffi';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:turnetes/perfil2.dart';
import 'package:turnetes/perfilCompi.dart';
import 'DrawerWidget.dart';
import 'Modelos/ModeloMaquinista.dart';
import 'my_flutter_app_icons.dart';

class ListadoMaquinistas3 extends StatefulWidget {

  @override
  _ListadoMaquinistas3 createState() => _ListadoMaquinistas3();
}

class _ListadoMaquinistas3 extends State<ListadoMaquinistas3> {

  TextEditingController? letrasBuscarController = TextEditingController();

  @override
  void initState() {
    super.initState();

    letrasBuscarController?.addListener(() {
      setState(() {

      });
    });
    build(context);

  }


  @override
  Widget build(BuildContext context) {
    String searchString = "";
    // TODO: implement build
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Listado de compañeros"),
          backgroundColor: Colors.purple,
        ),
        drawer: DrawerWidget(),
        body: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: TextField(
                  onChanged: (value) {
                    setState() {
                      letrasBuscarController = value as TextEditingController?;
                    }
                  },
                  controller: letrasBuscarController,
                  decoration: InputDecoration(
                    labelText: 'Search',
                    suffixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: FutureBuilder<List<Maquinista>?>(
                    future: pasarListaMaquinistas(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                            child: Text("No hay peticiones")
                        );
                      }
                      else{
                        return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return snapshot.data![index].apodo.contains(
                                  letrasBuscarController!.text) ?
                              Card(
                                elevation: 8.0,
                                margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                                child: Container(
                                  decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
                                  child: ListTile(
                                    contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 05.0),
                                    leading: Container(
                                      padding: EdgeInsets.only(right: 5.0),
                                      decoration: new BoxDecoration(
                                          border: new Border(
                                              right: new BorderSide(color: Colors.white24))),
                                      child: CircleAvatar(
                                        backgroundImage: NetworkImage(snapshot.data![index].imagePath),
                                        maxRadius: 30,
                                      ),
                                    ),
                                    title: Text(
                                      snapshot.data![index].apodo,
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                    // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                                    subtitle: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child:  Row(
                                        children: <Widget>[
                                          Text("Turnos: ", style: TextStyle(color: Colors.white)),
                                          (snapshot.data![index].contadorTurnos > 0) ? Text("+"+snapshot.data![index].contadorTurnos.toString(), style: TextStyle(color: Colors.white)) : (snapshot.data![index].contadorTurnos < 0) ? Text(snapshot.data![index].contadorTurnos.toString(), style: TextStyle(color: Colors.white)) : Text(snapshot.data![index].contadorTurnos.toString()+ " ", style: TextStyle(color: Colors.white)),
                                          //Icon(Icons.arrow_drop_down_circle, color: Colors.red,),
                                          (snapshot.data![index].contadorTurnos > 0) ? Icon(Icons.arrow_drop_up_sharp,  color: Colors.green,) :  (snapshot.data![index].contadorTurnos < 0) ? Icon(Icons.arrow_drop_down, color: Colors.red,) : Icon(MyFlutterApp.eq, size: 12,color: Colors.white,)  ,
                                          (snapshot.data![index].contadorTurnos == 0) ? Text(" ") : Text(""),
                                          Icon(Icons.linear_scale, color: Colors.yellowAccent),
                                          Text(" Festivos: ", style: TextStyle(color: Colors.white)),
                                          (snapshot.data![index].contadorFestivos > 0) ? Text("+"+snapshot.data![index].contadorFestivos.toString(), style: TextStyle(color: Colors.white)) : (snapshot.data![index].contadorFestivos < 0) ? Text(snapshot.data![index].contadorFestivos.toString(), style: TextStyle(color: Colors.white)) : Text(snapshot.data![index].contadorFestivos.toString()+ " ", style: TextStyle(color: Colors.white)),
                                          (snapshot.data![index].contadorFestivos > 0) ? Icon(Icons.arrow_drop_up_sharp,  color: Colors.green,) :  (snapshot.data![index].contadorFestivos < 0) ? Icon(Icons.arrow_drop_down, color: Colors.red,) : Icon(MyFlutterApp.eq, size: 12,color: Colors.white,)
                                        ],
                                      ),
                                    ),
                                    trailing:
                                    IconButton(icon: Icon(Icons.info, color: Colors.white, size: 25.0),
                                        onPressed: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PerfilCompi(snapshot
                                                          .data![index])));
                                        }
                                    ),
                                  ),
                                ),
                              )
                                  :   Center();
                            }

                        );
                      }
                      return const Center(child: CircularProgressIndicator());
                    }


                ),
              ),
            ]
        ),
      ),
    );
  }

  Future<List<Maquinista>?> pasarListaMaquinistas() async {
    var datos = await FirebaseFirestore.instance.collection("maquinistas")
        .get();
    List<Maquinista> listaMaquinistas = [];
    if (datos.size == 0) {
      print("peticiones vacía");
    }
    else {
      for (int i = 0; i < datos.docs.length; i++) {
        Maquinista maq = Maquinista(
          datos.docs[i].data()['apodo'],
          datos.docs[i].data()["contadorFestivos"] as int,
          datos.docs[i].data()['contadorTurnos'],
          datos.docs[i].data()['correo'],
          datos.docs[i].data()['idMaquinista'],
          datos.docs[i].data()['imagePath'],
          datos.docs[i].data()['nombre'],
          datos.docs[i].data()['oneSignalID'],
          datos.docs[i].data()['passAdmin'],
          datos.docs[i].data()['telfExt'],
          datos.docs[i].data()['telfInt'],);
        listaMaquinistas.add(maq);
        print(maq.toString());
      }
    }
    return listaMaquinistas;
  }


  Widget elegirImagen(String url) {
    if (url == "") {
      return Image.asset('assets/anonimo.jpg');
    }
    else {
      return Image.network(url);
    }
  }
}


 */