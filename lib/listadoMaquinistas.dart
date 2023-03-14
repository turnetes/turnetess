
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

class ListadoMaquinistas extends StatefulWidget {

  @override
  _ListadoMaquinistas createState() => _ListadoMaquinistas();
}

class _ListadoMaquinistas extends State<ListadoMaquinistas> {

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
                                elevation: 0,
                                color: Colors.purple.shade100,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: ListTile(
                                    leading: Container(
                                        padding: EdgeInsets.only(right: 12.0),
                                        decoration: new BoxDecoration(
                                            border: new Border(
                                                right: new BorderSide(width: 1.0,
                                                    color: Colors.white24))),
                                        child: elegirImagen(
                                            snapshot.data![index].imagePath)),
                                    title:  Text(snapshot.data![index].apodo,
                                            style: TextStyle(color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,),
                                           ),
                                    subtitle: Row(
                                      children: [
                                            Text("Turnos: (" + snapshot.data![index].contadorTurnos.toString()+ ")"),
                                            (snapshot.data![index].contadorTurnos > 0) ? Icon(Icons.arrow_upward,  color: Colors.green,) : (snapshot.data![index].contadorTurnos < 0) ? Icon(Icons.arrow_downward_outlined, color: Colors.red,) :  Icon(Icons.arrow_back),
                                        Text("      Fest: (" + snapshot.data![index].contadorFestivos.toString()+ ")"),
                                        (snapshot.data![index].contadorFestivos > 0) ? Icon(Icons.arrow_upward, color: Colors.green,) : (snapshot.data![index].contadorFestivos > 0) ? Icon(Icons.arrow_downward_outlined, color: Colors.red,) :  Icon(Icons.arrow_back),
                                      ]
                                     ),
                                    trailing: IconButton(icon: Icon(Icons.info,
                                                color: Colors.black, size: 30.0),
                                                onPressed: () {
                                                  Navigator.push(context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              PerfilCompi( snapshot.data![index])));
                                                  }
                                                ), // icon-1
                                        // icon-2
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


