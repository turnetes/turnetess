import 'package:flutter/material.dart';

class ModeloTurno{

  late String idTurno;
  String? idMaquinistaPide;
  int? clave;
  DateTime fecha;
  String? idMaquinistaCandidato;
  String? grafico;
  bool? visto = false;



  ModeloTurno(this.clave,this.fecha,this.grafico, this.idMaquinistaCandidato,this.idMaquinistaPide, this.idTurno);

  setVisto(){
    this.visto = true;
  }

  /*
  Map<String,dynamic> toJson(){
    DateTime fechaString = DateTime(fecha.year,fecha.month,fecha.day);
    return {
      "idTurno": this.idTurno,
      "idMaquinistaPide": this.idMaquinistaPide,
      "idMaquinistaCandidato" : this.idMaquinistaCandidato,
      "fecha": fechaString.toString(),
    };
  }

   */

  Map<String,dynamic> fromJson(){
    DateTime fechaString = DateTime(fecha.year,fecha.month,fecha.day);
    return {
      "idTurno": this.idTurno,
      "idMaquinistaPide": this.idMaquinistaPide,
      "idMaquinistaCandidato" : this.idMaquinistaCandidato,
      "fecha": fechaString.toString(),
    };
  }


}