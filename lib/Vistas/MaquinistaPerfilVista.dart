
import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:image_picker/image_picker.dart';
import 'package:turnetes/DrawerWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

import 'package:turnetes/photoPreviewScreen2.dart';



import '../Controladores/LoginControl.dart';
import '../Modelos/ModeloMaquinista.dart';
import '../my_flutter_app_icons.dart';


class MaquinistaPerfilVista extends StatelessWidget {

  ModeloMaquinista maquinista;

  MaquinistaPerfilVista(this.maquinista);

  TextStyle _style(){
    return TextStyle(
        fontWeight: FontWeight.bold
    );
  }

  @override
  Widget build(BuildContext context) {
    final LoginControl loginControl = LoginControl(context);
    return Scaffold(
      appBar: CustomAppBar(maquinista),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child:  SingleChildScrollView(
          child: Column(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Nombre:" ,  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4,),
                    Text(maquinista.nombre, style: TextStyle(fontSize: 20)),
                    SizedBox(height: 16,),

                    Text("Apodo:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4,),
                    Text(maquinista.apodo, style: TextStyle(fontSize: 20)),
                    SizedBox(height: 16,),

                    Text("Correo:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4,),
                    Text(maquinista.correo, style: TextStyle(fontSize: 20)),
                    SizedBox(height: 16,),

                    Text("Teléfono exterior", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4,),
                    Text(maquinista.telefonoExt, style: TextStyle(fontSize: 20)),
                    SizedBox(height: 16,),

                    Text("Teléfono interior:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4,),
                    Text(maquinista.telefonoInt, style: TextStyle(fontSize: 20)),
                    SizedBox(height: 16,),

                    Divider(color: Colors.grey,),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.purple,
                        ),
                        child: Text("cerrar sesion de usuario "),
                        onPressed: () async{
                          loginControl.eventLogOutUser(context);
                        },
                      ),
                    ),
                  ],
                ),
              ]
          ),
        )
      ),
    );
  }



}


//final String url = "http://chuteirafc.cartacapital.com.br/wp-content/uploads/2018/12/15347041965884.jpg";

class CustomAppBar extends StatelessWidget
    with PreferredSizeWidget{

  File? imagen = null;
  final picker = ImagePicker();
  XFile? imageSelected;
  ModeloMaquinista maquinista;
  CustomAppBar(this.maquinista);


  @override
  Size get preferredSize => Size(double.infinity, 400);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Mi perfil'),
          backgroundColor: Colors.purple,
        ),
        drawer: DrawerWidget(),
        body: ClipPath(
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

            child: Column(
              children: <Widget>[
                SizedBox(height: 30,),
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
                            image: elegirImagen(maquinista.imagePath),
                          ),
                        ),
                        //SizedBox(height: 16,),
                        Text(maquinista.apodo, style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                        )
                      ],
                    ),



                    Column(
                      children: <Widget>[
                        Text("Turnos:", style: TextStyle(
                            fontSize: 40,
                            color: Colors.white
                        ),),
                        Row(
                          children: <Widget>[
                            (maquinista.contadorTurnos > 0) ? Icon(Icons.arrow_drop_up_sharp,  color: Colors.green, size: 100) :  (maquinista.contadorTurnos < 0) ? Icon(Icons.arrow_drop_down, color: Colors.red,size: 100) : Icon(MyFlutterApp.eq, size: 100,color: Colors.white),
                            Text(getSigno(maquinista.contadorTurnos)+ maquinista.contadorTurnos.toString(), style: TextStyle(
                                fontSize: 80,
                                color: Colors.white
                            ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text("Festivos: ", style: TextStyle(
                                fontSize: 30,
                                color: Colors.white
                            )
                            ),
                            Text(getSigno(maquinista.contadorFestivos), style: TextStyle(
                                fontSize: 40,
                                color: Colors.white
                            )
                            ),
                            Text(maquinista.contadorFestivos.toString(), style: TextStyle(
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

                Align(
                  alignment: Alignment.bottomRight,
                  child: GestureDetector(
                    onTap: () async{
                      //print("//TODO: button clicked");
                      Navigator.push(context, MaterialPageRoute(builder: (context) => PhotoPreviewScreen2(maquinista)));



                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 24, 16, 0),
                      child: Transform.rotate(
                        angle: (math.pi * 0.05),
                        child: Container(
                          width: 110,
                          height: 32,
                          child: Center(child: Text("Editar Foto"),),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(16)),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 20
                                )
                              ]
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        )
    );
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

  String getSigno(int contador){
    if(contador > 0){
      return "+";
    }
    else{
      return "";
    }
  }





  /*

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


   */





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
