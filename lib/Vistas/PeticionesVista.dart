import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:turnetes/Controladores/PeticionesControlador.dart';
import 'package:intl/intl.dart';
import '../DrawerWidget.dart';
import '../Modelos/ModeloTurno.dart';
import 'PeticionConfirmacionVista.dart';


class PeticionesVista extends StatelessWidget{


  List<ModeloTurno>? listaPeticiones;

  PeticionesVista(this.listaPeticiones,context);

  @override
  Widget build(BuildContext context){
    print("ENTRA POR VISTAPETICIONES");
    print(listaPeticiones![0].fecha.day
        .toString());
    return  Scaffold(
        appBar: AppBar(
          title: const Text("Peticiones"),
          backgroundColor: Colors.purple,
        ),
        drawer: DrawerWidget(),
        body: Container(
          child: ListView.builder(
              itemCount: listaPeticiones!.length,
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
                              Text( listaPeticiones![index].fecha.day
                                  .toString() + "/" +
                                  listaPeticiones![index].fecha.month
                                      .toString()
                                , style: TextStyle(color: listaPeticiones![index].visto! ? Colors.white : Colors.yellowAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,),
                              ),
                              Text(sacarDiaSemana(listaPeticiones![index].fecha),
                                  style: TextStyle(color: listaPeticiones![index].visto! ? Colors.white : Colors.yellowAccent,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,)
                              )
                            ],
                          ),
                        ),
                      ),
                      title: Text("Turno:   " +
                          listaPeticiones![index].clave.toString(),
                        style: TextStyle(color: listaPeticiones![index].visto! ? Colors.white : Colors.yellowAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,),
                      ),
                      // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),
                      subtitle: Row(
                        children: <Widget>[
                          Icon(Icons.linear_scale,
                              color: Colors.yellowAccent),
                          Text(sacarGrafico(
                              listaPeticiones![index].clave!)
                              .toString(),
                              style: TextStyle(color: listaPeticiones![index].visto! ? Colors.white : Colors.yellowAccent))
                        ],
                      ),
                      trailing: IconButton(icon: Icon(Icons.keyboard_arrow_right,
                        color: listaPeticiones![index].visto! ? Colors.white : Colors.yellowAccent, size: 30.0,
                      ),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => PeticionConfirmacionVista(listaPeticiones![index])));
                          }
                      ),
                    ),
                  ),
                );
              })
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              PeticionesControlador peticionesControlador = PeticionesControlador();
              peticionesControlador.launchPedirDiaVista(context);

            },
            child: const Icon(Icons.add, size: 30),
            backgroundColor: Colors.purple
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat

    );
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