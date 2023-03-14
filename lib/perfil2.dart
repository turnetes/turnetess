/*
import 'dart:async';
import 'dart:io';

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


import 'Modelos/ModeloMaquinista.dart';

class Perfil2 extends StatefulWidget {
  @override
  _ProfilePageDesignState createState() => _ProfilePageDesignState();
}

class _ProfilePageDesignState extends State<Perfil2> {


  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIOverlays([]);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(

        appBar: AppBar(
          title: const Text("Perfil"),
          backgroundColor: Colors.purple,
        ),
        drawer: DrawerWidget(),
        body: ProfilePage(),
        //debugShowCheckedModeBanner: false,
      ),
    );

  }

/*
  new UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.white),
              currentAccountPicture: new CircleAvatar(
                radius: 50.0,
                backgroundColor: const Color(0xFF778899),
                backgroundImage:
                    NetworkImage("http://tineye.com/images/widgets/mona.jpg"),
              ),
            ),


  WIDGET BUILD ANTERIOR A LA MODIFICACION

  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Perfil",
      home: ProfilePage(),
      debugShowCheckedModeBanner: false,
    );
  }

   */
}

class ProfilePage extends StatelessWidget {



  TextStyle _style(){
    return TextStyle(
        fontWeight: FontWeight.bold
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: FutureBuilder<Maquinista?>(
            future: getMaquinista(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Nombre:" ,  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          SizedBox(height: 4,),
                          Text(snapshot.data!.nombre, style: TextStyle(fontSize: 20)),
                          SizedBox(height: 16,),

                          Text("Apodo:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          SizedBox(height: 4,),
                          Text(snapshot.data!.apodo, style: TextStyle(fontSize: 20)),
                          SizedBox(height: 16,),

                          Text("Correo:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          SizedBox(height: 4,),
                          Text(snapshot.data!.correo, style: TextStyle(fontSize: 20)),
                          SizedBox(height: 16,),

                          Text("Teléfono exterior", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          SizedBox(height: 4,),
                          Text(snapshot.data!.telefonoExt, style: TextStyle(fontSize: 20)),
                          SizedBox(height: 16,),

                          Text("Teléfono interior:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          SizedBox(height: 4,),
                          Text(snapshot.data!.telefonoInt, style: TextStyle(fontSize: 20)),
                          SizedBox(height: 16,),

                          Divider(color: Colors.grey,)
                        ],
                      ),
                    ]
                );
              };
              return const Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }

  Future<Maquinista?> getMaquinista() async {
    Maquinista? maquinista;
    String? idMaquinista = FirebaseAuth.instance.currentUser?.uid;
    await FirebaseFirestore.instance.collection("maquinistas").doc(idMaquinista)
        .get()
        .then((value) {
      maquinista = new Maquinista( value.data()!["apodo"].toString(),
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

  File? imagen = null;
  final picker = ImagePicker();
  XFile? imageSelected;



  @override
  Size get preferredSize => Size(double.infinity, 320);

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

        child: FutureBuilder<Maquinista?>(
            future: getMaquinista(),
            builder: (context, snapshot){
              if (snapshot.hasData) {
                String signo = "";
                if(snapshot.data!.contadorTurnos > 0){
                  signo = "+";
                }
                else{
                  if(snapshot.data!.contadorTurnos == 0){
                    signo = "";
                  }
                }
                return Column(
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
                                image: elegirImagen(snapshot.data!.imagePath),
                              ),
                            ),
                            //SizedBox(height: 16,),
                            Text(snapshot.data!.apodo, style: TextStyle(
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
                                Text(signo, style: TextStyle(
                                    fontSize: 80,
                                    color: Colors.white
                                )
                                ),
                                Text(snapshot.data!.contadorTurnos.toString(), style: TextStyle(
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
                                Text(getSigno(snapshot.data!.contadorFestivos), style: TextStyle(
                                    fontSize: 40,
                                    color: Colors.white
                                )
                                ),
                                Text(snapshot.data!.contadorFestivos.toString(), style: TextStyle(
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
                          Navigator.push(context, MaterialPageRoute(builder: (context) => PhotoPreviewScreen2(snapshot.data!)));


    
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
                );
              }
              return const Center(child: CircularProgressIndicator());
            }),

      ),
    );
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






  Future<Maquinista?> getMaquinista() async {
    Maquinista? maquinista;
    String? idMaquinista = FirebaseAuth.instance.currentUser?.uid;
    await FirebaseFirestore.instance.collection("maquinistas").doc(idMaquinista)
        .get()
        .then((value) {
      maquinista = new Maquinista( value.data()!["apodo"].toString(),
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

 */