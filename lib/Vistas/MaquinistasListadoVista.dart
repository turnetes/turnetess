import 'dart:ffi';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:turnetes/perfil2.dart';
import 'package:turnetes/perfilCompi.dart';
import '../DrawerWidget.dart';
import '../Modelos/ModeloMaquinista.dart';
import '../my_flutter_app_icons.dart';

class MaquinistasListadoVista extends StatefulWidget {

  List<ModeloMaquinista> listadoMaquinistas;

  MaquinistasListadoVista(this.listadoMaquinistas);

  @override
  _MaquinistasListadoVista createState() => _MaquinistasListadoVista();
}

class _MaquinistasListadoVista extends State<MaquinistasListadoVista> {

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
              resultadoVista()!,
              /*
              Expanded(
                child: ListView.builder(
                    itemCount: widget.listadoMaquinistas.length,
                    itemBuilder: (context, index) {
                      return widget.listadoMaquinistas[index].apodo.contains(
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
                                backgroundImage: NetworkImage(widget.listadoMaquinistas![index].imagePath),
                                maxRadius: 30,
                              ),
                            ),
                            title: Text(
                              widget.listadoMaquinistas[index].apodo,
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                            // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                            subtitle: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child:  Row(
                                children: <Widget>[
                                  Text("Turnos: ", style: TextStyle(color: Colors.white)),
                                  (widget.listadoMaquinistas[index].contadorTurnos > 0) ? Text("+"+ widget.listadoMaquinistas[index].contadorTurnos.toString(), style: TextStyle(color: Colors.white)) : (widget.listadoMaquinistas[index].contadorTurnos < 0) ? Text(widget.listadoMaquinistas[index].contadorTurnos.toString(), style: TextStyle(color: Colors.white)) : Text(widget.listadoMaquinistas[index].contadorTurnos.toString()+ " ", style: TextStyle(color: Colors.white)),
                                  //Icon(Icons.arrow_drop_down_circle, color: Colors.red,),
                                  (widget.listadoMaquinistas[index].contadorTurnos > 0) ? Icon(Icons.arrow_drop_up_sharp,  color: Colors.green,) :  (widget.listadoMaquinistas[index].contadorTurnos < 0) ? Icon(Icons.arrow_drop_down, color: Colors.red,) : Icon(MyFlutterApp.eq, size: 12,color: Colors.white,)  ,
                                  (widget.listadoMaquinistas[index].contadorTurnos == 0) ? Text(" ") : Text(""),
                                  Icon(Icons.linear_scale, color: Colors.yellowAccent),
                                  Text(" Festivos: ", style: TextStyle(color: Colors.white)),
                                  (widget.listadoMaquinistas[index].contadorFestivos > 0) ? Text("+"+ widget.listadoMaquinistas[index].contadorFestivos.toString(), style: TextStyle(color: Colors.white)) : (widget.listadoMaquinistas[index].contadorFestivos < 0) ? Text(widget.listadoMaquinistas[index].contadorFestivos.toString(), style: TextStyle(color: Colors.white)) : Text(widget.listadoMaquinistas[index].contadorFestivos.toString()+ " ", style: TextStyle(color: Colors.white)),
                                  (widget.listadoMaquinistas[index].contadorFestivos > 0) ? Icon(Icons.arrow_drop_up_sharp,  color: Colors.green,) :  (widget.listadoMaquinistas[index].contadorFestivos < 0) ? Icon(Icons.arrow_drop_down, color: Colors.red,) : Icon(MyFlutterApp.eq, size: 12,color: Colors.white,)
                                ],
                              ),
                            ),
                            trailing:
                            IconButton(icon: Icon(Icons.info, color: Colors.white, size: 25.0),
                                onPressed: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PerfilCompi(widget.listadoMaquinistas[index])));
                                }
                            ),
                          ),
                        ),
                      )
                          :   Center();
                    }

                )
              ),
              */
            ]
        ),
      ),
    );
  }

  Widget elegirImagen(String url) {
    if (url == "") {
      return Image.asset('assets/anonimo.jpg');
    }
    else {
      return Image.network(url);
    }
  }

  Widget? resultadoVista() {
    if (letrasBuscarController!.text.isEmpty) {
      return Expanded(
          child: ListView.builder(
              itemCount: widget.listadoMaquinistas.length,
              itemBuilder: (context, index) {
                return widget.listadoMaquinistas[index].apodo.contains(
                    letrasBuscarController!.text) ?
                Card(
                  elevation: 8.0,
                  margin: new EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 6.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(64, 75, 96, .9)),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 05.0),
                      leading: Container(
                        padding: EdgeInsets.only(right: 5.0),
                        decoration: new BoxDecoration(
                            border: new Border(
                                right: new BorderSide(color: Colors.white24))),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(widget
                              .listadoMaquinistas![index].imagePath),
                          maxRadius: 30,
                        ),
                      ),
                      title: Text(
                        widget.listadoMaquinistas[index].apodo,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                      subtitle: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: <Widget>[
                            Text("Turnos: ", style: TextStyle(
                                color: Colors.white)),
                            (widget.listadoMaquinistas[index].contadorTurnos >
                                0) ? Text("+" +
                                widget.listadoMaquinistas[index].contadorTurnos
                                    .toString(),
                                style: TextStyle(color: Colors.white)) : (widget
                                .listadoMaquinistas[index].contadorTurnos < 0)
                                ? Text(
                                widget.listadoMaquinistas[index].contadorTurnos
                                    .toString(),
                                style: TextStyle(color: Colors.white))
                                : Text(
                                widget.listadoMaquinistas[index].contadorTurnos
                                    .toString() + " ",
                                style: TextStyle(color: Colors.white)),
                            //Icon(Icons.arrow_drop_down_circle, color: Colors.red,),
                            (widget.listadoMaquinistas[index].contadorTurnos >
                                0) ? Icon(Icons.arrow_drop_up_sharp,
                              color: Colors.green,) : (widget
                                .listadoMaquinistas[index].contadorTurnos < 0)
                                ? Icon(
                              Icons.arrow_drop_down, color: Colors.red,)
                                : Icon(
                              MyFlutterApp.eq, size: 12, color: Colors.white,),
                            (widget.listadoMaquinistas[index].contadorTurnos ==
                                0) ? Text(" ") : Text(""),
                            Icon(Icons.linear_scale, color: Colors
                                .yellowAccent),
                            Text(" Festivos: ", style: TextStyle(
                                color: Colors.white)),
                            (widget.listadoMaquinistas[index].contadorFestivos >
                                0) ? Text("+" + widget.listadoMaquinistas[index]
                                .contadorFestivos.toString(),
                                style: TextStyle(color: Colors.white)) : (widget
                                .listadoMaquinistas[index].contadorFestivos < 0)
                                ? Text(widget.listadoMaquinistas[index]
                                .contadorFestivos.toString(),
                                style: TextStyle(color: Colors.white))
                                : Text(widget.listadoMaquinistas[index]
                                .contadorFestivos.toString() + " ",
                                style: TextStyle(color: Colors.white)),
                            (widget.listadoMaquinistas[index].contadorFestivos >
                                0) ? Icon(Icons.arrow_drop_up_sharp,
                              color: Colors.green,) : (widget
                                .listadoMaquinistas[index].contadorFestivos < 0)
                                ? Icon(
                              Icons.arrow_drop_down, color: Colors.red,)
                                : Icon(
                              MyFlutterApp.eq, size: 12, color: Colors.white,)
                          ],
                        ),
                      ),
                      trailing:
                      IconButton(icon: Icon(
                          Icons.info, color: Colors.white, size: 25.0),
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        PerfilCompi(
                                            widget.listadoMaquinistas[index])));
                          }
                      ),
                    ),
                  ),
                )
                    : Center();
              }

          )
      );
    }
    else {
      List<ModeloMaquinista> listaEncontrados =  getListaBuscados();
      if(listaEncontrados.isEmpty){
        return Expanded(
          child: Center(
              child: Text("No hay coincidencias", style: TextStyle(fontSize: 20))
          )
        );
      }
      else{
        return
        Expanded(
            child: ListView.builder(
                itemCount: widget.listadoMaquinistas.length,
                itemBuilder: (context, index) {
                  return widget.listadoMaquinistas[index].apodo.contains(
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
                            backgroundImage: NetworkImage(widget.listadoMaquinistas![index].imagePath),
                            maxRadius: 30,
                          ),
                        ),
                        title: Text(
                          widget.listadoMaquinistas[index].apodo,
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                        subtitle: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child:  Row(
                            children: <Widget>[
                              Text("Turnos: ", style: TextStyle(color: Colors.white)),
                              (widget.listadoMaquinistas[index].contadorTurnos > 0) ? Text("+"+ widget.listadoMaquinistas[index].contadorTurnos.toString(), style: TextStyle(color: Colors.white)) : (widget.listadoMaquinistas[index].contadorTurnos < 0) ? Text(widget.listadoMaquinistas[index].contadorTurnos.toString(), style: TextStyle(color: Colors.white)) : Text(widget.listadoMaquinistas[index].contadorTurnos.toString()+ " ", style: TextStyle(color: Colors.white)),
                              //Icon(Icons.arrow_drop_down_circle, color: Colors.red,),
                              (widget.listadoMaquinistas[index].contadorTurnos > 0) ? Icon(Icons.arrow_drop_up_sharp,  color: Colors.green,) :  (widget.listadoMaquinistas[index].contadorTurnos < 0) ? Icon(Icons.arrow_drop_down, color: Colors.red,) : Icon(MyFlutterApp.eq, size: 12,color: Colors.white,)  ,
                              (widget.listadoMaquinistas[index].contadorTurnos == 0) ? Text(" ") : Text(""),
                              Icon(Icons.linear_scale, color: Colors.yellowAccent),
                              Text(" Festivos: ", style: TextStyle(color: Colors.white)),
                              (widget.listadoMaquinistas[index].contadorFestivos > 0) ? Text("+"+ widget.listadoMaquinistas[index].contadorFestivos.toString(), style: TextStyle(color: Colors.white)) : (widget.listadoMaquinistas[index].contadorFestivos < 0) ? Text(widget.listadoMaquinistas[index].contadorFestivos.toString(), style: TextStyle(color: Colors.white)) : Text(widget.listadoMaquinistas[index].contadorFestivos.toString()+ " ", style: TextStyle(color: Colors.white)),
                              (widget.listadoMaquinistas[index].contadorFestivos > 0) ? Icon(Icons.arrow_drop_up_sharp,  color: Colors.green,) :  (widget.listadoMaquinistas[index].contadorFestivos < 0) ? Icon(Icons.arrow_drop_down, color: Colors.red,) : Icon(MyFlutterApp.eq, size: 12,color: Colors.white,)
                            ],
                          ),
                        ),
                        trailing:
                        IconButton(icon: Icon(Icons.info, color: Colors.white, size: 25.0),
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          PerfilCompi(widget.listadoMaquinistas[index])));
                            }
                        ),
                      ),
                    ),
                  )
                      :   Center();
                }

            )
        );
      }
    }
  }


      List<ModeloMaquinista> getListaBuscados(){
        List<ModeloMaquinista> listaNueva =  [];
        widget.listadoMaquinistas.forEach((element)=>
        {
          if(element.apodo.contains(letrasBuscarController!.text)){
            listaNueva.add(element)
          }
        }
        );
        return listaNueva;
    }
}


