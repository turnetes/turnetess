import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:localstorage/localstorage.dart';
import 'package:intl/intl.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import '../Modelos/ModeloMaquinista.dart';
import '../Modelos/ModeloTurno.dart';

class MaquinistasDatos {

  static final MaquinistasDatos _Maquinistasdatos = MaquinistasDatos
      ._internal();


  factory MaquinistasDatos() {
    return _Maquinistasdatos;
  }

  MaquinistasDatos._internal();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore instance = FirebaseFirestore.instance;
  LocalStorage storage = new LocalStorage('peticiones.json');
  late UserCredential? user;

  Future<ModeloMaquinista?> getMaquinista(String idMaquinista) async {
    ModeloMaquinista? maquinista;
    //String? idMaquinista = FirebaseAuth.instance.currentUser?.uid;
    await FirebaseFirestore.instance.collection("maquinistas").doc(idMaquinista)
        .get()
        .then((value) {
      maquinista = new ModeloMaquinista( value.data()!["apodo"].toString(),
          value.data()!["contadorFestivos"] as int,
          value.data()!["contadorTurnos"] as int,
          value.data()!["correo"].toString(),
          value.data()!["idMaquinista"].toString(),
          value.data()!["imagePath"],
          value.data()!["nombre"].toString(),
          value.data()!["oneSignalID"].toString(),
          value.data()!["passAdmin"] as bool,
          value.data()!["telfExt"].toString(),
          value.data()!["telfInt"].toString()

      );
    });
    print(maquinista?.apodo);
    return maquinista ;
  }

  //Listado de maquinistas
  Future<List<ModeloMaquinista>?> getListaMaquinistas() async {
    var datos = await FirebaseFirestore.instance.collection("maquinistas").get();
    List<ModeloMaquinista> listaMaquinistas = [];
    if (datos.size != 0) {
      for (int i = 0; i < datos.docs.length; i++) {
        ModeloMaquinista maq = ModeloMaquinista(
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

  //peticiones de Tokens de NotificacionesControl:
  Future<List<String>> getListaTokensMaquinistas() async {
    List<String>  listaIDoneSignalDevices = [];
    var collection = FirebaseFirestore.instance.collection('maquinistas');
    var querySnapshot = await collection.get();
    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data();
      var fooValue = data['oneSignalID'];
      listaIDoneSignalDevices.add(fooValue.toString());
    }
    return listaIDoneSignalDevices;
  }

  Future<String?> getTokenCandidato(String id) async{
    String? token;
    await FirebaseFirestore.instance.collection("maquinistas").doc(id)
        .get()
        .then((value) {
      token = value.data()!["oneSignalID"].toString();
    });
    return token;
  }

  //PETICIONESCONFIRMACION:
  void sumarTurnoMaquinista(DateTime fechaTurno,String idMaquinistaHaceTurno) {
    //suma turno al maquinista que realiza el turno
    if(sacarFestivos(fechaTurno)!){
      FirebaseFirestore.instance.collection("maquinistas").doc(idMaquinistaHaceTurno).update({
        "contadorFestivos" : FieldValue.increment(1),
        "contadorTurnos" : FieldValue.increment(1)});
    }
    else{
      FirebaseFirestore.instance.collection("maquinistas").doc(idMaquinistaHaceTurno).update({
        "contadorTurnos" : FieldValue.increment(1)});
    }
  }

  bool? sacarFestivos(DateTime? date2) {
    late String resp;
    if (date2 != null) {
      String dia = DateFormat('EEEE').format(date2);
      print("HOLAAAAAAAAAAAAAA HOY ES :$dia");
      switch (dia) {
        case "Monday":
          return false;
        case "Tuesday":
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

  void restarTurnoMaquinista(DateTime fechaTurno,String idMaquinistaPide){
    //el maquinista que confirma la peticion que es el que esta usando la app se le resta uno
    if(sacarFestivos(fechaTurno)!){
      FirebaseFirestore.instance.collection("maquinistas").doc(idMaquinistaPide).update({
        "contadorFestivos" : FieldValue.increment(-1),
        "contadorTurnos" : FieldValue.increment(-1)});
    }
    else{
      FirebaseFirestore.instance.collection("maquinistas").doc(idMaquinistaPide).update({
        "contadorTurnos" : FieldValue.increment(-1)});
    }
  }

  eventSaveTokenNotification(String idPropio) async{
    final status = await OneSignal.shared.getDeviceState();
    FirebaseFirestore.instance.collection("maquinistas").doc(idPropio).set(
        {
          'oneSignalID':  status!.userId,
        },SetOptions(merge: true)).then((_){
      //showAlert();
    });
  }


  //CONTROL LOGIN:

  /*
  Future<User?> checkUser(mail,pass) async {
    user = await auth.signInWithEmailAndPassword(email: mail, password: pass);
    print("POR AQUI LLEGA DEL LOGIN USER2!!!");
    return user!.user;
  }
   */

  Future<User?> checkUser(mail,pass) async {
    late UserCredential? usuario;
    try{
      usuario = await FirebaseAuth.instance.signInWithEmailAndPassword(email: mail, password: pass);
    } catch (e) {
      return null;
    }
    if(usuario != null){
      return usuario.user;
    }
  }


  saveJsonRememberMe(List<String> usuario) async {
    String reg = await json.encode(usuario);
    await storage.setItem('user', reg);
    print("JSON GUARDADO");

  }

  deleteJsonRememberMe() async{
    await storage.deleteItem('user');
  }


  eventLogOutUser() async {
    auth.signOut();
    LocalStorage storage = new LocalStorage('peticiones.json');
    await storage.ready;
    storage.deleteItem('user');
  }

  Future<User?> eventRegisterUser(String mail, String pass) async {
    late UserCredential? usuario;
    try{
      usuario = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: mail, password: pass);
    } catch (e) {
      return null;
    }
    if(usuario != null){
      return usuario.user;
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

  //Reset Password:
  sendMailResetPass(String mail) async{
    await FirebaseAuth.instance.sendPasswordResetEmail(email: mail);
  }

}
