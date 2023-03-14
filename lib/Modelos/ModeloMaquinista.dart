import 'package:flutter/material.dart';


class ModeloMaquinista{
  String nombre;
  String apodo;
  String correo;
  String idMaquinista;
  String telefonoExt;
  String telefonoInt;
  String oneSignalID;
  int contadorFestivos;
  int contadorTurnos;
  String imagePath;
  bool passAdmin;


  ModeloMaquinista(this.apodo, this.contadorFestivos, this.contadorTurnos, this.correo, this.idMaquinista, this.imagePath, this.nombre, this.oneSignalID, this.passAdmin, this.telefonoExt, this.telefonoInt);

  void setContador(int cont) {
    // TODO: implement setContador
    this.contadorTurnos = cont;
  }

  void realizaTurno(){
    contadorTurnos--;
  }

  void pideTurno(){
    contadorTurnos++;
  }

//Maquinista.fromSnapShot(String idMaquinista, Map<String, dynamic> maquinista):


}