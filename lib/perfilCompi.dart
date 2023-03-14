
import 'dart:async';

import 'dart:io' as IO;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:turnetes/DrawerWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:turnetes/photoPreviewScreen2.dart';
import 'package:turnetes/tomarFoto.dart';
import 'package:url_launcher/url_launcher_string.dart';


import 'Modelos/ModeloMaquinista.dart';

class PerfilCompi extends StatelessWidget {

  late ModeloMaquinista maq;

  PerfilCompi(this.maq);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(

          appBar: AppBar(
            title: const Text("Perfil Compañero"),
            backgroundColor: Colors.purple,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          body: Column(
            children: [
              CustomAppBar(maq),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Nombre:", style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                          SizedBox(height: 4,),
                          Text(maq.nombre, style: TextStyle(fontSize: 20)),
                          SizedBox(height: 16,),

                          Text("Apodo:", style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                          SizedBox(height: 4,),
                          Text(maq.apodo, style: TextStyle(fontSize: 20)),
                          SizedBox(height: 16,),

                          Text("Correo:", style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                          SizedBox(height: 4,),
                          Text(maq.correo, style: TextStyle(fontSize: 20)),
                          SizedBox(height: 16,),

                          Text("Teléfono interior:", style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                          SizedBox(height: 4,),
                          Text(maq.telefonoInt, style: TextStyle(fontSize: 20)),
                          SizedBox(height: 16,),

                          Text("Teléfono exterior", style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                          SizedBox(height: 4,),


                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(maq.telefonoExt + "       ", style: TextStyle(fontSize: 20)),
                              SizedBox(height: 16),
                              IconButton(
                                onPressed: () async{
                                  String url;
                                  var prefijo = "34";
                                  var phone = prefijo+maq.telefonoExt;
                                  var message = "Hola compañero soy " + maq.apodo+".......";
                                  if (IO.Platform.isIOS) {
                                    //url = "whatsapp://wa.me/$phone/?text=${Uri.encodeFull(message)}";
                                    //url = "whatsapp://wa.me/$phone/?text=${Uri.parse(message)}";
                                    //url = "whatsapp://send?phone=" + phone.replaceAll(' ', '');
                                    //url = "https://wa.me/15551234567";
                                    url = "https://wa.me/$phone/?text=${Uri.parse(message)}";
                                  } else {
                                    url = "whatsapp://send?phone=$phone&text=${Uri.encodeFull(message)}";
                                  }
                                  abrirNavegador(url);},
                                icon: Icon(Icons.whatsapp_rounded, color: Colors.green, size: 50),
                              )
                            ],
                          ),
                          Divider(color: Colors.grey,)
                        ],
                      ),
                    ]
                ),
              ),
            ],
          )
      ),
    );
  }

  Future<void> abrirNavegador(String url) async{

    if( await canLaunchUrlString(url)){
      await launchUrlString(url);
    }

  }

  String url() {
    var phone = "34622700281";
    var message = " hola Silvia";
    if (IO.Platform.isIOS) {
      return "whatsapp://wa.me/$phone/?text=${Uri.encodeFull(message)}";
    } else {
      return "whatsapp://send?phone=$phone&text=${Uri.encodeFull(message)}";
    }
  }


  Future<ModeloMaquinista?> getMaquinista() async {
    ModeloMaquinista? maquinista;
    String? idMaquinista = FirebaseAuth.instance.currentUser?.uid;
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
    print("HOLAAAAAAAAAAAA!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
    print(maquinista?.apodo);
    return maquinista ;
  }

}


//final String url = "http://chuteirafc.cartacapital.com.br/wp-content/uploads/2018/12/15347041965884.jpg";

class CustomAppBar extends StatelessWidget
    with PreferredSizeWidget{

  late ModeloMaquinista maq;
  final picker = ImagePicker();
  XFile? imageSelected;

  CustomAppBar(this.maq);



  @override
  Size get preferredSize => Size(double.infinity,320);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
        clipper: MyClipper(),
        child: Container(
          padding: EdgeInsets.only(top: 4),
          decoration: BoxDecoration(
            //color: Colors.redAccent,
              color: Colors.purple,
              boxShadow: [
                BoxShadow(
                    color: Colors.red,
                    blurRadius: 20,
                    offset: Offset(0, 0)
                )
              ]
          ),

          child:  Column(
            children: <Widget>[

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[

                  Column(
                    children: <Widget>[
                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: elegirImagen(maq.imagePath),
                        ),
                      ),
                      //SizedBox(height: 16,),
                      Text(maq.apodo, style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                      )
                    ],
                  ),



                  Column(
                    children: <Widget>[
                      Text("Turnos", style: TextStyle(
                          fontSize: 40,
                          color: Colors.white
                      ),),
                      Row(
                        children: <Widget>[
                          Text(getSigno(maq.contadorTurnos), style: TextStyle(
                              fontSize: 80,
                              color: Colors.white
                          )
                          ),
                          Text(maq.contadorTurnos.toString(), style: TextStyle(
                              fontSize: 80,
                              color: Colors.white
                          ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text("Festivos: ", style: TextStyle(
                              fontSize: 40,
                              color: Colors.white
                          )
                          ),
                          Text(getSigno(maq.contadorFestivos), style: TextStyle(
                              fontSize: 40,
                              color: Colors.white
                          )
                          ),
                          Text(maq.contadorFestivos.toString(), style: TextStyle(
                              fontSize: 40,
                              color: Colors.white
                          )
                          ),
                        ],
                      )


                    ],
                  ),

                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[



                  SizedBox(width: 32,),



                  SizedBox(width: 16,)

                ],
              ),
              SizedBox(height: 8,),


              SizedBox(height: 50,),

            ],
          ),
        )
    );

  }



  String getSigno(int contador){
    if(contador > 0){
      return "+";
    }
    else{
      return "";
    }
  }

  DecorationImage elegirImagen(String url){
    if(url == ""){
      return DecorationImage(  image: AssetImage('assets/anonimo.jpg'));
    }
    else{
      return DecorationImage(image: NetworkImage(url));
    }
  }






  Future<ModeloMaquinista?> getMaquinista() async {
    ModeloMaquinista? maquinista;
    String? idMaquinista = FirebaseAuth.instance.currentUser?.uid;
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
        value.data()!["telfInt"].toString(),

      );
    });
    print("HOLAAAAAAAAAAAA!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
    print(maquinista?.apodo);
    return maquinista ;
  }




}



class MyClipper extends CustomClipper<Path>{

  @override
  Path getClip(Size size) {
    Path p = Path();

    p.lineTo(0, size.height-70);
    p.lineTo(size.width, size.height);

    p.lineTo(size.width, 0);

    p.close();

    return p;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

