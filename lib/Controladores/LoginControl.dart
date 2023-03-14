import 'dart:async';
import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:localstorage/localstorage.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:turnetes/Datos/MaquinistasDatos.dart';
import 'dart:io';
import 'package:cross_file/cross_file.dart';
import 'package:image_picker/image_picker.dart';
import 'package:turnetes/Vistas/LoginResetPassVista.dart';
import 'package:turnetes/Vistas/ProteccionDatosVista.dart';
import '../Modelos/ModeloTurno.dart';
import '../Vistas/LoginRegisterVista.dart';
import '../Vistas/LoginVista.dart';
import '../Datos/PeticionesDatos.dart';
import '../Vistas/PeticionesVista.dart';




class LoginControl {

  BuildContext context;

  LoginControl(this.context);

  PeticionesDatos peticionesDatos = PeticionesDatos();
  MaquinistasDatos maquinisitasDatos = MaquinistasDatos();


   checkUser(String mail,String pass,LoginVista loginVista) async {
     print("ENTRA POR AQUI CHECKUSER");
     User? user = await maquinisitasDatos.checkUser(mail, pass);
     print("SALE POR AQUI CHECKUSER");
     if (user == null) {
       print("USER ES NULL");

       //Usuario no registrado
       loginVista.createState().showAlert("Usuario no registrado", context);
       Timer(Duration(seconds: 2),Navigator.of(context).pop);
     }
     else {

       //Usuario  registrado
       //Regisgro el token del telefono para envio notificaciones por API oneSignal
       MaquinistasDatos maquinistaDatos = MaquinistasDatos();
       maquinistaDatos.eventSaveTokenNotification(user.uid);
       //Lanzo AlertDialog "usuario Registrado"
       loginVista.createState().showAlert("Usuario registrado",context);
       //Timer(Duration(seconds: 2),Navigator.of(context).pop);
       List<ModeloTurno>? listaTurnos = await peticionesDatos.pasarListaTurnos();
       print("USER NO ES NULL Y ES = " + user.uid);
       Navigator.pushAndRemoveUntil(
         context,
         MaterialPageRoute(
           builder: (BuildContext context) =>
               PeticionesVista(listaTurnos, context),
         ),
             (route) => false,
       );
     }
   }

  eventRemeberUser(bool isChecked,String mail, String pass){
     if(isChecked){
       List<String> usuario = [];
       usuario.add(mail);
       usuario.add(pass);
       maquinisitasDatos.saveJsonRememberMe(usuario);
     }
     else{
       print("CHEK = NULL = FALSE!!!!!!!!");
       maquinisitasDatos.deleteJsonRememberMe();
     }
   }

    saveRememberMe(user){
      maquinisitasDatos.saveJsonRememberMe(user);
      // storage.setItem('user', await json.encode(user)); LUEGO ACABAR JSON USER
    }

  eventLaunchResetPass(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginResetPassVista()));
  }

  eventLaunchRegisterPage1(){
    //Navigator.push(context, MaterialPageRoute(builder: (context) => LoginRegister1Vista(this)));
    Navigator.push(context, MaterialPageRoute(builder: (context) => NewRegisterVista(this)));
  }
  


  launchVista() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => LoginVista()));
  }



  eventLogOutUser(BuildContext context){
    maquinisitasDatos.eventLogOutUser();
    showAviso(context,"AVISO","Sesión de usuario cerrada.");
  }

  eventRegisterUser(NewRegisterVista vista, String mail,String pass,String nombre,String apodo,XFile? imageSelected,File? imagen,String telfInt,String telfExt) async {
     final user = await maquinisitasDatos.eventRegisterUser(mail,pass);
     if(user != null){
       //Se registra correctamente
       final status = await OneSignal.shared.getDeviceState();
       String? oneSignalID = status!.userId;
       late String pathImagen;
       if (imageSelected != null) {
         pathImagen = await uploadImage(imageSelected);
       }
       else {
         if (imagen != null) {
           pathImagen = await uploadImagePhoto(imagen);
         }
       }
       maquinisitasDatos.eventRegisterUserFirebase(user.uid, nombre, apodo,mail,pathImagen,oneSignalID!,telfInt,telfExt);
       Navigator.push(context,
           MaterialPageRoute(builder: (context) => LoginVista()));
       vista.createState().showAlert4(context, "Usuario SI registrado");
       print("SE HA REGISTRADO!!!");
       Timer(Duration(seconds: 2),Navigator.of(context).pop);

     }
     else{
       //No ha sido posible registrarlo
       print("VIENE POR SHOWALERT!!!");
       Navigator.push(context,
           MaterialPageRoute(builder: (context) => LoginVista()));
       vista.createState().showAlert4(context, "Usuario no registrado");
       print("VIENE POR SHOWALERT2!!!");
       Timer(Duration(seconds: 2),Navigator.of(context).pop);

     }
  }

  Future<String> uploadImage(XFile image) async {
    Reference db = FirebaseStorage.instance.ref(
        "images/${getImageName(image)}");
    await db.putFile(File(image.path));
    return await db.getDownloadURL();
  }

  Future<String> uploadImagePhoto(File image) async {
    Reference db = FirebaseStorage.instance.ref(
        "images/${getImageNamePhoto(image)}");
    await db.putFile(File(image.path));
    return await db.getDownloadURL();
  }

  String getImageName(XFile image) {
    return image.path
        .split("/")
        .last;
  }

  String getImageNamePhoto(File image) {
    return image.path
        .split("/")
        .last;
  }

  launchLeyProteccionDatos(){
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ProteccionDatosVista()));
  }

  //Reset Password:
  sendMailResetPass(BuildContext context,String mail) async{
    maquinisitasDatos.sendMailResetPass(mail);
    showAviso(context,"AVISO","Se le ha enviado un correo a su mail para que cambie la contraseña");
  }

  showAviso(BuildContext context,String title, String content){
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.purple,
              ),
              onPressed: () {
                launchVista();
              },
              child: Text('OK'))
        ],
      ),
    );
  }
  

}