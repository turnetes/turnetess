import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:turnetes/Modelos/ModeloAsignacion.dart';
import '../Modelos/ModeloTurno.dart';

class AsignacionesDatos{

  static final AsignacionesDatos _AsignacionesDatos = AsignacionesDatos
      ._internal();


  factory AsignacionesDatos() {
    return _AsignacionesDatos;
  }

  AsignacionesDatos._internal();

  Future<Map<DateTime,dynamic>> getMapCalendarioAsignaciones() async{
    Map<DateTime,dynamic> map = {};
    var datos = await FirebaseFirestore.instance.collection(
        "listaAsignacionesTurnos").get();
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    List<ModeloAsignacion> listaAsignaciones = [];
    if (datos.size != 0) {
      print("UID =" + uid!);
      print("TAMAÑO DE LA LISTAASIGNACIONES =" + datos.docs.length.toString());
      for (int i = 0; i < datos.docs.length; i++) {
        print("IMPRIMiMOS EL MAP FiNAL A CARGAR1: ");
        ModeloAsignacion asignacion = ModeloAsignacion(
            datos.docs[i].data()['clave'],
            datos.docs[i].data()['fechaAceptacion'].toDate(),
            datos.docs[i].data()['fechadiaTurno'].toDate(),
            datos.docs[i].data()['idAsignacionTurno'],
            datos.docs[i].data()['idMaquinistaPide'],
            datos.docs[i].data()['idMaquinistaRealizaTurno']);
        print(asignacion.idMaquinistaPide);
        if ((asignacion.idMaquinistaRealizaTurno == uid) ||
            (asignacion.idMaquinistaPide == uid)) {
          print("ALGUNO CUMPLE@@@@@@@" + i.toString());
          print(asignacion.fechadiaTurno);
          print(asignacion.idAsignacionTurno);
          DateTime time = datos.docs[i].data()['fechadiaTurno'].toDate();
          DateTime time2 = DateTime(time.year, time.month, time.day);
          //var title = datos.docs[i].data()['clave'].toString();
          //map[time2] = asignacion ;
          if (map.containsKey(time2)) {
            map[time2].add(asignacion);
          }
          else {
            map[time2] = [];
            map[time2].add(asignacion);
          }
        }
      }
    }

    print("IMPRIMiMOS EL MAP FiNAL A CARGAR: " + map.toString());
    return map;

  }


  //PeticionDia envia peticion desde el PeticionControlador:

  Future<bool> checkRestriccion2PeticionDia(DateTime fechaTurno) async {//QUE NO ES LO MISMO QUE HABER SOLICITADO TURNO ESE DIA sINO K YA ME LO CUBREN
    bool cumpleRestriccion2 = true;
    var datos = await FirebaseFirestore.instance.collection(
        "listaAsignacionesTurnos").get();
    //Antes de ver si cubro un turno ese dia, tengo k comprobar que no haya solicitado una peticion de turno ese mismo dia
    datos.docs.forEach((element) {
      if ((fechaTurno.isAtSameMomentAs(element.data()['fechadiaTurno'].toDate())) &&
          element.data()['idMaquinistaPide'] == FirebaseAuth.instance.currentUser!.uid){
        print("SE CUMPLEEEEEEEE MAQUINISTA YA ME CUBREN ESE DIA");
        cumpleRestriccion2 = false;
      }

    });
    return cumpleRestriccion2;
  }


  //PeticionConfirmacion.dart:
  Future<bool?> getCandidatoHaciaYaTurnoEseDiaPeticionConfirmacion(ModeloTurno turno, String idSolicita) async {
    bool haceTurno = false;
    var datos = await FirebaseFirestore.instance.collection(
        "listaAsignacionesTurnos").get();
    //Antes de ver si cubro un turno ese dia, tengo k comprobar que no haya solicitado una peticion de turno ese mismo dia
    datos.docs.forEach((element) {
      if ((turno.fecha.isAtSameMomentAs(element.data()['fechadiaTurno'].toDate())) &&
          element.data()['idMaquinistaRealizaTurno'] == idSolicita){
        print("SE CUMPLEEEEEEEE MAQUINISTA CUBRE YA TURNO ESE DIA");
        haceTurno = true;
      }

    });
    return haceTurno;
  }

  Future<void> addAsignacionOfrecimiento(ModeloTurno turno, int clave) async {
    FirebaseFirestore.instance.collection('listaAsignacionesTurnos').add(
        {
          'clave': clave,
          'idMaquinistaPide': FirebaseAuth.instance.currentUser!.uid,
          'idMaquinistaRealizaTurno': turno.idMaquinistaCandidato,
          'fechaAceptacion': DateTime.now(),
          'fechadiaTurno': turno.fecha
        }
    ).then((value){
      FirebaseFirestore.instance.collection('listaAsignacionesTurnos').doc(value.id).set(
          {
            "idAsignacionTurno" : value.id,
          },SetOptions(merge: true)).then((_){
        print("successNUEVO!");
      });
    });
    //actualizarContadorTurnos();
  }

  Future<void> addAsignacionPeticion(ModeloTurno turno) async {
    FirebaseFirestore.instance.collection('listaAsignacionesTurnos').add(
        {
          'clave': turno.clave,
          'idMaquinistaPide': turno.idMaquinistaPide,
          'idMaquinistaRealizaTurno': FirebaseAuth.instance.currentUser?.uid,
          'fechaAceptacion': DateTime.now(),
          'fechadiaTurno': turno.fecha
        }
    ).then((value){
      FirebaseFirestore.instance.collection('listaAsignacionesTurnos').doc(value.id).set(
          {
            "idAsignacionTurno" : value.id,
          },SetOptions(merge: true)).then((_){
        print("successNUEVO!");
      });
    });
    //actualizarContadorTurnos();
  }


  //OfrecimientoDia envia peticion desde el OfrecimientoControlador:
  Future<bool> checkRestriccion2OfrecimientoDia(DateTime fechaSeleccionada) async{
    bool haceTurno = true;
    var datos = await FirebaseFirestore.instance.collection(
        "listaAsignacionesTurnos").get();
    //Antes de ver si cubro un turno ese dia, tengo k comprobar que no haya solicitado una peticion de turno ese mismo dia
    datos.docs.forEach((element) {
      if ((fechaSeleccionada.isAtSameMomentAs(element.data()['fechadiaTurno'].toDate())) &&
          element.data()['idMaquinistaRealizaTurno'] == FirebaseAuth.instance.currentUser!.uid){
        print("SE CUMPLEEEEEEEE MAQUINISTA YA LE HACIAN ESE DIA");
        haceTurno = false;
      }

    });
    return haceTurno;
  }


  //AsignacionAcuerdoPersonalVista borra una asignacion porque algun maquinista elimina el acuerdo
  void deleteAsignacion(String idTurno){
    FirebaseFirestore.instance.collection("listaAsignacionesTurnos").doc(idTurno).delete().then((_){
      print("TURNO BORRADO!!!");
    });
  }




}